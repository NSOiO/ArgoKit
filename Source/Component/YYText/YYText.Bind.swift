//
//  YYText.Bind.swift
//  ArgoKitComponent
//
//  Created by Bruce on 2021/1/22.
//
import Foundation
import ArgoKit
import YYText
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
    
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.setAttributedText(attri: value())
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
    public func font(name: @escaping @autoclosure () -> String?,
                     style: @escaping @autoclosure () -> AKFontStyle,
                     size: @escaping @autoclosure () -> CGFloat,
                     range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_name = name(), f_size = size(), f_style = style()
            textNode?.fontName = f_name
            textNode?.fontSize = f_size
            textNode?.fontStyle = f_style
            let font = UIFont.font(fontName: f_name, fontStyle: f_style, fontSize: f_size)
            textNode?.font(font,range: range())
        }, forKey: #function)
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: self
    @discardableResult
    public func font(name value: @escaping @autoclosure () -> String?
                     ,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_name = value()
            textNode?.fontName = f_name
            let font = UIFont.font(fontName: f_name, fontStyle: textNode?.fontStyle, fontSize: textNode?.fontSize)
            textNode?.font(font,range: range())
        }, forKey: #function)
    }
    
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: self
    @discardableResult
    public  func font(size value: @escaping @autoclosure () -> CGFloat
                      ,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_size = value()
            textNode?.fontSize = f_size
            let font = UIFont.font(fontName: textNode?.fontName, fontStyle:  textNode?.fontStyle, fontSize: f_size)
            textNode?.font(font,range: range())
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
    public func font(style value: @escaping @autoclosure () -> AKFontStyle
                     ,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let f_style = value()
            textNode?.fontStyle = value()
            let font = UIFont.font(fontName: textNode?.fontName, fontStyle: f_style, fontSize: textNode?.fontSize)
            textNode?.font(font,range: range())
        }, forKey: #function)
    }
    
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value:@escaping @autoclosure () -> UIColor
                          ,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textColor(value(),range: range())
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
    public func textColor(red r:@escaping @autoclosure () -> Int,
                          green g :@escaping @autoclosure () -> Int,
                          blue b:@escaping @autoclosure () -> Int,
                          alpha a:@escaping @autoclosure () -> CGFloat = 1,
                          range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
            textNode?.textColor(value,range: range())
        }, forKey: #function)
    }
    
    /// change the rgba-color of the text
    /// - Parameters:
    ///   - hex: rgb color, ex: 0xaabbcc representing the red value is 0xaa, the green value is 0xbb and the blue value is 0xcc.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textColor(hex:@escaping @autoclosure () -> Int,
                          alpha a:@escaping @autoclosure () -> Float = 1,
                          range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? YYTextNode] in
            let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
            textNode?.textColor(value,range: range())
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
    /// - Parameter range: new range value
    /// - Returns: self
    @discardableResult
    public func textShadow(_ value:@escaping @autoclosure () -> NSShadow,
                           range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.shadow(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow, in points, for the text
    /// - Parameter color: new color value
    /// - Parameter offset: new offset value
    /// - Parameter blurRadius: new blurRadius value
    /// - Parameter range: new range value
    /// - Returns: self
    func textShadow(color:@escaping @autoclosure () ->UIColor,
                    offset:@escaping @autoclosure () ->CGSize,
                    blurRadius:@escaping @autoclosure () ->CGFloat,
                    range: @escaping @autoclosure () ->NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.shadow(color: color(), offset: offset(), blurRadius: blurRadius(),range: range())
        }, forKey: #function)
    }
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Parameter range: new range value
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
    /// - Parameter range: new range value
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
    /// - Parameter range: new range value
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
    ///   - range: new range value
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
    ///   - range: new range value
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
    /// - Parameter range: new range value
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
                               tapAction:((NSAttributedString, NSRange)->())? = nil,
                               longPressAction:((NSAttributedString, NSRange)->())? = nil) ->Self {
        if let textNode = self.node as? YYTextNode{
            textNode.setTextHighlightRange(range, color: color, backgroundColor: backgroundColor, userInfo: nil, tapAction: tapAction, longPressAction: longPressAction)
        }
        return self
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
    /// - Parameter range: new range value
    /// - Returns: self
    @discardableResult
    public func kern(_ value:@escaping @autoclosure () -> Float,
                     range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.kern(NSNumber(value:value()))
        }, forKey: #function)
    }
    
    /// The text effect.
    ///  Default is nil (no effect). The only currently supported value
    /// is NSTextEffectLetterpressStyle.
    /// @discussion Set this property applies to the entire text string.
    /// Get this property returns the first character's attribute.
    @discardableResult
    public func textEffect(_ value:@escaping @autoclosure () -> String?,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textEffect(value(),range: range())
        }, forKey: #function)
    }
    
    /// The stroke with width and color.
    /// - Parameter width: Default value is 0.0 (no stroke). This attribute, interpreted as
    /// -  a percentage of font point size, controls the text drawing mode: positive
    /// -  values effect drawing with stroke only; negative values are for stroke and fill.
    /// -  A typical value for outlined text is 3.0.
    /// - Set this property applies to the entire text string.
     
    /// - Parameter color: Default value is nil (same as foreground color).
    /// Set this property applies to the entire text string.
    public func stroke(width:@escaping @autoclosure () -> Float,
                       color:@escaping @autoclosure () -> UIColor?,
                            range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.stroke(width:NSNumber(value: width()),color:color(),range: range())
        }, forKey: #function)
    }

    /// The strikethrough with style and color.
     
    /// - Parameter style: value is NSUnderlineStyleNone (no strikethrough).
    /// - Set this property applies to the entire text string.
    ///  - Parameter width: width of line
    ///  - Parameter color: Default value is nil (same as foreground color).
    ///  - Set this property applies to the entire text string.

    public func strikethrough(style:@escaping @autoclosure () -> YYTextLineStyle,
                              width:@escaping @autoclosure () -> Float,
                              color:@escaping @autoclosure () -> UIColor?,
                              range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.strikethrough(style: style(),width:NSNumber(value: width()), color: color(),range: range())
        }, forKey: #function)
    }

    /// The underline with style and color.
     
    /// - Parameter style: value is NSUnderlineStyleNone (no strikethrough).
    /// - Set this property applies to the entire text string.
    ///  - Parameter width: width of line
    ///  - Parameter color: Default value is nil (same as foreground color).
    ///  - Set this property applies to the entire text string.
    @discardableResult
    public func underline(style:@escaping @autoclosure () -> YYTextLineStyle,
                          width:@escaping @autoclosure () -> Float,
                          color:@escaping @autoclosure () -> UIColor?,
                               range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.underline(style: style(),width: NSNumber(value: width()),color: color(),range: range())
        }, forKey: #function)
    }
