//
//  VisualEffectView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public class BlurEffectView:View{
    private var pEffectView:UIVisualEffectView
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(style:UIBlurEffect.Style,@ArgoKitViewBuilder _ builder:@escaping ()->View){
        let blurEffect:UIBlurEffect = UIBlurEffect(style: style)
        pEffectView = UIVisualEffectView(effect: blurEffect)
        pNode = ArgoKitNode(view: pEffectView.contentView)
        addSubNodes(builder:builder)
    }

}
