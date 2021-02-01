//
//  Text.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

public protocol TextProtocol: View {
    func text(_ value:@escaping @autoclosure () -> String?)->Self
    func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self
    
    func font(name: @escaping @autoclosure () -> String?,
              style: @escaping @autoclosure () -> AKFontStyle,
              size: @escaping @autoclosure () -> CGFloat,
              range: @escaping @autoclosure () -> NSRange?)->Self
    func font(name value: @escaping @autoclosure () -> String?,
              range: @escaping @autoclosure () -> NSRange?)->Self
    func font(size value: @escaping @autoclosure () -> CGFloat,
              range: @escaping @autoclosure () -> NSRange?)->Self
    func font(style value: @escaping @autoclosure () -> AKFontStyle,
              range: @escaping @autoclosure () -> NSRange?)->Self
    func textColor(_ value:@escaping @autoclosure () -> UIColor,
                   range: @escaping @autoclosure () -> NSRange?)->Self
    func textColor(red r:@escaping @autoclosure () -> Int,
                   green g :@escaping @autoclosure () -> Int,
                   blue b:@escaping @autoclosure () -> Int,
                   alpha a:@escaping @autoclosure () -> CGFloat,
                   range: @escaping @autoclosure () -> NSRange?)->Self
    func textColor(hex:@escaping @autoclosure () -> Int,
                   alpha a:@escaping @autoclosure () -> Float,
                   range: @escaping @autoclosure () -> NSRange?)->Self
    
    func lineLimit(_ value:@escaping @autoclosure () -> Int)->Self
    func textAlign(_ value:@escaping @autoclosure () -> NSTextAlignment,range: @escaping @autoclosure () -> NSRange?)->Self
    func lineSpacing(_ value:@escaping @autoclosure () -> CGFloat)->Self
    func breakMode(_ value:@escaping @autoclosure () -> NSLineBreakMode,range: @escaping @autoclosure () -> NSRange?)->Self
    
    func textShadow(_ value:@escaping @autoclosure () -> NSShadow,
                    range: @escaping @autoclosure () -> NSRange?)->Self
    func textShadow(color:@escaping @autoclosure () ->UIColor,
                    offset:@escaping @autoclosure () ->CGSize,
                    blurRadius:@escaping @autoclosure () ->CGFloat,
                    range: @escaping @autoclosure () ->NSRange?)->Self
    func textShadowOffset(_ value:@escaping @autoclosure () -> CGSize,
                          range: @escaping @autoclosure () -> NSRange?)->Self
    func textShadowColor(_ value:@escaping @autoclosure () -> UIColor,
                         range: @escaping @autoclosure () -> NSRange?)->Self
    func textShadowColor(red r:@escaping @autoclosure () -> Int,
                         green g :@escaping @autoclosure () -> Int,
                         blue b:@escaping @autoclosure () -> Int,
                         alpha a:@escaping @autoclosure () -> CGFloat,
                         range: @escaping @autoclosure () -> NSRange?)->Self
    func textShadowColor(hex :@escaping @autoclosure () -> Int,
                         alpha a:@escaping @autoclosure () -> Float,
                         range: @escaping @autoclosure () -> NSRange?)->Self
    func textShadowBlurRadius(_ value:@escaping @autoclosure () -> CGFloat,
                              range: @escaping @autoclosure () -> NSRange?)->Self

    func highlightedTextColor(_ value:@escaping @autoclosure () -> UIColor?)->Self
    func isHighlighted(_ value:@escaping @autoclosure () -> Bool)->Self
    func userInteractionEnabled(_ value:@escaping @autoclosure () -> Bool)->Self
    func isEnabled(_ value:@escaping @autoclosure () -> Bool)->Self
    func adjustsFontSizeToFitWidth(_ value:@escaping @autoclosure () -> Bool)->Self
    func baselineAdjustment(_ value:@escaping @autoclosure () -> UIBaselineAdjustment)->Self
    func minimumScaleFactor(_ value:@escaping @autoclosure () -> CGFloat)->Self
    func allowsDefaultTighteningForTruncation(_ value:@escaping @autoclosure () -> Bool)->Self
    func lineBreakStrategy(_ value:@escaping @autoclosure () -> NSParagraphStyle.LineBreakStrategy)->Self
    func preferredMaxLayoutWidth(in value: @escaping @autoclosure () -> CGFloat)->Self
    
