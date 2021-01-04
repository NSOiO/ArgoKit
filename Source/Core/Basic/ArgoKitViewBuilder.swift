//
//  ArgoViewBuilder.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
import UIKit

/// A custom parameter attribute that constructs views from closures.
///
/// You typically use ``ArgoKitViewBuilder`` as a parameter attribute for child
/// view-producing closure parameters, allowing those closures to provide
/// multiple child views. For example, the following `contextMenu` function
/// accepts a closure that produces one or more views via the view builder.
///
///```
///     func contextMenu<MenuItems : View>(
///         @ArgoKitViewBuilder menuItems: () -> MenuItems
///     ) -> View
///```
///
/// Clients of this function can use multiple-statement closures to provide
/// several child views, as shown in the following example:
///
///```
///     myView.contextMenu {
///         Text("Cut")
///         Text("Copy")
///         Text("Paste")
///         if isSymbol {
///             Text("Jump to Definition")
///         }
///     }
///```
///
@_functionBuilder public struct ArgoKitViewBuilder {
    
    /// Passes views written as a child view through unmodified.
    ///
    /// An example of a single view written as a child view is
    /// `{ Text("Hello") }`.
    public static func buildBlock(_ items:View...) -> View{
        return ArgoNodeContainer(withNodes: items);
    }
}

/// A custom parameter attribute that constructs views from closures.
@_functionBuilder public struct ArgoKitListBuilder {
    
    /// Passes views written as a child view through unmodified.
    public static func buildBlock(_ items:View...) -> View{
        return ArgoNodeContainer(withNodes: items);
    }
    
    /// Provides support for “do” statements in multi-statement closures.
    public static func buildDo(_ value: View) -> View{
        return value
    }
    
    /// Provides support for “if” statements in multi-statement closures.
    public static func buildIf(_ view: View?) -> View{
        view ?? ViewEmpty()
    }
    
    /// Provides support for “if-else” statements in multi-statement closures.
    public static func buildEither(first:View) -> View{
      return first
    }
    
    /// Provides support for “if-else” statements in multi-statement closures.
    public static func buildEither(second: View) ->View {
      return second
    }
}

public struct ArgoNodeContainer: View {
    public var body: View{
        ViewEmpty()
    }
    
    private var nodeType:ArgoKitNodeType
    private var pNode:ArgoKitNode?
    
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        nodeType
    }
    
    public init(withNodes views:[View]) {
        var container:[ArgoKitNode] = []
        for view in views {
            if view is ViewEmpty {
                continue
            }
            switch view.type{
            case .single(let node):
                container.append(node)
                let body = view.body
                if let nodes =  body.type.viewNodes(){
                    for subNode in nodes {
                        node.addChildNode(subNode)
                    }
                }
            case .multiple(let nodes):
                container.append(contentsOf:nodes)
            default:
                ()
            }
        }
        if container.count == 0 {
            nodeType = .empty
        }else if container.count == 1 {
            nodeType = .single(container[0])
        }else {
            nodeType = .multiple(container)
        }
    }
}

class ViewEmpty: View {
    
    public var body: View {
        ViewEmpty()
    }
    
    public var type: ArgoKitNodeType {
        .empty
    }
    
    public var node: ArgoKitNode? {
        nil
    }
}
