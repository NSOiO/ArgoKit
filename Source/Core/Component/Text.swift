//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
struct TextCalculation {
    static let calculationLable:UILabel = UILabel()
}
class ArgoKitTextNode: ArgoKitArttibuteNode {
    
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
        var result:CGSize = size
//        if let view = self.view {
//            result = view.sizeThatFits(size)
//        }else{
//
//        }
        let lable:UILabel = TextCalculation.calculationLable
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
        }
        lable.numberOfLines = self.numberOfLines()
        lable.lineBreakMode = self.lineBreakMode()
        result = lable.sizeThatFits(size)
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
    private let pNode:ArgoKitTextNode
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
    /// set content of the Text
    /// - Parameter value: a string value
    /// - Returns: self
    @discardableResult
    public func text(_ value:@escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({
            addAttribute(#selector(setter:UILabel.text),value())
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// set the font of the receiver's text.
    /// - Parameter value: a UIFont value
    /// - Returns: self
    @discardableResult
    public func font(_ value: @escaping @autoclosure () -> UIFont)->Self{
        return self.bindCallback({
            addAttribute(#selector(setter:UILabel.font),value())
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// Set the font of the receiver's text.
    /// - Parameters:
    ///   - name: font name
    ///   - style: font style
    ///   - size: font size
    /// - Returns: self
    ///
    /// ```
    /// // value of AKFontStyle
    /// public enum AKFontStyle{
    ///     case `default`
    ///     case bold
    ///     case italic
    ///     case bolditalic
    /// }
    /// ```
    @discardableResult
    public func font(name: @escaping @autoclosure () -> String?, style: @escaping @autoclosure () -> AKFontStyle, size: @escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({
            let f_name = name(), f_size = size(), f_style = style()
            pNode.fontName = f_name
            pNode.fontSize = f_size
            pNode.fontStyle = f_style
            let font = UIFont.font(fontName: f_name, fontStyle: f_style, fontSize: f_size)
            addAttribute(#selector(setter:UILabel.font),font)
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: self
    @discardableResult
    public func font(name value: @escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({
            let f_name = value()
            pNode.fontName = f_name
            let font = UIFont.font(fontName: f_name, fontStyle: pNode.fontStyle, fontSize: pNode.fontSize)
            addAttribute(#selector(setter:UILabel.font),font)
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: self
    @discardableResult
    public  func font(size value: @escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({
            let f_size = value()
            pNode.fontSize = f_size
            let font = UIFont.font(fontName: pNode.fontName, fontStyle:  pNode.fontStyle, fontSize: f_size)
            addAttribute(#selector(setter:UILabel.font),font)
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the font style of the receiver's text
    /// - Parameter value: font style
    /// - Returns:Self
    ///
    /// ```
    /// // value of AKFontStyle
    /// public enum AKFontStyle{
    ///     case `default`
    ///     case bold
    ///     case italic
    ///     case bolditalic
    /// }
    /// ```
    @discardableResult
    public func font(style value: @escaping @autoclosure () -> AKFontStyle)->Self{
        return self.bindCallback({
            let f_style = value()
            pNode.fontStyle = value()
            let font = UIFont.font(fontName: pNode.fontName, fontStyle: f_style, fontSize: pNode.fontSize)
            addAttribute(#selector(setter:UILabel.font),font)
            pNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value:UIColor!)->Self{
        addAttribute(#selector(setter:UILabel.textColor),value)
        pNode.handleLineSpacing()
        return self
    }
    
    /// set the textAlign of the back UILabel object.
    /// - Parameter value: new NSTextAlignment value
    /// - Returns: self
    ///
    ///```
    ///public enum NSTextAlignment : Int {
    ///    case left = 0 // Visually left aligned
    ///    case center = 1 // Visually centered
    ///    case right = 2 // Visually right aligned
    ///    /* !TARGET_ABI_USES_IOS_VALUES */
    ///    // Visually right aligned
    ///    // Visually centered
    ///    case justified = 3 // Fully-justified. The last line in a paragraph is natural-aligned.
    ///    case natural = 4 // Indicates the default alignment for script
    ///}
    ///```
    @discardableResult
    public func textAlign(_ value:NSTextAlignment)->Self{
        addAttribute(#selector(setter:UILabel.textAlignment),value.rawValue)
        pNode.handleLineSpacing()
        return self
    }
    
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value:NSAttributedString?)->Self{
        pNode.attributedText(attri: value)
        return self
    }
    
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
    
    ///  The distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter value: new points value
    /// - Returns: self
    @discardableResult
    public func lineSpacing(_ value:CGFloat)->Self{
        pNode.lineSpacing(value)
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
