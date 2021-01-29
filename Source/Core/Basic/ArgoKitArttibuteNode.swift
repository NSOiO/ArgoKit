//
//  ArgoKitArttibuteNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/11.
//

import Foundation
open class ArgoKitArttibuteNode: ArgoKitNode {
    public var lineSpacing:CGFloat = 0
    public var fontSize:CGFloat = 17.0
    public var fontStyle:AKFontStyle = .default
    public var fontName:String?
    public var font:UIFont = UIFont.font(fontName: nil, fontStyle: .default, fontSize: 17.0)
    public var text:String? = nil
    public var attributedText:NSMutableAttributedString? = nil
    public var numberOfLines:Int = 1
    public var lineBreakMode:NSLineBreakMode = .byWordWrapping
    public var textAlignment:NSTextAlignment = .left
    public var shadow:NSShadow = NSShadow()
    
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
