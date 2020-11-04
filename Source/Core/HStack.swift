//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

public struct HStack:View {
    public var body: View{
        ViewEmpty()
    }
    private let innerNode:ArgoKitNode
    private let innerView:UIView
    
    public var node: ArgoKitNode?{
        innerNode
    }
    public var type: ArgoKitNodeType{
        .single(innerNode)
    }

    public init(){
        innerView = UIView();
        innerNode = ArgoKitNode(view: innerView);
    }
    
    //TODO:是否考虑支持兼容/混合布局
    public init(_ view:UIView = UIView(),@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        innerView = view;
        innerNode = ArgoKitNode(view: innerView);
        innerNode.row();
        addSubNodes(builder:builder)
    }
}



