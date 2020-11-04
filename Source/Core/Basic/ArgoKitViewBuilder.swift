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
        return ArgoNodeContainer(withNodes: items);
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
            pNode = nodeType.viewNode()
        }
    }
}

public class ViewEmpty: View {
    public var body: View{
        self
    }
    public var type: ArgoKitNodeType{
        .empty
    }
    public var node: ArgoKitNode?{
        nil
    }
    
    
}
