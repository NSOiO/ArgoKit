//
//  Text.Protocol.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-15.
//

import Foundation
public protocol TextAttributeNodeProtocol: class {
    var fontSize:CGFloat { get set}
    var fontStyle:AKFontStyle { get set }
    var fontName:String? { get set }
}

public protocol TextNodeProtocol: TextAttributeNodeProtocol{
    var lineSpacing:CGFloat { get set }
    func handleLineSpacing()
    func attributedText(attri:NSAttributedString?) ->NSAttributedString?
    func lineSpacing(_ value:CGFloat)
    func argo_sizeThatFits(_ size: CGSize) -> CGSize
}

public extension TextNodeProtocol where Self: ArgoKitNode{
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
    
    func argo_sizeThatFits(_ size: CGSize) -> CGSize {
        let lable:UILabel = TextCalculation.calculationLable
//        TextCalculation.AddLableCache(lable)
        if let text =  self.text(){
            if text.count > 0 {
                lable.text = text
            }
        }
        if let attribut =  self.attributedText(){
            if attribut.length > 0 {
                lable.attributedText = attribut
            }
        }
        if let font = self.font() {
            lable.font = font
        }else{
            let font = UIFont.font(fontName: self.fontName, fontStyle: self.fontStyle, fontSize: self.fontSize)
            lable.font = font
        }
        lable.numberOfLines = self.numberOfLines()
        lable.lineBreakMode = self.lineBreakMode()
        var result = lable.sizeThatFits(size)
        let width = ceil(result.width);
        let height = ceil(result.height);
        result = CGSize(width: width, height: height)
//        let result = ArgoKitUtils.sizeThatFits(size, numberOfLines: self.numberOfLines(), attributedString: self.attributesForSize())
        return result
    }
}

struct TextCalculation {
    static let calculationLable:UILabel = UILabel()
    private static var calculationLableCache = Array<UILabel>()
    static func removeAllLableCache() -> Void {
        if calculationLableCache.count > 0 {
            calculationLableCache.removeAll()
        }
    }
    static func AddLableCache(_ value:UILabel) -> Void {
        calculationLableCache.append(value)
    }
}

class ArgoKitTextNode: ArgoKitArttibuteNode,TextNodeProtocol {
//    override func createNodeViewIfNeed(_ frame: CGRect) {
//        super.createNodeViewIfNeed(frame)
//        TextCalculation.removeAllLableCache()
//    }
    var lineSpacing:CGFloat = 0
    
    public func lineSpacing(_ value:CGFloat){
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
