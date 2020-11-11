//
//  ArgoViewBuilder.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
import UIKit
@_functionBuilder
public struct ArgoKitViewBuilder {
    public static func buildBlock(_ items:View...) -> View{
        var results = [View]()
         for item in items {
            if item is ArgoNodeContainer{
                results.append(item)
                continue
            }
             if (item.node == nil) {
                 results.append(item.body)
             }else{
                 results.append(item)
             }
         }
        return ArgoNodeContainer(withNodes: results);
    }
}

@_functionBuilder
public struct ArgoKitListBuilder {
    public static func buildBlock(_ items:View...) -> View{
        var results = [View]()
         for item in items {
            if item is ArgoNodeContainer{
                results.append(item)
                continue
            }
             if (item.node == nil) {
                results.append(item.body)
             }else{
                 results.append(item)
             }
         }
        return ArgoNodeContainer(withNodes: results);
    }
    public static func buildDo(_ value: View) -> View{
        return value
    }
    public static func buildIf(_ view: View?) -> View{
        view ?? ViewEmpty()
    }
    public static func buildEither(first:View) -> View{
      return first
    }
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
            switch view.type{
            case .single(let node):
                container.append(node)
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

public class ViewEmpty: View {
    public var body: View{
        ViewEmpty()
    }
    public var type: ArgoKitNodeType{
        .empty
    }
    public var node: ArgoKitNode?{
        nil
    }
    
    
}