//    /// The skew to be applied to glyphs.
//     
//    /// - Parameter value: Default is 0 (no skew).
//    /// -Set this property applies to the entire text string.
//    @discardableResult
//    public func obliqueness(_ value:@escaping @autoclosure () -> Float,
//                            range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
//        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
//            textNode?.obliqueness(NSNumber(value:value()),range: range())
//        }, forKey: #function)
//    }
//    
//    /// The log of the expansion factor to be applied to glyphs.
//     
//    /// - Parameter value: is 0 (no expansion).
//    /// - Set this property applies to the entire text string.
//    @discardableResult
//    public func expansion(_ value:@escaping @autoclosure () -> Float,
//                          range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
//        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
//            textNode?.expansion(NSNumber(value:value()),range: range())
//        }, forKey: #function)
//    }
    
    /// The character's offset from the baseline, in points.
     
    /// - Parameter value: Default is 0.
    // - Set this property applies to the entire text string.
    @discardableResult
    public func baselineOffset(_ value:@escaping @autoclosure () -> Float,
                               range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.baselineOffset(NSNumber(value:value()),range: range())
        }, forKey: #function)
    }
    
    /// The base writing direction.
    /// - Parameter value: If you specify NSWritingDirectionNaturalDirection, the receiver resolves
    /// - the writing direction to either NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft,
    /// - depending on the direction for the user's `language` preference setting.
    /// - Default is NSWritingDirectionNatural.
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func baseWritingDirection(_ value:@escaping @autoclosure () -> NSWritingDirection,
                              range: @escaping @autoclosure () -> NSRange? = nil) -> Self  {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.baseWritingDirection(value(),range: range())
        }, forKey: #function)
    }
    
    /// The space after the end of the paragraph (A wrapper for NSParagraphStyle).
     
    /// - Parameter value: This property contains the space (measured in points) added at the
    /// - end of the paragraph to separate it from the following paragraph. This value must
    /// - be nonnegative. The space between paragraphs is determined by adding the previous
    /// - paragraph's paragraphSpacing and the current paragraph's paragraphSpacingBefore.
    /// - Default is 0.
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func paragraphSpacing(_ value: @escaping @autoclosure () -> CGFloat,
                                 range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.paragraphSpacing(value(),range: range())
        }, forKey: #function)
    }

    /// The distance between the paragraph's top and the beginning of its text content.
    /// (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property contains the space (measured in points) between the
    /// -paragraph's top and the beginning of its text content.
    /// - Default is 0.
    /// - Get this property returns the first character's attribute.
    @discardableResult
    public func paragraphSpacingBefore(_ value:@escaping @autoclosure () -> CGFloat,
                                       range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.paragraphSpacingBefore(value(),range: range())
        }, forKey: #function)
    }

    /// The indentation of the first line (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property contains the distance (in points) from the leading margin
    /// -of a text container to the beginning of the paragraph's first line. This value
    /// -is always nonnegative.
    /// - Default is 0.
    public func firstLineHeadIndent(_ value: @escaping @autoclosure () -> CGFloat,
                             range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.firstLineHeadIndent(value(),range: range())
        }, forKey: #function)
    }

    /// The indentation of the receiver's lines other than the first. (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property contains the distance (in points) from the leading margin
    /// - of a text container to the beginning of lines other than the first. This value is
    /// - always nonnegative.
    /// -  Default is 0.
    @discardableResult
    public func headIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.headIndent(value(),range: range())
        }, forKey: #function)
    }

    /// The trailing indentation (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: If positive, this value is the distance from the leading margin
    /// -(for example, the left margin in left-to-right text). If 0 or negative, it's the
    /// -distance from the trailing margin.
    /// - Default is 0.
    @discardableResult
    public func tailIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.tailIndent(value(),range: range())
        }, forKey: #function)
    }

    /// The receiver's minimum height (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property contains the minimum height in points that any line in
    /// - the receiver will occupy, regardless of the font size or size of any attached graphic.
    /// - This value must be nonnegative.
    /// -  Default is 0.
    @discardableResult
    public func minimumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.minimumLineHeight(value(),range: range())
        }, forKey: #function)
    }
    
    /// The receiver's maximum line height (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property contains the maximum height in points that any line in
    /// - the receiver will occupy, regardless of the font size or size of any attached graphic.
    /// - This value is always nonnegative. Glyphs and graphics exceeding this height will
    /// - overlap neighboring lines; however, a maximum height of 0 implies no line height limit.
    /// - Although this limit applies to the line itself, line spacing adds extra space between adjacent lines.
    /// - Default is 0 (no limit).
    @discardableResult
    public func maximumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.maximumLineHeight(value(),range: range())
        }, forKey: #function)
    }

    /// The line height multiple (A wrapper for NSParagraphStyle). (read-only)
    /// - Parameter value: This property contains the line break mode to be used laying out the paragraph's text.
    /// - Default is 0 (no multiple).
    @discardableResult
    public func lineHeightMultiple(_ value: @escaping @autoclosure () -> CGFloat,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.lineHeightMultiple(value(),range: range())
        }, forKey: #function)
    }

    /// The paragraph's threshold for hyphenation. (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: Valid values lie between 0.0 and 1.0 inclusive. Hyphenation is attempted
    /// -when the ratio of the text width (as broken without hyphenation) to the width of the
    /// -line fragment is less than the hyphenation factor. When the paragraph's hyphenation
    /// -factor is 0.0, the layout manager's hyphenation factor is used instead. When both
    /// -are 0.0, hyphenation is disabled.
    /// - Default is 0.
    @discardableResult
    public func hyphenationFactor(_ value: @escaping @autoclosure () -> Float,
                                  range: @escaping @autoclosure () -> NSRange? = nil) -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.hyphenationFactor(value(),range: range())
        }, forKey: #function)
    }

    /// The document-wide default tab interval (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter value: This property represents the default tab interval in points. Tabs after the
    /// - last specified in tabStops are placed at integer multiples of this distance (if positive).
    /// - Default is 0.
    @discardableResult
    public func defaultTabInterval(_ value: @escaping @autoclosure () -> CGFloat,
                                   range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.defaultTabInterval(value(),range: range())
        }, forKey: #function)
    }
    
    
    
    ///  The truncation token string used when text is truncated. Default is nil.
    ///  When the value is nil, the label use "…" as default truncation token.
    /// - Parameter value:new truncationToken value
    @discardableResult
    public func truncationToken(_ value:String) -> Self {
        return self.bindCallback({ [self] in
            let truToken = NSAttributedString(string: value)
            addAttribute(#selector(setter: YYLabel.truncationToken),truToken)
        }, forKey: #function)
    }
    
    ///  An array of NSTextTab objects representing the receiver's tab stops.
    ///  (A wrapper for NSParagraphStyle). (read-only)
     
    /// - Parameter tabs: The NSTextTab objects, sorted by location, define the tab stops for
    /// - the paragraph style.
    /// - Default is 12 TabStops with 28.0 tab interval.
    @discardableResult
    public func tabStops(_ tabs:@escaping ()->[NSTextTab],range:NSRange? = nil)  -> Self {
        if let textNode = self.node as? YYTextNode{
            let tabs_ = tabs()
            textNode.tabStops(tabs_, range: range)
        }
        return self
    }
    
    /// Set up hyperlinks
     
    /// - Parameter range: range of hyperlinks
    /// - Parameter color: color of hyperlinks
    /// - Parameter backgroundColor:backgroundColor of hyperlinks
    /// - Parameter tapAction:tap action of hyperlinks
    @discardableResult
    public func setLink(range:NSRange?,
                        color:UIColor?,
                        backgroundColor:UIColor?,
                               tapAction:@escaping (String)->()) -> Self {
        if let textNode = self.node as? YYTextNode{
            textNode.setLink(range:range, color: color, backgroundColor: backgroundColor, userInfo: nil, tapAction: tapAction)
        }
        return self
    }
    
    /// insert a attahment from a fourquare image as if it was an emoji.
     
    /// - Parameter image: image     A fourquare image.
    /// - Parameter fontSize:  The font size.
    /// - Parameter location:  The inserted location.
    @discardableResult
    public func attachmentStringWithImage(_ image:@escaping @autoclosure () -> UIImage,
                                               fontSize:@escaping @autoclosure () -> CGFloat,
                                               location:@escaping @autoclosure () -> Int) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.attachmentStringWithImage(image(), fontSize: fontSize(), location: location())
        }, forKey: #function)
    }
    
    /// insert a attahment from a fourquare image as if it was an emoji.
     
    /// - Parameter named: image     A fourquare image name.
    /// - Parameter fontSize:  The font size.
    /// - Parameter location:  The inserted location.
    @discardableResult
    public func attachmentStringWithImage(_ named:@escaping @autoclosure () -> String,
                                               fontSize:@escaping @autoclosure () -> CGFloat,
                                               location:@escaping @autoclosure () -> Int) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            let image:UIImage? = UIImage(named: named())
            textNode?.attachmentStringWithImage(image, fontSize: fontSize(), location: location())
        }, forKey: #function)
    }
    
    /// The text border.
     
    /// - Parameter value: Default value is nil (no border).
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func textBorder(_ value:YYTextBorder,range: NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textBorder(value,range:range)
        }, forKey: #function)
    }
    
    /// The text border.
     
    /// - Parameter style: border  line style
    /// - Parameter style: border  line width
    /// - Parameter style: border  line color
    /// - Parameter style: border  line cornerRadius
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func textBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil)
    -> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textBorder(style: style, width: width, color: color, cornerRadius: cornerRadius, range: range)
        }, forKey: #function)
    }
    
    /// The text background border.
     
    /// - Parameter value: Default value is nil (no border).
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func textBackgroundBorder(_ value:YYTextBorder,range: NSRange? = nil)  -> Self {
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textBackgroundBorder(value,range:range)
        }, forKey: #function)
    }
    
    /// The text background border.
     
    /// - Parameter style: border  line style
    /// - Parameter style: border  line width
    /// - Parameter style: border  line color
    /// - Parameter style: border  line cornerRadius
    /// - Set this property applies to the entire text string.
    @discardableResult
    public func textBackgroundBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil)-> Self{
        return self.bindCallback({ [textNode = self.node as? YYTextNode] in
            textNode?.textBackgroundBorder(style: style, width: width, color: color, cornerRadius: cornerRadius, range: range)
        }, forKey: #function)
    }

}

