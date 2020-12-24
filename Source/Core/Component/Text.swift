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
    public init(_ text:String?) {
        self.init()
        addAttribute(#selector(setter:UILabel.text),text)
    }
}

extension Text{
    /// set content of the Text
    /// - Parameter value: a string value
    /// - Returns: Self
    @discardableResult
    public func text(_ value:String?)->Self{
        addAttribute(#selector(setter:UILabel.text),value)
        pNode.handleLineSpacing()
        return self
    }
    
    /// set the font of the receiver's text.
    /// - Parameter value: a UIFont value
    /// - Returns: Self
    @discardableResult
    public func font(_ value:UIFont!)->Self{
        addAttribute(#selector(setter:UILabel.font),value)
        pNode.handleLineSpacing()
        return self
    }
    
    /// Set the font of the receiver's text.
    /// - Parameters:
    ///   - name: font name
    ///   - style: font style
    ///   - size: font size
    /// - Returns: Self
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
    public func font(name: String?, style:AKFontStyle,size:CGFloat)->Self{
        pNode.fontName = name
        pNode.fontSize = size
        pNode.fontStyle = style
        let font = UIFont.font(fontName: name, fontStyle: style, fontSize: size)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: Self
    @discardableResult
    public func font(name value:String?)->Self{
        pNode.fontName = value
        let font = UIFont.font(fontName: value, fontStyle: pNode.fontStyle, fontSize: pNode.fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: Self
    @discardableResult
    public  func font(size value:CGFloat)->Self{
        pNode.fontSize = value
        let font = UIFont.font(fontName: pNode.fontName, fontStyle:  pNode.fontStyle, fontSize: value)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
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
    public func font(style value:AKFontStyle)->Self{
        pNode.fontStyle = value
        let font = UIFont.font(fontName: pNode.fontName, fontStyle: value, fontSize: pNode.fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: Self
    @discardableResult
    public func textColor(_ value:UIColor!)->Self{
        addAttribute(#selector(setter:UILabel.textColor),value)
        pNode.handleLineSpacing()
        return self
    }
    
    /// change the rgba-color of the text.
    /// - Parameters:
    ///   - r: the red value of the color object, data range from 0 to 255.
    ///   - g: the green value of the color object, data range from 0 to 255.
    ///   - b: the blue value of the color object, data range from 0 to 255.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: Self
    @discardableResult
    public func textColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UILabel.textColor),value)
        return self;
    }
    
    /// change the rgba-color of the text
    /// - Parameters:
    ///   - hex: rgb color, ex: 0xaabbcc representing the red value is 0xaa, the green value is 0xbb and the blue value is 0xcc.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: Self
    @discardableResult
    public func textColor(hex:Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UILabel.textColor),value)
        return self;
    }
    
    /// set the textAlign of the back UILabel object.
    /// - Parameter value: new NSTextAlignment value
    /// - Returns: Self
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
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Returns: Self
    @discardableResult
    public func textShadowOffset(_ value:CGSize)->Self{
        addAttribute(#selector(setter:UILabel.shadowOffset),value)
        return self
    }
    
    /// set the shadow color for the text
    /// - Parameter value: a new color
    /// - Returns: Self
    @discardableResult
    public func textShadowColor(_ value:UIColor)->Self{
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self
    }
    
    /// set the shadow color for the text, the color is generated by the rgba value.
    /// - Parameters:
    ///   - r: red value of the color object, data range form 0 to 255
    ///   - g: green value of the color object, data range form 0 to 255
    ///   - b: blue value of the color object, data range form 0 to 255
    ///   - a: opacity value of the color object, data range form 0 to 255
    /// - Returns: Self
    @discardableResult
    public func textShadowColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self;
    }
    
    /// set the shadow color for the text, the color is generated by the rgba value.
    /// - Parameters:
    ///   - hex: rgb value of the color object, ex: 0xaabbcc representing red value is 0xaa, green value is 0xbb, blue value is 0xcc.
    ///   - a: opaity value of the color object, data range from 0 to 1.
    /// - Returns: Self
    @discardableResult
    public func textShadowColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self;
    }
    
    /// The technique for wrapping and truncating the label’s text. Call lineBreakMode of the UILabel directly.
    /// - Parameter value: new line break mode
    /// - Returns: Self
    ///
    ///```
    ///public enum NSLineBreakMode : Int {
    ///
    ///    case byWordWrapping = 0 // Wrap at word boundaries, default
    ///
    ///    case byCharWrapping = 1 // Wrap at character boundaries
    ///
    ///    case byClipping = 2 // Simply clip
    ///
    ///    case byTruncatingHead = 3 // Truncate at head of line: "...wxyz"
    ///
    ///    case byTruncatingTail = 4 // Truncate at tail of line: "abcd..."
    ///
    ///    case byTruncatingMiddle = 5 // Truncate middle of line:  "ab...yz"
    ///}
    ///```
    @discardableResult
    public func breakMode(_ value:NSLineBreakMode)->Self{
        addAttribute(#selector(setter:UILabel.lineBreakMode),value.rawValue)
        return self
    }
    
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: Self
    @discardableResult
    public func attributedText(_ value:NSAttributedString?)->Self{
        pNode.attributedText(attri: value)
        return self
    }
    
    /// set the highlight color for the text.
    /// - Parameter value: new color
    /// - Returns: Self
    @discardableResult
    public func highlightedTextColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UILabel.highlightedTextColor),value)
        return self
    }
    
    /// set a Boolean value that determines whether the label draws its text with a highlight.
    /// - Parameter value: a Boolean value
    /// - Returns: Self
    @discardableResult
    public func isHighlighted(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isHighlighted),value)
        return self
    }
    
    
    /// Set A Boolean value that determines whether the system ignores and removes user events for this label from the event queue.
    /// - Parameter value: a Boolean value
    /// - Returns: Self
    @discardableResult
    public func userInteractionEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isUserInteractionEnabled),value)
        return self
    }
    /// set a Boolean value that determines whether the back label draws its text in an enabled state.
    /// - Parameter value: a Boolean value
    /// - Returns: Self
    public func isEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isEnabled),value)
        return self
    }
    
    /// Set the maximum number of lines for rendering text. 0 representing unlimited.
    /// - Parameter value: new maximum number of lines.
    /// - Returns: Self
    @discardableResult
    public func lineLimit(_ value:Int)->Self{
        addAttribute(#selector(setter:UILabel.numberOfLines),value)
        return self
    }
    
    ///  The distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter value: new points value
    /// - Returns: Self
    @discardableResult
    public func lineSpacing(_ value:CGFloat)->Self{
        pNode.lineSpacing(value)
        return self
    }
    
    /// A Boolean value that determines whether the label reduces the text’s font size to fit the title string into the label’s bounding rectangle.
    /// - Parameter value: a new Boolean value
    /// - Returns: Self
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    /// An option that controls whether the text's baseline remains fixed when text needs to shrink to fit in the label.
    /// - Parameter value: new option
    /// - Returns: Self
    /// 
    ///```
    ///public enum UIBaselineAdjustment : Int {
    ///
    ///    case alignBaselines = 0 // default. used when shrinking text to position based on the original baseline
    ///
    ///    case alignCenters = 1
    ///
    ///    case none = 2
    ///}
    ///```
    @discardableResult
    public func baselineAdjustment(_ value:UIBaselineAdjustment)->Self{
        addAttribute(#selector(setter:UILabel.baselineAdjustment),value)
        return self
    }

    
    /// The minimum scale factor for the label’s text.
    /// - Parameter value: scale factor
    /// - Returns: Self
    @available(iOS 6.0, *)
    @discardableResult
    public func minimumScaleFactor(_ value:CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.minimumScaleFactor),value)
        return self
    }

    /// A Boolean value that determines whether the label tightens text before truncating.
    ///
    /// When the value of this property is true, the label tightens intercharacter spacing of its text before allowing any truncation to occur. The label determines the maximum amount of tightening automatically based on the font, current line width, line break mode, and other relevant information. This autoshrinking behavior is only intended for use with a single-line label.
    /// The default value of this property is false.
    /// - Parameter value: new Boolean value
    /// - Returns: Self
    @available(iOS 9.0, *)
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value)
        return self
    }

    /// A Boolean value that determines whether the label tightens text before truncating.
    ///
    /// When the value of this property is true, the label tightens intercharacter spacing of its text before allowing any truncation to occur. The label determines the maximum amount of tightening automatically based on the font, current line width, line break mode, and other relevant information. This autoshrinking behavior is only intended for use with a single-line label.
    /// The default value of this property is false.
    /// - Parameter value: a new Boolean value.
    /// - Returns: Self
    @discardableResult
    public func lineBreakStrategy(_ value:NSParagraphStyle.LineBreakStrategy)->Self{
        addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value)
        return self
    }

    /// Returns the drawing rectangle for the label’s text. call textRect of the back label object directly.
    /// - Parameters:
    ///   - bounds: The bounding rectangle of the label.
    ///   - numberOfLines: The maximum number of lines to use for the label. The value 0 indicates the label has no maximum number of lines and the rectangle should encompass all of the text.
    /// - Returns: Self
    public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect{
        if let label = self.node?.view as? UILabel {
            return label.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines);
        }
        return CGRect.zero
    }
    
    /// Draws the label’s text, or its shadow, in the specified rectangle.
    /// - Parameter rect: The bounding rectangle of the label.
    /// - Returns: Self
    @discardableResult
    public func drawText(in rect: CGRect)->Self{
        addAttribute(#selector(UILabel.drawText(in:)),[rect])
        return self
    }

    /// The preferred maximum width, in points, for a multiline label.
    /// - Parameter value: new value
    /// - Returns: Self
    @available(iOS 6.0, *)
    @discardableResult
    public func preferredMaxLayoutWidth(in value: CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.preferredMaxLayoutWidth),value)
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
