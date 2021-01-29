//
//  Text.Protocol.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-15.
//

import Foundation
extension NSMutableAttributedString{
    public func setParagraphStyle(paragraphStyle:@escaping (NSMutableParagraphStyle?)->()){
        self.enumerateAttribute(NSAttributedString.Key.paragraphStyle, in: NSRange(location: 0, length: self.length ), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { [weak self]  (value, subRange, stop) in
            var style:NSMutableParagraphStyle? = nil
            if let value_ = value as? NSMutableParagraphStyle{
                style = value_
            }else if let value_ = value as? NSParagraphStyle,let style_ = value_.mutableCopy() as? NSMutableParagraphStyle{
                style = style_
            }else{
                let style_:NSParagraphStyle = NSParagraphStyle.default
                if let value_ = style_.mutableCopy() as? NSMutableParagraphStyle{
                    style = value_
                }
            }
            paragraphStyle(style)
            self?.addAttribute(NSAttributedString.Key.paragraphStyle, value: style!, range: subRange)
        })
    }
}
open class ArgoKitTextBaseNode: ArgoKitArttibuteNode{
    open override func prepareForUse() {
        super.prepareForUse()
        if let lable = self.view as? UILabel {
            lable.text = nil
            lable.attributedText = nil
        }
    }
    
    open func setAttributedText(attri:NSAttributedString?){
        if let attriText = attri {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            attributedText = attributedString
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    
    open func setText(_ value:String?){
        if let text = value {
            setAttributedText(attri: NSAttributedString(string: text))
        }
    }
    
    open func font(_ value:UIFont, range: NSRange? = nil){
        attributedText?.addAttribute(NSAttributedString.Key.font, value: value, range: NSRange(location: 0, length: attributedText?.length ?? 0))
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        self.font = value
    }
    
    open func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        self.textAlignment = value
        attributedText?.setParagraphStyle(paragraphStyle: { paragraphStyle in
            paragraphStyle?.alignment = value
        })
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
    }
    
    open func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        attributedText?.setParagraphStyle(paragraphStyle: { paragraphStyle in
            paragraphStyle?.lineSpacing = value
        })
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
    }
    
    open func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        self.lineBreakMode = value
        attributedText?.setParagraphStyle(paragraphStyle: { paragraphStyle in
            paragraphStyle?.lineBreakMode = value
        })
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
    }
    open func numberOfLines(_ value:Int, range: NSRange? = nil){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.numberOfLines),value)
        self.numberOfLines = value
    }
    
    private func setShadow(_ value:NSShadow){
        attributedText?.addAttribute(NSAttributedString.Key.shadow, value: value, range: NSRange(location: 0, length: attributedText?.length ?? 0))
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
    }
    open func shadow(_ value:NSShadow,range: NSRange? = nil){
        shadow = value
        setShadow(shadow)
    }
    open func shadow(color:UIColor,offset:CGSize,blurRadius:CGFloat,range: NSRange? = nil){
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        setShadow(shadow)
    }
    
    open func shadowColor(_ value:UIColor,range: NSRange? = nil){
        shadow.shadowColor = value
        setShadow(shadow)
    }
    open func shadowOffset(_ value:CGSize,range: NSRange? = nil){
        shadow.shadowOffset = value
        setShadow(shadow)
    }
    open func shadowBlurRadius(_ value:CGFloat,range: NSRange? = nil){
        shadow.shadowBlurRadius = value
        setShadow(shadow)
    }
    
    @discardableResult
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable:UILabel = TextCalculation.calculationLable
        if let attribut = self.attributedText{
            lable.attributedText = attribut
        }
        lable.font = font
        lable.numberOfLines = self.numberOfLines
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
