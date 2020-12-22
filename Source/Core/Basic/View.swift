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

public protocol View {
    // 初始视图层次
    var type: ArgoKitNodeType{get}
    // 布局节点对象
    var node:ArgoKitNode?{get}
    
    @ArgoKitViewBuilder var body: View { get }
    
}

public extension View{
    
    @ArgoKitViewBuilder var body: View {
        ViewEmpty()
    }
    var type: ArgoKitNodeType{
        if let _node:ArgoKitNode = node {
            return .single(_node)
        }else{
            return .empty
        }
    }
}

extension View{
    public static func ViewNode()->ArgoKitNode{
        return ArgoKitNode(viewClass: UIView.self)
    }
}

extension View{
    @discardableResult
    @available(*, deprecated, message: "alias(variable ptr:inout) had been deprecated")
    public func alias<T>(variable ptr:inout T?) -> Self where T: View{
        ptr = self as? T
        return self
    }
    
    @discardableResult
    public func alias(variable: Alias<Self>) -> Self {
        variable.wrappedValue = self
        return self 
    }
}

extension View{
    public func addSubNodes(@ArgoKitViewBuilder builder:@escaping ()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}


extension View {
    @discardableResult
    public func endEditing(_ force: Bool) -> Self {
        self.node?.view?.endEditing(force)
        return self
    }
}

