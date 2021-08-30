//
//  EmptyView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/15.
//  单独的View，可用来绘制线条等

import Foundation

/// Wrapper of UIView
/// An object that manages the content for a rectangular area on the screen.
public struct EmptyView: View {
    private let pNode:ArgoKitNode
    
    /// The node behind the empty view.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    public init() {
        pNode = ArgoKitNode(viewClass: UIView.self, type: Self.self)
    }
}

extension EmptyView{
   @available(*, deprecated, message: "Spacer does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "Spacer does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
