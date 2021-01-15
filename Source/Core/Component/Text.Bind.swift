//
//  Text.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

public protocol TextProtocol: View {
    var textNode: TextNodeProtocol { get }
    
    func font(name: @escaping @autoclosure () -> String?, style: @escaping @autoclosure () -> AKFontStyle, size: @escaping @autoclosure () -> CGFloat)->Self
    func font(name value: @escaping @autoclosure () -> String?)->Self
    func font(size value: @escaping @autoclosure () -> CGFloat)->Self
    func font(style value: @escaping @autoclosure () -> AKFontStyle)->Self
    func textColor(_ value:@escaping @autoclosure () -> UIColor)->Self
    func textAlign(_ value:@escaping @autoclosure () -> NSTextAlignment)->Self
    func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self
    func lineSpacing(_ value:@escaping @autoclosure () -> CGFloat)->Self
    func textColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat)->Self
    func textColor(hex:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float)->Self
    func textShadowOffset(_ value:@escaping @autoclosure () -> CGSize)->Self
    func textShadowColor(_ value:@escaping @autoclosure () -> UIColor)->Self
    func textShadowColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat)->Self
    func textShadowColor(hex :@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float)->Self
    func breakMode(_ value:@escaping @autoclosure () -> NSLineBreakMode)->Self
    func highlightedTextColor(_ value:@escaping @autoclosure () -> UIColor?)->Self
    func isHighlighted(_ value:@escaping @autoclosure () -> Bool)->Self
    func userInteractionEnabled(_ value:@escaping @autoclosure () -> Bool)->Self
    func isEnabled(_ value:@escaping @autoclosure () -> Bool)->Self
    func lineLimit(_ value:@escaping @autoclosure () -> Int)->Self
    func adjustsFontSizeToFitWidth(_ value:@escaping @autoclosure () -> Bool)->Self
    func baselineAdjustment(_ value:@escaping @autoclosure () -> UIBaselineAdjustment)->Self
    func minimumScaleFactor(_ value:@escaping @autoclosure () -> CGFloat)->Self
    func allowsDefaultTighteningForTruncation(_ value:@escaping @autoclosure () -> Bool)->Self
    func lineBreakStrategy(_ value:@escaping @autoclosure () -> NSParagraphStyle.LineBreakStrategy)->Self
    func preferredMaxLayoutWidth(in value: @escaping @autoclosure () -> CGFloat)->Self
}


extension TextProtocol {
    /// set content of the Text
    /// - Parameter value: a string value
    /// - Returns: self
    @discardableResult
    public func text(_ value:@escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({
            addAttribute(#selector(setter:UILabel.text),value())
            textNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// set the font of the receiver's text.
    /// - Parameter value: a UIFont value
    /// - Returns: self
    @discardableResult
    public func font(_ value: @escaping @autoclosure () -> UIFont)->Self{
        return self.bindCallback({
            addAttribute(#selector(setter:UILabel.font),value())
            textNode.handleLineSpacing()
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
            textNode.fontName = f_name
            textNode.fontSize = f_size
            textNode.fontStyle = f_style
            let font = UIFont.font(fontName: f_name, fontStyle: f_style, fontSize: f_size)
            addAttribute(#selector(setter:UILabel.font),font)
            textNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: self
    @discardableResult
    public func font(name value: @escaping @autoclosure () -> String?)->Self{
        return self.bindCallback({
            let f_name = value()
            textNode.fontName = f_name
            let font = UIFont.font(fontName: f_name, fontStyle: textNode.fontStyle, fontSize: textNode.fontSize)
            addAttribute(#selector(setter:UILabel.font),font)
            textNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: self
    @discardableResult
    public  func font(size value: @escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({
            let f_size = value()
            textNode.fontSize = f_size
            let font = UIFont.font(fontName: textNode.fontName, fontStyle:  textNode.fontStyle, fontSize: f_size)
            addAttribute(#selector(setter:UILabel.font),font)
            textNode.handleLineSpacing()
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
            textNode.fontStyle = value()
            let font = UIFont.font(fontName: textNode.fontName, fontStyle: f_style, fontSize: textNode.fontSize)
            addAttribute(#selector(setter:UILabel.font),font)
            textNode.handleLineSpacing()
        }, forKey: #function)
    }
    
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value:@escaping @autoclosure () -> UIColor)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.textColor),value())
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
    public func textAlign(_ value:@escaping @autoclosure () -> NSTextAlignment)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.textAlignment),value().rawValue)
		}, forKey: #function)
    }
    
    /// set the styled text that the label displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value:@escaping @autoclosure () -> NSAttributedString?)->Self{
		return self.bindCallback({ [self] in 
			textNode.attributedText(attri: value())
		}, forKey: #function)
    }
    
    ///  The distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter value: new points value
    /// - Returns: self
    @discardableResult
    public func lineSpacing(_ value:@escaping @autoclosure () -> CGFloat)->Self{
		return self.bindCallback({ [self] in 
			textNode.lineSpacing(value())
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
		return self.bindCallback({ [self] in 
			let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
			addAttribute(#selector(setter:UILabel.textColor),value);
		}, forKey: #function)
    }
    
    /// change the rgba-color of the text
    /// - Parameters:
    ///   - hex: rgb color, ex: 0xaabbcc representing the red value is 0xaa, the green value is 0xbb and the blue value is 0xcc.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textColor(hex:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float = 1)->Self{
		return self.bindCallback({ [self] in 
			let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
			addAttribute(#selector(setter:UILabel.textColor),value);
		}, forKey: #function)
    }
    
    /// set the shadow offset, in points, for the text
    /// - Parameter value: new offset value
    /// - Returns: self
    @discardableResult
    public func textShadowOffset(_ value:@escaping @autoclosure () -> CGSize)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.shadowOffset),value())
		}, forKey: #function)
    }
    
    /// set the shadow color for the text
    /// - Parameter value: a new color
    /// - Returns: self
    @discardableResult
    public func textShadowColor(_ value:@escaping @autoclosure () -> UIColor)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.shadowColor),value())
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
    public func textShadowColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat = 1)->Self{
		return self.bindCallback({ [self] in 
			let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
			addAttribute(#selector(setter:UILabel.shadowColor),value);
		}, forKey: #function)
    }
    
    /// set the shadow color for the text, the color is generated by the rgba value.
    /// - Parameters:
    ///   - hex: rgb value of the color object, ex: 0xaabbcc representing red value is 0xaa, green value is 0xbb, blue value is 0xcc.
    ///   - a: opaity value of the color object, data range from 0 to 1.
    /// - Returns: self
    @discardableResult
    public func textShadowColor(hex :@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float = 1)->Self{
		return self.bindCallback({ [self] in 
			let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
			addAttribute(#selector(setter:UILabel.shadowColor),value);
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
    public func breakMode(_ value:@escaping @autoclosure () -> NSLineBreakMode)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.lineBreakMode),value().rawValue)
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
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UILabel.numberOfLines),value())
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
}
