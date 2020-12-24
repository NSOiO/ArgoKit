//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

/// The container that align children from top to bottom.
/// same as the `flex-direction: column` in flexbox layout.
///
///```
///     VStack {
///         Text("1")
///         Text("2")
///         Text("3")
///     }
///```
public class VStack:View {
  
    private var pNode:ArgoKitNode
    /// the node behind the VStack
    public var node: ArgoKitNode?{
        pNode
    }
    public init(){
        pNode = ArgoKitNode(viewClass:UIView.self);
    }
    
    /// initalize the VStack with view builder.
    /// - Parameter builder: view builder.
    /// 
    ///```
    ///     VStack {
    ///         Text("1")
    ///         Text("2")
    ///         Text("3")
    ///     }
    ///```
    public init(@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(viewClass: UIView.self)
        pNode.column()
        addSubViews(builder:builder)
    }
    
    //TODO:是否考虑支持兼容/混合布局
    private init(_ view:UIView!,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(view:view);
        pNode.column();
        addSubViews(builder:builder)
    }
}



