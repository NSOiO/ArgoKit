//
//  VisualEffectView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public struct VisualEffectView:View{
    public var body: View{
        self
    }
    private var pEffectView:UIVisualEffectView
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
}
