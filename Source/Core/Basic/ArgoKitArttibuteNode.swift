//
//  ArgoKitArttibuteNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/11.
//

import Foundation
class ArgoKitArttibuteNode: ArgoKitNode, TextAttributeNodeProtocol {
    var fontSize:CGFloat = 17.0
    var fontStyle:AKFontStyle = .default
    var fontName:String?
    
    
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
