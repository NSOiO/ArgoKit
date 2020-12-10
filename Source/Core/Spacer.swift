//
//  Spacer.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/13.
//

import Foundation
public struct Spacer: View {
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init() {
        pNode = ArgoKitNode(viewClass: UIView.self)
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
