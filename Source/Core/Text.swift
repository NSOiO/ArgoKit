//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
public struct Text:View {
    public var body: View{
        self
    }
    internal var label:UILabel
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }

    public init() {
        label = UILabel()
        pNode = ArgoKitNode(view: label)
    }
    public init(_ text:String?) {
        label = UILabel()
        pNode = ArgoKitNode(view: label)
        label.text = text;
    }

}

extension Text{
    public func text(_ value:String?)->Self{
        label.text = value
        return self
    }
    public func font(_ value:UIFont!)->Self{
        label.font = value
        return self
    }
    public func textColor(_ value:UIColor!)->Self{
        label.textColor = value
        return self
    }
    public func shadowColor(_ value:UIColor?)->Self{
        label.shadowColor = value
        return self
    }
    public func shadowOffset(_ value:CGSize)->Self{
        label.shadowOffset = value
        return self
    }
    public func textAlignment(_ value:NSTextAlignment)->Self{
        label.textAlignment = value
        return self
    }
    public func lineBreakMode(_ value:NSLineBreakMode)->Self{
        label.lineBreakMode = value
        return self
    }
    
    public func attributedText(_ value:NSAttributedString?)->Self{
        label.attributedText = value
        return self
    }
    
    public func attributedText(_ value:UIColor?)->Self{
        label.highlightedTextColor = value
        return self
    }
    
    public func isHighlighted(_ value:Bool)->Self{
        label.isHighlighted = value
        return self
    }
    
    
    public func setUserInteractionEnabled(_ value:Bool)->Self{
        label.isUserInteractionEnabled = value
        return self
    }
    public func isEnabled(_ value:Bool)->Self{
        label.isEnabled = value;
        return self
    }
    
}
