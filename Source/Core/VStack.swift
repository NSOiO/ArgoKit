//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

public class VStack:View {
  
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(){
        pNode = ArgoKitNode(viewClass:UIView.self);
    }
    
    public init(@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(viewClass: UIView.self)
        pNode.column()
        pNode.alignItemsFlexStart()
        addSubNodes(builder:builder)
    }
    
    //TODO:是否考虑支持兼容/混合布局
    private init(_ view:UIView!,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(view:view);
        pNode.column();
        pNode.alignItemsFlexStart()
        addSubNodes(builder:builder)
    }
}



