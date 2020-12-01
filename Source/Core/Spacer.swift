//
//  Spacer.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/13.
//

import Foundation
public class Spacer: View {
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init() {
        pNode = ArgoKitNode(viewClass: UIView.self)
        pNode.flexGrow(1.0)
        
    }
}

