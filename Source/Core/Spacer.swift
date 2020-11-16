//
//  Spacer.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/13.
//

import Foundation
public class Spacer: View {
    private let pNode:ArgoKitTextNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init() {
        pNode = ArgoKitTextNode(viewClass: UIView.self)
        pNode.flexGrow(1.0)
        
    }
}

