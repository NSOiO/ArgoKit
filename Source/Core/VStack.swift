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
    //TODO:是否考虑支持兼容/混合布局
    public init(_ view:UIView = UIView(),@ArgoKitViewBuilder _ builder:()->View) {
        pView = view;
        pNode = ArgoKitNode(view: pView);
        pNode.column();
        addSubNodes(builder)
    }
}



