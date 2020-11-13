//
//  ArgoKitForEach.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

public class ForEach:View{
    private var innerNode:ArgoKitNode
    public var node: ArgoKitNode?{
        innerNode
    }
    
    public init(_ data:Array<Any>,@ArgoKitViewBuilder _ builder:@escaping (Any)->View) {
        innerNode = ArgoKitNode(viewClass: UIView.self);
        for item in data {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                for node in nodes {
                    innerNode.addChildNode(node)
                }
            }
        }
    }
    
    public init(_ data:Range<Int>,@ArgoKitViewBuilder _ builder:@escaping (Int)->View) {
        innerNode = ArgoKitNode(viewClass: UIView.self);
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

