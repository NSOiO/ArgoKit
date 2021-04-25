//
//  Spacer.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/13.
//

import Foundation
/// Representing of space within a container along the main axis.
/// same as the view of which felxGrow is 1.0.
///
/// ```
///     HStack {
///         Text("1")
///         Text("2")
///         Spacer()
///         Text("3")
///     }
/// ```
public struct Spacer: View {
    private let pNode:ArgoKitNode
    /// the node begind the Spacer
    public var node: ArgoKitNode?{
        pNode
    }
    public init() {
        pNode = ArgoKitNode(viewClass: UIView.self, type: Spacer.self)
        pNode.flexGrow(1.0)
    }
}

extension Spacer{
    @available(*, deprecated, message: "Spacer does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Spacer does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
