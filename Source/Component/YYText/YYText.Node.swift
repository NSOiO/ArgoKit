//
//  YYText.swift
//  ArgoKitComponent
//
//  Created by Bruce on 2021/1/22.
//

import Foundation
import ArgoKit
import YYText
struct YYTextCalculation {
    static let yycalculationLable:YYLabel = YYLabel()
}
class YYTextNode: ArgoKitTextBaseNode{
    var attibuteText:NSMutableAttributedString?
    
    override func createNodeViewIfNeed(_ frame: CGRect) {
        super.createNodeViewIfNeed(frame)
    }
    override  func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable = YYTextCalculation.yycalculationLable
        lable.textLayout = nil

        lable.font = font
        lable.text = self.text()
        lable.attributedText = self.attibuteText
        lable.numberOfLines = UInt(self.numberOfLines())
        lable.lineBreakMode = self.lineBreakMode()
        lable.textAlignment = self.textAlignment()
        ArgoKitNodeViewModifier.performViewAttribute(lable, attributes: self.nodeAllAttributeValue())
    
        return lable.sizeThatFits(size)
    }
    func setText(_ value:String?){
        if let text = value {
            attibuteText = NSMutableAttributedString(string: text)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    func setAttributedText(_ value:NSAttributedString?){
        if let attributText = value {
            attibuteText = NSMutableAttributedString(attributedString: attributText)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    
    func font(_ value:UIFont, range: NSRange? = nil){
        self.font = value
        if let range = range {
            attibuteText?.yy_setFont(value, range: range)
        }else{
            attibuteText?.yy_font = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    override func lineSpacing(_ value: CGFloat) {
        self.lineSpacing = value
        attibuteText?.yy_lineSpacing = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func kern(_ value:NSNumber?, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setKern(value, range: range)
        }else{
            attibuteText?.yy_kern = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setAlignment(value, range: range)
        }else{
            attibuteText?.yy_alignment = value
        }
        
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setLineBreakMode(value, range: range)
        }else{
            attibuteText?.yy_lineBreakMode = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textColor(_ value:UIColor?, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setColor(value, range: range)
        }else{
            attibuteText?.yy_color = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func backgroundColor(_ value:UIColor?, range: NSRange? = nil)  {
        if let range = range {
            attibuteText?.yy_setBackgroundColor(value, range: range)
        }else{
            attibuteText?.yy_backgroundColor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func strokeWidth(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setStrokeWidth(value, range: range)
        }else{
            attibuteText?.yy_strokeWidth = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func strokeColor(_ value:UIColor?, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setStroke(value, range: range)
        }else{
            attibuteText?.yy_strokeColor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func strikethroughStyle(_ value:NSUnderlineStyle, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setStrikethroughStyle(value, range: range)
        }else{
            attibuteText?.yy_strikethroughStyle = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func strikethroughColor(_ value:UIColor?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setStrikethroughColor(value, range: range)
        }else{
            attibuteText?.yy_strikethroughColor = value
        }
        if let attibuteText = self.attibuteText {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    
    func underlineStyle(_ value:NSUnderlineStyle, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setUnderlineStyle(value, range: range)
        }else{
            attibuteText?.yy_underlineStyle = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func underlineColor(_ value:UIColor?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setUnderlineColor(value, range: range)
        }else{
            attibuteText?.yy_underlineColor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    var shadow:NSShadow = NSShadow()
    func shadow(_ value:NSShadow,range: NSRange? = nil){
        shadow = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    func shadowColor(_ value:UIColor,range: NSRange? = nil){
        shadow.shadowColor = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func shadowOffset(_ value:CGSize,range: NSRange? = nil){
        shadow.shadowOffset = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func shadowBlurRadius(_ value:CGFloat,range: NSRange? = nil){
        shadow.shadowBlurRadius = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textEffect(_ value:String?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTextEffect(value, range: range)
        }else{
            attibuteText?.yy_textEffect = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }
    func obliqueness(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setObliqueness(value, range: range)
        }else{
            attibuteText?.yy_obliqueness = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }
    
    func expansion(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setExpansion(value, range: range)
        }else{
            attibuteText?.yy_expansion = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }

    func baselineOffset(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setBaselineOffset(value, range: range)
        }else{
            attibuteText?.yy_baselineOffset = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func setTextHighlightRange(_ range:NSRange?,color:UIColor?,backgroundColor:UIColor?,
                               userInfo:Dictionary<String, Any>?,
                               tapAction: YYTextAction?,
                               longPressAction:YYTextAction?){
        var innerRange = NSRange(location: 0, length: attibuteText?.length ?? 0)
        if let range =  range{
            innerRange = range
        }
        attibuteText?.yy_setTextHighlight(innerRange, color: color, backgroundColor: backgroundColor, userInfo: userInfo, tapAction:tapAction, longPressAction:longPressAction)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func baseWritingDirection(_ value:NSWritingDirection, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setBaseWritingDirection(value, range: range)
        }else{
            attibuteText?.yy_baseWritingDirection = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    

    func paragraphSpacing(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setParagraphSpacing(value, range: range)
        }else{
            attibuteText?.yy_paragraphSpacing = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func paragraphSpacingBefore(_ value: CGFloat, range: NSRange? = nil){
        attibuteText?.yy_paragraphSpacingBefore = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func firstLineHeadIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setFirstLineHeadIndent(value, range: range)
        }else{
            attibuteText?.yy_firstLineHeadIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }


    func headIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setHeadIndent(value, range: range)
        }else{
            attibuteText?.yy_headIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func tailIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTailIndent(value, range: range)
        }else{
            attibuteText?.yy_tailIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func minimumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setMinimumLineHeight(value, range: range)
        }else{
            attibuteText?.yy_minimumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    func maximumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setMaximumLineHeight(value, range: range)
        }else{
            attibuteText?.yy_maximumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func lineHeightMultiple(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setLineHeightMultiple(value, range: range)
        }else{
            attibuteText?.yy_lineHeightMultiple = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    func hyphenationFactor(_ value: Float, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setHyphenationFactor(value, range: range)
        }else{
            attibuteText?.yy_hyphenationFactor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }


    func defaultTabInterval(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setDefaultTabInterval(value, range: range)
        }else{
            attibuteText?.yy_defaultTabInterval = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    
    func setLink(_ link:Any?,range:NSRange? = nil){
        var innerRange = NSRange(location: 0, length: self.attibuteText?.length ?? 0)
        if let range = range {
            innerRange = range
        }
        attibuteText?.yy_setLink(link, range: innerRange)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    
    func attachmentStringWithImage(_ image:UIImage?,
                                               fontSize:CGFloat,
                                               location:Int){
        if let image = image{
            let imageAttributeText = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: fontSize)
            if let lenght = self.attibuteText?.length,let imageAttributeText = imageAttributeText {
                if location >= lenght {
                    self.attibuteText?.append(imageAttributeText)
                }
                if location < lenght {
                    self.attibuteText?.insert(imageAttributeText, at: location)
                }
            }
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
        }
    }
    override func handleLineSpacing() {
        
    }
}

extension YYText{
    
    /// set content of the Text
    /// - Parameter value: a string value
    /// - Returns: self
    @discardableResult
    public func text(_ value:@escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            textNode?.setText(value())
        }, forKey: #function)
    }
    
    /// set the font of the receiver's text.
    /// - Parameter value: a UIFont value
    /// - Returns: self
    @discardableResult
    public func font(_ value: @escaping @autoclosure () -> UIFont)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            textNode?.font = value()
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
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_name = name(), f_size = size(), f_style = style()
            textNode?.fontName = f_name
            textNode?.fontSize = f_size
            textNode?.fontStyle = f_style
            let font = UIFont.font(fontName: f_name, fontStyle: f_style, fontSize: f_size)
            textNode?.font(font)
        }, forKey: #function)
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: self
    @discardableResult
    public func font(name value: @escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_name = value()
            textNode?.fontName = f_name
            let font = UIFont.font(fontName: f_name, fontStyle: textNode?.fontStyle, fontSize: textNode?.fontSize)
            textNode?.font(font)
        }, forKey: #function)
    }
    
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: self
    @discardableResult
    public  func font(size value: @escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_size = value()
            textNode?.fontSize = f_size
            let font = UIFont.font(fontName: textNode?.fontName, fontStyle:  textNode?.fontStyle, fontSize: f_size)
            textNode?.font(font)
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
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_style = value()
            textNode?.fontStyle = value()
            let font = UIFont.font(fontName: textNode?.fontName, fontStyle: f_style, fontSize: textNode?.fontSize)
            textNode?.font(font)
        }, forKey: #function)
    }
    
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value:@escaping @autoclosure () -> UIColor)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textColor(value())
        }, forKey: #function)
    }
    
    /// change the rgba-color of the text.
    /// - Parameters:
    ///   - r: the red value of the color object, data range from 0 to 255.
    ///   - g: the green value of the color object, data range from 0 to 255.
    ///   - b: the blue value of the color object, data range from 0 to 255.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat = 1)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
            textNode?.textColor(value)
        }, forKey: #function)
    }
    
    /// change the rgba-color of the text
    /// - Parameters:
    ///   - hex: rgb color, ex: 0xaabbcc representing the red value is 0xaa, the green value is 0xbb and the blue value is 0xcc.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textColor(hex:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float = 1)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
            textNode?.textColor(value)
        }, forKey: #function)
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
    public func textAlign(_ value:@escaping @autoclosure () -> NSTextAlignment,
                          range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            addAttribute(#selector(setter:UILabel.textAlignment),value().rawValue)
            textNode?.textAlignment(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.setAttributedText(value())
        }, forKey: #function)
    }
    
    ///  The distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter value: new points value
    /// - Returns: self
    @discardableResult
    public func lineSpacing(_ value:@escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.lineSpacing(value())
        }, forKey: #function)
    }
    
    /// set the shadow, in points, for the text
    /// - Parameter value: new NSShadow value
    /// - Returns: self
    @discardableResult
    public func textShadow(_ value:@escaping @autoclosure () -> NSShadow,
                           range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.shadow(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Returns: self
    @discardableResult
    public func textShadowOffset(_ value:@escaping @autoclosure () -> CGSize,
                                 range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            textNode?.shadowOffset(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Returns: self
    @discardableResult
    public func textShadowBlurRadius(_ value:@escaping @autoclosure () -> CGFloat,
                                     range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            textNode?.shadowBlurRadius(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow color for the text
    /// - Parameter value: a new color
    /// - Returns: self
    @discardableResult
    public func textShadowColor(_ value:@escaping @autoclosure () -> UIColor,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            textNode?.shadowColor(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow color for the text, the color is generated by the rgba value.
    /// - Parameters:
    ///   - r: red value of the color object, data range form 0 to 255
    ///   - g: green value of the color object, data range form 0 to 255
    ///   - b: blue value of the color object, data range form 0 to 255
    ///   - a: opacity value of the color object, data range form 0 to 255
    /// - Returns: self
    @discardableResult
    public func textShadowColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat = 1,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
            textNode?.shadowColor(value,range: range())
        }, forKey: #function)
    }
    
    /// set the shadow color for the text, the color is generated by the rgba value.
    /// - Parameters:
    ///   - hex: rgb value of the color object, ex: 0xaabbcc representing red value is 0xaa, green value is 0xbb, blue value is 0xcc.
    ///   - a: opaity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textShadowColor(hex :@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float = 1,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
            textNode?.shadowColor(value,range: range())
        }, forKey: #function)
    }
    
    /// The technique for wrapping and truncating the label’s text. Call lineBreakMode of the UILabel directly.
    /// - Parameter value: new line break mode
    /// - Returns: self
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
    public func breakMode(_ value:@escaping @autoclosure () -> NSLineBreakMode,
                          range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.lineBreakMode(value(),range: range())
        }, forKey: #function)
    }
    
     /// Convenience method to set text highlight
    /// - Parameters:
     ///    - range           text range
     ///    - color           text color (pass nil to ignore)
     ///    - backgroundColor text background color when highlight
     ///    - userInfo        user information dictionary (pass nil to ignore)
     ///    - tapAction       tap action when user tap the highlight (pass nil to ignore)
     ///    - longPressAction long press action when user long press the highlight (pass nil to ignore)
    @discardableResult
    public func textHighlightRange(_ range:NSRange?,
                               color:UIColor?,
                               backgroundColor:UIColor?,
                               tapAction:YYTextAction? = nil,
                               longPressAction:YYTextAction? = nil) ->Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.setTextHighlightRange(range, color: color, backgroundColor: backgroundColor, userInfo: nil, tapAction: tapAction, longPressAction: longPressAction)
        }, forKey: #function)
    }
    /// A kerning adjustment.
     
    /// @discussion Default is standard kerning. The kerning attribute indicate how many
    /// points the following character should be shifted from its default offset as
    /// defined by the current character's font in points; a positive kern indicates a
    /// shift farther along and a negative kern indicates a shift closer to the current
    /// character. If this attribute is not present, standard kerning will be used.
    /// If this attribute is set to 0.0, no kerning will be done at all.
    /// @discussion Set this property applies to the entire text string.
    /// Get this property returns the first character's attribute.

    /// - Parameter value: a new kern
    /// - Returns: self
    @discardableResult
    public func kern(_ value:@escaping @autoclosure () -> Float,
                     range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.kern(NSNumber(value:value()))
        }, forKey: #function)
    }
    
    @discardableResult
    public func textEffect(_ value:@escaping @autoclosure () -> String?,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textEffect(value(),range: range())
        }, forKey: #function)
    }
    
    public func strokeWidth(_ value:@escaping @autoclosure () -> Float,
                            range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.strokeWidth(NSNumber(value: value()),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func strokeColor(_ value:@escaping @autoclosure () -> UIColor?,
                            range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.strokeColor(value(),range: range())
        }, forKey: #function)
    }
    
    public func strikethroughStyle(_ value:@escaping @autoclosure () -> NSUnderlineStyle,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.strikethroughStyle(value(),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func strikethroughColor(_ value:@escaping @autoclosure () -> UIColor?,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.strikethroughColor(value(),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func underlineStyle(_ value:@escaping @autoclosure () -> NSUnderlineStyle,
                               range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.underlineStyle(value(),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func underlineColor(_ value:@escaping @autoclosure () -> UIColor?,
                               range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.underlineColor(value(),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func obliqueness(_ value:@escaping @autoclosure () -> Float,
                            range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.obliqueness(NSNumber(value:value()),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func expansion(_ value:@escaping @autoclosure () -> Float,
                          range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.expansion(NSNumber(value:value()),range: range())
        }, forKey: #function)
    }
    @discardableResult
    public func baselineOffset(_ value:@escaping @autoclosure () -> Float,
                               range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.baselineOffset(NSNumber(value:value()),range: range())
        }, forKey: #function)
    }
    
    @discardableResult
    func baseWritingDirection(_ value:@escaping @autoclosure () -> NSWritingDirection,
                              range: @escaping @autoclosure () -> NSRange? = nil) -> Self  {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.baseWritingDirection(value(),range: range())
        }, forKey: #function)
    }
    

    @discardableResult
    public func paragraphSpacing(_ value: @escaping @autoclosure () -> CGFloat,
                                 range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.paragraphSpacing(value(),range: range())
        }, forKey: #function)
    }

    
    @discardableResult
    public func paragraphSpacingBefore(_ value:@escaping @autoclosure () -> CGFloat,
                                       range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.paragraphSpacingBefore(value(),range: range())
        }, forKey: #function)
    }

    
    public func firstLineHeadIndent(_ value: @escaping @autoclosure () -> CGFloat,
                             range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.firstLineHeadIndent(value(),range: range())
        }, forKey: #function)
    }


    @discardableResult
    public func headIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.headIndent(value(),range: range())
        }, forKey: #function)
    }

    
    @discardableResult
    public func tailIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.tailIndent(value(),range: range())
        }, forKey: #function)
    }

    
    @discardableResult
    public func minimumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.minimumLineHeight(value(),range: range())
        }, forKey: #function)
    }

    @discardableResult
    public func maximumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.maximumLineHeight(value(),range: range())
        }, forKey: #function)
    }

    
    @discardableResult
    public func lineHeightMultiple(_ value: @escaping @autoclosure () -> CGFloat,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.lineHeightMultiple(value(),range: range())
        }, forKey: #function)
    }

    @discardableResult
    public func hyphenationFactor(_ value: @escaping @autoclosure () -> Float,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.hyphenationFactor(value(),range: range())
        }, forKey: #function)
    }


    @discardableResult
    public func defaultTabInterval(_ value: @escaping @autoclosure () -> CGFloat,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.defaultTabInterval(value(),range: range())
        }, forKey: #function)
    }
    
    @discardableResult
    public func setLink(_ link:@escaping @autoclosure () -> Any?,range:@escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.setLink(link(),range: range())
        }, forKey: #function)
    }
    
    @discardableResult
    public func attachmentStringWithImage(_ image:@escaping @autoclosure () -> UIImage,
                                               fontSize:@escaping @autoclosure () -> CGFloat,
                                               location:@escaping @autoclosure () -> Int) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.attachmentStringWithImage(image(), fontSize: fontSize(), location: location())
        }, forKey: #function)
    }
    
    @discardableResult
    public func attachmentStringWithImage(_ named:@escaping @autoclosure () -> String,
                                               fontSize:@escaping @autoclosure () -> CGFloat,
                                               location:@escaping @autoclosure () -> Int) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            let image:UIImage? = UIImage(named: named())
            textNode?.attachmentStringWithImage(image, fontSize: fontSize(), location: location())
        }, forKey: #function)
    }

}