extension YYText{
    /// Adds tap gesture to this View
    /// - Parameters:
    ///   - numberOfTaps: The number of taps necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that the user must tap for gesture recognition.
    ///   - action: The action to handle the gesture recognized by the receiver.
    /// - Returns: Self
    @discardableResult
    public func onTapGesture(numberOfTaps: Int = 1, numberOfTouches: Int = 1, action: @escaping () -> Void) -> Self {
        if let textNode = self.node as? YYTextNode{
            textNode.textTapAction = {_,_,_,_ in
                action()
            }
        }
        return self
    }

    /// Adds long press gesture to this View
    /// - Parameters:
    ///   - numberOfTaps: The number of taps on the view necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that must touch the view for gesture recognition.
    ///   - minimumPressDuration: The minimum time that the user must press on the view for the gesture to be recognized.
    ///   - allowableMovement: The maximum movement of the fingers on the view before the gesture fails.
    ///   - action: The action to handle the gesture recognized by the receiver.
    /// - Returns: Self
    @discardableResult
    public func onLongPressGesture(numberOfTaps: Int = 0, numberOfTouches: Int = 1, minimumPressDuration: TimeInterval = 0.5, allowableMovement: CGFloat = 10, action:@escaping () -> Void ) -> Self {
        if let textNode = self.node as? YYTextNode{
            textNode.textLongAction = {_,_,_,_ in
                action()
            }
        }
        return self
    }
}
