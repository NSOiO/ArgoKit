//
//  ArgoKitArttibuteNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/11.
//

import Foundation
open class ArgoKitArttibuteNode: ArgoKitNode {
    open var lineSpacing:CGFloat = 0
    open var fontSize:CGFloat = 17.0
    open var fontStyle:AKFontStyle = .default
    open var fontName:String?
    open var font:UIFont = UIFont.font(fontName: nil, fontStyle: .default, fontSize: 17.0)
    
    
    /*
    func setValue(_ selector:Selector,_ value:Any?) -> Void{
        setValue(self, selector, value)
    }
    
    private func setValue(_ node:ArgoKitNode,_ selector:Selector,_ value:Any?) -> Void {
        if let nodes = node.childs{
            for subNode in nodes {
                if subNode is ArgoKitTextNode {
                    if let _ =  (subNode as! ArgoKitTextNode).value(with: selector){
                    }else{
                        ArgoKitNodeViewModifier.addAttribute(subNode as? ArgoKitTextNode, selector, value)
                    }
                }else{
                    setValue(subNode as! ArgoKitNode, selector, value)
                }
            }
        }
    } */

}
