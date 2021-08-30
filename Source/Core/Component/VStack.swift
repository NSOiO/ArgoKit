//
//  View.swift
//  ArgoKit
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
public struct VStack:View {
  
    private var pNode:ArgoKitNode
    /// the node behind the VStack
    public var node: ArgoKitNode?{
        pNode
    }
    public init(){
        pNode = ArgoKitNode(viewClass: UIView.self, type: Self.self)
        pNode.isVirtualNode = true
        pNode.column()
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
        self.init()
        addSubViews(builder:builder)
    }
}



