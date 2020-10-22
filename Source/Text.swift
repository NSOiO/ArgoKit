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
    private var label:UILabel
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
    func setFont(_ value:UIFont) {
        label.font = value
    }
    func setText(_ value:String?) {
        label.text = value
    }
    func setTextColor(_ value:UIColor!) {
        label.textColor = value
    }
    func setShadowColor(_ value:UIColor?){
        label.shadowColor = value
    }
    func setShadowOffset(_ value:CGSize){
        label.shadowOffset = value;
    }
    func setTextAlignment(_ value:NSTextAlignment){
        label.textAlignment = value;
    }
    func setLineBreakMode(_ value:NSLineBreakMode){
        label.lineBreakMode = value;
    }
    func setAttributedText(_ value:NSAttributedString?){
        label.attributedText = value;
    }
    func setHighlightedTextColor(_ value:UIColor?){
        label.highlightedTextColor = value;
    }
    func setHighlighted(_ value:Bool){
        label.isHighlighted = value;
    }
    func setUserInteractionEnabled(_ value:Bool){
        label.isUserInteractionEnabled = value;
    }
    func setEnabled(_ value:Bool){
        label.isEnabled = value;
    }
    
}

extension Text{
    public func text(_ value:String?)->Self{
        setText(value)
        return self
    }
    public func font(_ value:UIFont!)->Self{
        setFont(value)
        return self
    }
    public func textColor(_ value:UIColor!)->Self{
        setTextColor(value)
        return self
    }
    public func shadowColor(_ value:UIColor?)->Self{
        setShadowColor(value)
        return self
    }
    public func shadowOffset(_ value:CGSize)->Self{
        setShadowOffset(value)
        return self
    }
    public func textAlignment(_ value:NSTextAlignment)->Self{
        setTextAlignment(value)
        return self
    }
    public func lineBreakMode(_ value:NSLineBreakMode)->Self{
        setLineBreakMode(value)
        return self
    }
    
    public func attributedText(_ value:NSAttributedString?)->Self{
        setAttributedText(value)
        return self
    }
}
