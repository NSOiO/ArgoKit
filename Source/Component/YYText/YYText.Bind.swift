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
    ///A Boolean value indicating whether the layout and rendering codes are running
    ///asynchronously on background threads.
     
    ///The default value is `NO`.
    @discardableResult
    public 
    func displaysAsynchronously(_ value:Bool) -> Self{
        if let textNode = self.node as? YYTextNode{
            textNode.displaysAsynchronously(asyn: value)
        }
        return self
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
