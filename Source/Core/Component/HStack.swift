//
//  View.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

/// A view that arranges its children in a horizontal line.
public class HStack: View {
    private let pNode:ArgoKitNode
    
    /// The node behind the HStack.
    public var node: ArgoKitNode?{
        pNode
    }
    
    /// Initializer
    public init() {
        pNode = ArgoKitNode(viewClass:UIView.self);
    }

    /// Initializer
    /// - Parameter builder: A view builder that creates the content of this stack.
    public init(@ArgoKitViewBuilder _ builder: @escaping () -> View) {
        pNode = ArgoKitNode(viewClass:UIView.self);
        pNode.row();
        addSubNodes(builder:builder)
    }
    
    //TODO:是否考虑支持兼容/混合布局
    private init(_ view:UIView!,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = ArgoKitNode(view:view);
        pNode.row();
        addSubNodes(builder:builder)
    }
}



