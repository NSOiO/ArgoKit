//
//  Text.Protocol.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-15.
//

import Foundation
open class ArgoKitTextBaseNode:ArgoKitArttibuteNode{
    public var text:String? = nil
    public var attributedText:NSAttributedString? = nil
    public var numberOfLines:Int = 1
    public var lineBreakMode:NSLineBreakMode = .byWordWrapping
    public var textAlignment:NSTextAlignment = .left
    open override func prepareForUse() {
        super.prepareForUse()
        if let lable = self.view as? UILabel {
            lable.text = nil
            lable.attributedText = nil
        }
    }
    open func handleLineSpacing() {
        if self.lineSpacing == 0 {
            return
        }
        let lableText:String = self.text ?? ""
        if lableText.count == 0 {
            return
        }
        
        let range:NSRange = NSRange(location: 0, length: lableText.count)
        let attributedString = NSMutableAttributedString(string: lableText)
        attributedString.addAttribute(NSAttributedString.Key.font, value: self.font, range: range)
        if let textColor:UIColor = self.textColor() {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        }
        setAttributedText(attri: attributedString)
    }

    open func setAttributedText(attri:NSAttributedString?){
        if let attriText = attri {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            if self.lineSpacing == 0 {
                paragraphStyle.lineSpacing = 2
            }else{
                paragraphStyle.lineSpacing = self.lineSpacing
            }
            paragraphStyle.lineBreakMode = self.lineBreakMode
            paragraphStyle.alignment = self.textAlignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
            attributedText = attributedString
        }
    }
    
    open func setText(_ value:String?){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.text),value)
        self.text = value
    }
    open func font(_ value:UIFont, range: NSRange? = nil){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.font),value)
        self.font = value
    }
    
    open func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.textAlignment),value.rawValue)
        self.textAlignment = value
    }
    open func numberOfLines(_ value:Int, range: NSRange? = nil){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.numberOfLines),value)
        self.numberOfLines = value
    }
    
    open func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.lineBreakMode),value.rawValue)
        self.lineBreakMode = value
    }
    
    open func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        self.handleLineSpacing()
    }
    @discardableResult
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable:UILabel = TextCalculation.calculationLable
        if let text =  self.text{
            lable.text = text
        }
        if let attribut = self.attributedText{
            lable.attributedText = attribut
        }
        lable.font = font
        lable.numberOfLines = self.numberOfLines
        lable.lineBreakMode = self.lineBreakMode
        lable.textAlignment = self.textAlignment
        var result = lable.sizeThatFits(size)
        let width = ceil(result.width);
        let height = ceil(result.height);
        result = CGSize(width: width, height: height)
        return result
    }
}

struct TextCalculation {
    static let calculationLable:UILabel = UILabel()
}

class ArgoKitTextNode: ArgoKitTextBaseNode {
    override func prepareForUse() {
        if let lable = self.view as? UILabel{
            lable.text = nil
            lable.attributedText = nil
        }
    }
    public override func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        self.handleLineSpacing()
    }
    
    func cleanLineSpacing() {
        if let attriText = self.attributedText() {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.lineBreakMode = self.lineBreakMode()
            paragraphStyle.alignment = self.textAlignment()
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
        }
    }
}
