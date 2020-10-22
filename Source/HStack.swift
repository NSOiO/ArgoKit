//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

public struct HStack:View {
    public var body: View{
        self
    }
    private var innerNode:ArgoKitNode
    
    public var node: ArgoKitNode?{
        innerNode
    }
    private var innerView:UIView
    public var type: ArgoKitNodeType{
        .single(innerNode)
    }

    public init(){
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
    }
    
    public init(@ArgoKitViewBuilder _ builder:()->View) {
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
        innerNode.row();
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                innerNode.addChildNode(node)
            }
        }
    }
    
    //TODO:是否考虑支持兼容/混合布局
    public init(_ view:UIView?,@ArgoKitViewBuilder _ builder:()->View) {
        innerView = view ?? UIView();
        innerNode = ArgoKitNode(view: innerView);
        innerNode.row();
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                innerNode.addChildNode(node)
            }
        }
    }
}



