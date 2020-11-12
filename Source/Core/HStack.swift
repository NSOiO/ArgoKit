//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

public class HStack:View {
    public var body: View{
        ViewEmpty()
    }
    private let innerNode:ArgoKitNode
    
    public var node: ArgoKitNode?{
        innerNode
    }
    public var type: ArgoKitNodeType{
        .single(innerNode)
    }

    public init(){
        innerNode = ArgoKitNode(viewClass:UIView.self);
    }

    public init(@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        innerNode = ArgoKitNode(viewClass:UIView.self);
        innerNode.row();
        addSubNodes(builder:builder)
    }
    //TODO:是否考虑支持兼容/混合布局
    public init(_ view:UIView!,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        innerNode = ArgoKitNode(view:view);
        innerNode.row();
        addSubNodes(builder:builder)
    }
}



