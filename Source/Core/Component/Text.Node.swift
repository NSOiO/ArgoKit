//
//  Text.Protocol.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-15.
//

import Foundation
class ArgoKitTextBaseNode:ArgoKitArttibuteNode{
    func handleLineSpacing() {
        if self.lineSpacing == 0 {
            return
        }
        let lableText:String = self.text() ?? ""
        if lableText.count == 0 {
            return
        }
        
        let range:NSRange = NSRange(location: 0, length: lableText.count)
        let attributedString = NSMutableAttributedString(string: lableText)
        if let font:UIFont = self.font(){
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        if let textColor:UIColor = self.textColor() {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        }
        _ = attributedText(attri: attributedString)
    }
    @discardableResult
    func attributedText(attri:NSAttributedString?) ->NSAttributedString?{
        if let attriText = attri {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            if self.lineSpacing == 0 {
                paragraphStyle.lineSpacing = 2
            }else{
                paragraphStyle.lineSpacing = self.lineSpacing
            }
            paragraphStyle.lineBreakMode = self.lineBreakMode()
            paragraphStyle.alignment = self.textAlignment()
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
            return attributedString
        }
        return nil
    }
    
    func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        self.handleLineSpacing()
    }
    @discardableResult
    func argo_sizeThatFits(_ size: CGSize) -> CGSize {
        let lable:UILabel = TextCalculation.calculationLable
        let font = UIFont.font(fontName: self.fontName, fontStyle: self.fontStyle, fontSize: self.fontSize)
        lable.font = font
        lable.text = nil
        lable.attributedText = nil
        lable.numberOfLines = 1
        ArgoKitNodeViewModifier.performViewAttribute(lable, attributes: self.nodeAllAttributeValue())
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
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.argo_sizeThatFits(size)
    }
}
