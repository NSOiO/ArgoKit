//
//  ArgoKitForEach.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

public struct ForEach:View{
    public var body: View{
        BaseViewEmpty()
    }
    
    private var innerNode:ArgoKitNode
    
    public var node: ArgoKitNode?{
        innerNode
    }
    private var innerView:UIView
    public var type: ArgoKitNodeType{
        .single(innerNode)
    }
    
    public init(_ items:Array<Any>,@ArgoKitViewBuilder _ builder:(_ item:Any)->View) {
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
        for item in items {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                for node in nodes {
                    innerNode.addChildNode(node)
                }
            }
        }
    }
    
    // TODO:添加类swiftui foreach
    
    
}