    func kern(_ value:@escaping @autoclosure () -> Float,
                     range: @escaping @autoclosure () -> NSRange?) -> Self 
    func paragraphSpacing(_ value: @escaping @autoclosure () -> CGFloat,
                                 range: @escaping @autoclosure () -> NSRange?) -> Self
    func paragraphSpacingBefore(_ value:@escaping @autoclosure () -> CGFloat,
                                       range: @escaping @autoclosure () -> NSRange?) -> Self
    func firstLineHeadIndent(_ value: @escaping @autoclosure () -> CGFloat,
                             range: @escaping @autoclosure () -> NSRange?) -> Self
    func headIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange?) -> Self
    func tailIndent(_ value: @escaping @autoclosure () -> CGFloat,
                           range: @escaping @autoclosure () -> NSRange?) -> Self
    func minimumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange?) -> Self
    func maximumLineHeight(_ value: @escaping @autoclosure () -> CGFloat,
                                  range: @escaping @autoclosure () -> NSRange?) -> Self
}

extension TextProtocol {
    /// set content of the Text
    /// - Parameter value: a string value
    /// - Returns: self
    @discardableResult
    public func text(_ value:@escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.setText(value())
        }, forKey: #function)
    }
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self{
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.setAttributedText(attri: value())
        }, forKey: #function)
    }
    
    /// set the font of the receiver's text.
    /// - Parameter value: a UIFont value
    /// - Returns: self
    @discardableResult
    public func font(_ value: @escaping @autoclosure () -> UIFont,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.font(value(),range: range())
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
    public func font(name: @escaping @autoclosure () -> String?, style: @escaping @autoclosure () -> AKFontStyle, size: @escaping @autoclosure () -> CGFloat,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
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
    public func font(name value: @escaping @autoclosure () -> String?,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
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
    public  func font(size value: @escaping @autoclosure () -> CGFloat,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
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
    public func font(style value: @escaping @autoclosure () -> AKFontStyle,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
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
    public func textColor(_ value:@escaping @autoclosure () -> UIColor,range: @escaping @autoclosure () -> NSRange? = nil)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode]  in
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
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode]  in
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
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode]  in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode]  in
            textNode?.textAlignment(value(),range: range())
        }, forKey: #function)
    }
    

    
    ///  The distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter value: new points value
    /// - Returns: self
    @discardableResult
    public func lineSpacing(_ value:@escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.setShadow(value(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow, in points, for the text
    /// - Parameter color: new color value
    /// - Parameter offset: new offset value
    /// - Parameter blurRadius: new blurRadius value
    /// - Parameter range: new range value
    /// - Returns: self
    @discardableResult
    public func textShadow(color:@escaping @autoclosure () ->UIColor,
                    offset:@escaping @autoclosure () ->CGSize,
                    blurRadius:@escaping @autoclosure () ->CGFloat,
                    range: @escaping @autoclosure () ->NSRange? = nil)->Self{
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.setShadow(color: color(), offset: offset(), blurRadius: blurRadius(),range: range())
        }, forKey: #function)
    }
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Returns: self
    @discardableResult
    public func textShadowOffset(_ value:@escaping @autoclosure () -> CGSize,
                                 range: @escaping @autoclosure () -> NSRange? = nil)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.shadowOffset(value(),range: range())
		}, forKey: #function)
    }
    
    /// set the shadow color for the text
    /// - Parameter value: a new color
    /// - Returns: self
    @discardableResult
    public func textShadowColor(_ value:@escaping @autoclosure () -> UIColor,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
    public func textShadowColor(red r:@escaping @autoclosure () -> Int,
                                green g :@escaping @autoclosure () -> Int,
                                blue b:@escaping @autoclosure () -> Int,
                                alpha a:@escaping @autoclosure () -> CGFloat = 1,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
    public func textShadowColor(hex :@escaping @autoclosure () -> Int,
                                alpha a:@escaping @autoclosure () -> Float = 1,
                                range: @escaping @autoclosure () -> NSRange? = nil)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
			let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
            textNode?.shadowColor(value,range: range())
		}, forKey: #function)
    }
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Parameter range: new range value
    /// - Returns: self
    @discardableResult
    public func textShadowBlurRadius(_ value:@escaping @autoclosure () -> CGFloat,
                                     range: @escaping @autoclosure () -> NSRange? = nil)->Self{
        return self.bindCallback({[textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.shadowBlurRadius(value(),range: range())
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
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode]  in
            textNode?.lineBreakMode(value(),range: range())
		}, forKey: #function)
    }
    
    /// set the highlight color for the text.
    /// - Parameter value: new color
    /// - Returns: self
    @discardableResult
    public func highlightedTextColor(_ value:@escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.highlightedTextColor),value())
		}, forKey: #function)
    }
    
    /// set a Boolean value that determines whether the label draws its text with a highlight.
    /// - Parameter value: a Boolean value
    /// - Returns: self
    @discardableResult
    public func isHighlighted(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.isHighlighted),value())
		}, forKey: #function)
    }
    
    
    /// Set A Boolean value that determines whether the system ignores and removes user events for this label from the event queue.
    /// - Parameter value: a Boolean value
    /// - Returns: self
    @discardableResult
    public func userInteractionEnabled(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.isUserInteractionEnabled),value())
		}, forKey: #function)
    }
    /// set a Boolean value that determines whether the back label draws its text in an enabled state.
    /// - Parameter value: a Boolean value
    /// - Returns: self
    public func isEnabled(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.isEnabled),value())
		}, forKey: #function)
    }
    
    /// Set the maximum number of lines for rendering text. 0 representing unlimited.
    /// - Parameter value: new maximum number of lines.
    /// - Returns: self
    @discardableResult
    public func lineLimit(_ value:@escaping @autoclosure () -> Int)->Self{
		return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.numberOfLines(value())
		}, forKey: #function)
    }
    
    /// A Boolean value that determines whether the label reduces the text’s font size to fit the title string into the label’s bounding rectangle.
    /// - Parameter value: a new Boolean value
    /// - Returns: self
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.adjustsFontSizeToFitWidth),value())
		}, forKey: #function)
    }
    
    /// An option that controls whether the text's baseline remains fixed when text needs to shrink to fit in the label.
    /// - Parameter value: new option
    /// - Returns: self
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
    public func baselineAdjustment(_ value:@escaping @autoclosure () -> UIBaselineAdjustment)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.baselineAdjustment),value())
		}, forKey: #function)
    }

    
    /// The minimum scale factor for the label’s text.
    /// - Parameter value: scale factor
    /// - Returns: self
    @available(iOS 6.0, *)
    @discardableResult
    public func minimumScaleFactor(_ value:@escaping @autoclosure () -> CGFloat)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.minimumScaleFactor),value())
		}, forKey: #function)
    }

    /// A Boolean value that determines whether the label tightens text before truncating.
    ///
    /// When the value of this property is true, the label tightens intercharacter spacing of its text before allowing any truncation to occur. The label determines the maximum amount of tightening automatically based on the font, current line width, line break mode, and other relevant information. This autoshrinking behavior is only intended for use with a single-line label.
    /// The default value of this property is false.
    /// - Parameter value: new Boolean value
    /// - Returns: self
    @available(iOS 9.0, *)
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value())
		}, forKey: #function)
    }

    /// A Boolean value that determines whether the label tightens text before truncating.
    ///
    /// When the value of this property is true, the label tightens intercharacter spacing of its text before allowing any truncation to occur. The label determines the maximum amount of tightening automatically based on the font, current line width, line break mode, and other relevant information. This autoshrinking behavior is only intended for use with a single-line label.
    /// The default value of this property is false.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func lineBreakStrategy(_ value:@escaping @autoclosure () -> NSParagraphStyle.LineBreakStrategy)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value())
		}, forKey: #function)
    }
    
    /// The preferred maximum width, in points, for a multiline label.
    /// - Parameter value: new value
    /// - Returns: self
    @available(iOS 6.0, *)
    @discardableResult
    public func preferredMaxLayoutWidth(in value: @escaping @autoclosure () -> CGFloat)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.preferredMaxLayoutWidth),value())
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
    /// - Parameter range: new range value
    /// - Returns: self
    @discardableResult
    public func kern(_ value:@escaping @autoclosure () -> Float,
                     range: @escaping @autoclosure () -> NSRange? = nil) -> Self {
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.kern(NSNumber(value:value()))
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
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
        return self.bindCallback({ [textNode = self.node as? ArgoKitTextBaseNode] in
            textNode?.maximumLineHeight(value(),range: range())
        }, forKey: #function)
    }
}
