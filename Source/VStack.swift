//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

public struct VStack:View {
    public var body: View{
        self
    }
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    
    private var pView:UIView
    public init(){
        pView = UIView();
        pNode = ArgoKitNode(view: pView);
    }
    
    public init(@ArgoKitViewBuilder _ builder:()->View) {
        pView = UIView();
        pNode = ArgoKitNode(view: pView);
        pNode.column();
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                pNode.addChildNode(node)
            }
        }
    }
    
    public init(_ view:UIView?,@ArgoKitViewBuilder _ builder:()->View) {
        pView = view ?? UIView();
        pNode = ArgoKitNode(view: pView);
        pNode.column();
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                pNode.addChildNode(node)
            }
        }
    }
}



