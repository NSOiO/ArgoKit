//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
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
class ArgoKitTextNode: ArgoKitArttibuteNode {
    
//    override func createNodeViewIfNeed(_ frame: CGRect) {
//        super.createNodeViewIfNeed(frame)
//        TextCalculation.removeAllLableCache()
//    }
    var lineSpacing:CGFloat = 0
    
    func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        self.handleLineSpacing()
    }
    func attributesForSize()->NSAttributedString?{
        let lableText:String = self.text() ?? ""
        if lableText.count == 0 {
            return self.attributedText()
        }
        
        let range = NSRange(location: 0, length: lableText.count)
        let attributedString = NSMutableAttributedString(string: lableText)
        if let font:UIFont = self.font(){
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        if let textColor:UIColor = self.textColor() {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        }
        return attributedText(attri: attributedString)

    }
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
        attributedText(attri: attributedString)
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
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

/// The View Representing of text，is implemented based on UILabel.
///
///```
///             Text("content..")
///                 .font(size: 25)
///                 .textColor(.white)
///                 .lineLimit(0)
///                 .lineSpacing(10)
///                 .backgroundColor(.orange)
///```
///
public struct Text:View {
    let pNode:ArgoKitTextNode
    /// the node behind of Text
    public var node: ArgoKitNode?{
        pNode
    }
    
    /// initialize the Text with emptry
    public init() {
        pNode = ArgoKitTextNode(viewClass:UILabel.self)
    }
    /// initialize the Text with a string
    /// - Parameter text: a string value
    public init(_ text:@escaping @autoclosure () -> String?) {
        self.init()
        self.text(text())
    }
}

extension Text{
    
    /// Returns the drawing rectangle for the label’s text. call textRect of the back label object directly.
    /// - Parameters:
    ///   - bounds: The bounding rectangle of the label.
    ///   - numberOfLines: The maximum number of lines to use for the label. The value 0 indicates the label has no maximum number of lines and the rectangle should encompass all of the text.
    /// - Returns: self
    public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect{
        if let label = self.node?.view as? UILabel {
            return label.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines);
        }
        return CGRect.zero
    }
    
    /// Draws the label’s text, or its shadow, in the specified rectangle.
    /// - Parameter rect: The bounding rectangle of the label.
    /// - Returns: self
    @discardableResult
    public func drawText(in rect: CGRect)->Self{
        addAttribute(#selector(UILabel.drawText(in:)),[rect])
        return self
    }
}


extension Text{
    @available(*, unavailable, message: "Text does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, unavailable, message: "Text does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
