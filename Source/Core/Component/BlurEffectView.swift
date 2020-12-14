//
//  VisualEffectView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public class BlurEffectView:View{
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(style:UIBlurEffect.Style,@ArgoKitViewBuilder _ builder:@escaping ()->View){
        let blurEffect:UIBlurEffect = UIBlurEffect(style: style)
        pNode = ArgoKitNode(viewClass: UIVisualEffectView.self)
        addSubNodes(builder:builder)
        addAttribute(#selector(setter:UIVisualEffectView.effect), blurEffect)
    }

}
