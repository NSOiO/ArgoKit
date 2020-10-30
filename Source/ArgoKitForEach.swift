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
    
    public init(_ data:Array<Any>,@ArgoKitViewBuilder _ builder:@escaping (Any)->View) {
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
        for item in data {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                for node in nodes {
                    innerNode.addChildNode(node)
                }
            }
        }
    }
}

extension ForEach{
    public init(_ data:Range<Int>,@ArgoKitViewBuilder _ builder:@escaping (Int)->View) {
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
        for item in data {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                for node in nodes {
                    innerNode.addChildNode(node)
                }
            }
        }
    }
}
