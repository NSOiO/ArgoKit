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
    
    public init(){
        pNode = ArgoKitNode(viewClass:UIView.self);
    }
    
    public init(@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(viewClass: UIView.self);
        pNode.column();
        addSubNodes(builder:builder)
    }
    
    //TODO:是否考虑支持兼容/混合布局
    public init(_ view:UIView!,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(view:view);
        pNode.column();
        addSubNodes(builder:builder)
    }
}



