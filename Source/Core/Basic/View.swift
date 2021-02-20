//
//  NodeView.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation

public enum ArgoKitNodeType {
    case empty
    case multiple([ArgoKitNode])
    case single(ArgoKitNode)
    
    public func viewNode() -> ArgoKitNode? {
        switch self {
        case .empty:
            return nil
        case .single(let node):
            return node
        case .multiple(let nodes):
            let container = ArgoKitNode(view: UIView())
            for node in nodes {
                container.addChildNode(node)
            }
            return container
        }
    }
    
    public func viewNodes() -> [ArgoKitNode]? {
        switch self {
        case .empty:
            return nil
        case .multiple(let nodes):
            return nodes
        case .single(let node):
            return [node]
        }
    }
}

/// A type that represents part of your app’s user interface and provides modifiers that you use to configure views.
public protocol View {
    
    /// The type of the node.
    /// Required. Default implementations provided.
    var type: ArgoKitNodeType { get }
    
    /// The node behind the view.
    /// Required.
    var node:ArgoKitNode? { get }
    
    /// The content and behavior of the view.
    /// Required. Default implementations provided.
    @ArgoKitViewBuilder var body: View { get }
}

public extension View {
    
    @ArgoKitViewBuilder var body: View {
        ViewEmpty()
    }
    
    var type: ArgoKitNodeType {
        if let _node: ArgoKitNode = node {
            return .single(_node)
        }else{
            return .empty
        }
    }
}

extension View {
    
    public static func ViewNode () -> ArgoKitNode {
        return ArgoKitNode(viewClass: UIView.self)
    }
}

extension View {
    /*
    @discardableResult
    @available(*, deprecated, message: "alias(variable ptr:inout) had been deprecated")
    public func alias<T>(variable ptr:inout T?) -> Self where T: View{
        ptr = self as? T
        return self
    }
    */
    
    /// Assigns the view to the specified variable or property.
    /// - Parameter variable: The specified variable or property that is  assigned with the view.
    /// - Returns: self
    ///
    ///```
    ///    struct DemoView: View {
    ///        @Alias var text: Text?
    ///        var body: View {
    ///            Text("Hello, ArgoKit").alias(variable: $text)
    ///        }
    ///    }
    ///```
    ///
    @discardableResult
    public func alias(variable: Alias<Self>) -> Self {
        variable.wrappedValue = self
        return self 
    }
}

extension View {
    
    /// Get view that belong to node.
    /// - Parameter view: hat belong to node.
    public func nodeView() -> UIView?{
        return self.node?.nodeView()
    }
    
    /// Adds sub views to this view hierarchy.
    /// - Parameter builder: A view builder that creates the sub views of this view.
    public func addSubViews(@ArgoKitViewBuilder builder:@escaping ()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}

extension View {
    
    /// Causes the view (or one of its embedded text fields) to resign the first responder status.
    /// - Parameter force: Specify true to force the first responder to resign, regardless of whether it wants to do so.
    /// - Returns: self
    @discardableResult
    public func endEditing(_ force: Bool) -> Self {
        addAttribute(#selector(UIView.endEditing(_:)), force)
        return self
    }
}

