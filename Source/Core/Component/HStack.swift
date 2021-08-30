//
//  View.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/15.
//

import UIKit

/// A view that arranges its children in a horizontal line.
/// same as the `flex-direction: row` in flexbox layout.
///
///```
///     HStack {
///         Text("1")
///         Text("2")
///         Text("3")
///     }
///```
public struct HStack: View {
    private let pNode:ArgoKitNode
    
    /// The node behind the HStack.
    public var node: ArgoKitNode?{
        pNode
    }
    
    /// Initializer
    public init() {
        pNode = ArgoKitNode(viewClass:UIView.self, type: Self.self)
        pNode.isVirtualNode = true
        pNode.row()
    }

    /// Initializer
    /// - Parameter builder: A view builder that creates the content of this stack.
    public init(@ArgoKitViewBuilder _ builder: @escaping () -> View) {
        self.init()
        addSubViews(builder:builder)
    }
}



