//
//  TextView.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension TextView {
    /// The text that the text view displays.
    /// In iOS6 and later, assigning a new value to this property also replaces the value of the attributedText property with the same text, albeit without any inherent style attributes. Instead the text view styles the new string using the font, textColor, and other style-related properties of the class.
    /// - Parameter value: a new string value.
    /// - Returns: self
    @discardableResult
    public func text(_ value: @escaping @autoclosure () -> String?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.text),value())
		}, forKey: #function)
    }
    
    /// The font of the text
    ///
    /// This property applies to the entire text string. The default value of this property is the body style of the system font.
    /// - Parameter value: a new font value
    /// - Returns: self
    @discardableResult
    public func font(_ value: @escaping @autoclosure () -> UIFont?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.font),value())
		}, forKey: #function)
    }
    
    /// The color of the text.
    ///
    /// This property applies to the entire text string. The default text color is black.
    /// In iOS 6 and later, assigning a new value to this property causes the new text color to be applied to the entire contents of the text view. If you want to apply the color to only a portion of the text, you must create a new attributed string with the desired style information and assign it to the attributedText property.
    /// - Parameter value: a new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value: @escaping @autoclosure () -> UIColor?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.textColor),value())
		}, forKey: #function)
    }
    
    /// Change the color the text, the color is created by the rgba value.
    /// - Parameters:
    ///   - r: the red value of the color object, data range from 0 to 255.
    ///   - g: the green value of the color object, data range from 0 to 255.
    ///   - b: the blue value of the color object, data range from 0 to 255.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: description
    @discardableResult
    public func textColor(red r:@escaping @autoclosure () -> Int,green g :@escaping @autoclosure () -> Int,blue b:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> CGFloat = 1)->Self{
		return self.bindCallback({ [self] in 
			let value = UIColor(red: CGFloat(Double(r())/255.0), green: CGFloat(Double(g())/255.0), blue: CGFloat(Double(b())/255.0), alpha: a())
			addAttribute(#selector(setter:UITextView.textColor),value);
		}, forKey: #function)
    }
    
    /// Change the color of the text, the color is created by the hex and alpha.
    /// - Parameters:
    ///   - hex: hex number
    ///   - a: alpha value
    /// - Returns: self
    @discardableResult
    public func textColor(hex:@escaping @autoclosure () -> Int,alpha a:@escaping @autoclosure () -> Float = 1)->Self{
		return self.bindCallback({ [self] in 
			let value = ArgoKitUtils.color(withHex: hex(),alpha:a())
			addAttribute(#selector(setter:UITextView.textColor),value);
		}, forKey: #function)
    }
    
    /// The technique for aligning the text. See:UITextView.textAlignment
    ///
    /// This property applies to the entire text string. The default value of this property is NSTextAlignment.natural.
    /// Assigning a new value to this property causes the new text alignment to be applied to the entire contents of the text view. If you want to apply the alignment to only a portion of the text, you must create a new attributed string with the desired style information and assign it to the attributedText property.
    /// - Parameter value: a new test alignment
    /// - Returns: self
    ///
    ///```
    ///    public enum NSTextAlignment : Int {
    ///
    ///
    ///       case left = 0 // Visually left aligned
    ///
    ///
    ///       case center = 1 // Visually centered
    ///
    ///       case right = 2 // Visually right aligned
    ///
    ///        /* !TARGET_ABI_USES_IOS_VALUES */
    ///        // Visually right aligned
    ///        // Visually centered
    ///
    ///        case justified = 3 // Fully-justified. The last line in a paragraph is natural-aligned.
    ///
    ///        case natural = 4 // Indicates the default alignment for script
    ///    }
    ///```
    @discardableResult
    public func textAlign(_ value: @escaping @autoclosure () -> NSTextAlignment) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.textAlignment),value().rawValue)
		}, forKey: #function)
    }
    
    /// Set the font of the text, the font is created by the specified name and style.
    /// - Parameters:
    ///   - name: font name
    ///   - style: font style
    ///   - size: font size
    /// - Returns: self
    ///
    ///```
    ///     public enum AKFontStyle{
    ///         case `default`
    ///         case bold
    ///         case italic
    ///         case bolditalic
    ///     }
    ///```
    @discardableResult
    public func font(name: @escaping @autoclosure () -> String?, style:@escaping @autoclosure () -> AKFontStyle,size:@escaping @autoclosure () -> CGFloat)->Self{
		return self.bindCallback({ [self] in 
        textViewNode.fontName = name()
        textViewNode.fontStyle = style()
        textViewNode.fontSize = size()
			let font = UIFont.font(fontName: name(), fontStyle: style(), fontSize: size())
			self.font(font)
		}, forKey: #function)
    }
    
    /// Change the font name of the text.
    /// - Parameter value: a new font name.
    /// - Returns: self
    @discardableResult
    public func font(name value:@escaping @autoclosure () -> String?)->Self{
		return self.bindCallback({ [self] in 
        textViewNode.fontName = value()
			let font = UIFont.font(fontName: value(), fontStyle: textViewNode.fontStyle, fontSize: textViewNode.fontSize)
			self.font(font)
		}, forKey: #function)
    }
    
    /// Change the font size of the text.
    /// - Parameter value: a new font size.
    /// - Returns: self
    @discardableResult
    public  func font(size value:@escaping @autoclosure () -> CGFloat)->Self{
		return self.bindCallback({ [self] in 
        textViewNode.fontSize = value()
			let font = UIFont.font(fontName: textViewNode.fontName, fontStyle:  textViewNode.fontStyle, fontSize: value())
			self.font(font)
		}, forKey: #function)
    }
    
    /// Change the font style of the text.
    /// - Parameter value: a new style
    /// - Returns: self
    ///
    ///```
    ///     public enum AKFontStyle{
    ///         case `default`
    ///         case bold
    ///         case italic
    ///         case bolditalic
    ///     }
    ///```
    @discardableResult
    public func font(style value:@escaping @autoclosure () -> AKFontStyle)->Self{
		return self.bindCallback({ [self] in 
        textViewNode.fontStyle = value()
			let font = UIFont.font(fontName: textViewNode.fontName, fontStyle: value(), fontSize: textViewNode.fontSize)
			self.font(font)
		}, forKey: #function)
    }
    
    /// A Boolean value that indicates whether the text view is editable.
    ///
    /// See: UITextView.isEditable
    /// The default value of this property is true.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func isEditable(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.isEditable),value())
		}, forKey: #function)
    }
    
    /// A Boolean value that indicates whether the text view is selectable.
    ///
    /// See: UITextView.isSelectable
    /// This property controls the ability of the user to select content and interact with URLs and text attachments. The default value is true.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func isSelectable(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.isSelectable),value())
		}, forKey: #function)
    }
    
    /// A Boolean value that indicates whether the text view allows the user to edit style information.
    ///
    ///See: UITextView.allowsEditingTextAttributes
    /// When set to true, the text view allows the user to change the basic styling of the currently selected text. The available style options are listed in the edit menu and only apply to the selection.
    /// The default value of this property is false.
    /// - Parameter value: a new Boolean value
    /// - Returns: self
    @discardableResult
    public func allowsEditingTextAttributes(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.allowsEditingTextAttributes),value())
		}, forKey: #function)
    }
    
    /// The styled text that the text view displays.
    ///
    ///See: UITextView.attributedText.
    ///Assigning a new value to this property also replaces the value of the text property with the same string data, albeit without any formatting information. In addition, the font, textColor, and textAlignment properties are updated to reflect the typing attributes of the text view.
    /// - Parameter value: a new NSAttributedString value.
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value: @escaping @autoclosure () -> NSAttributedString) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.attributedText),value())
		}, forKey: #function)
    }
    
    /// A Boolean value that indicates whether inserting text replaces the previous contents.
    ///
    ///The default value of this property is false. When the value of this property is true and the text view is in editing mode, the selection UI is hidden and inserting new text clears the contents of the text view and sets the value of this property back to false.
    /// - Parameter value:a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func clearsOnInsertion(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.clearsOnInsertion),value())
		}, forKey: #function)
    }
    
    /// A Boolean value that determines the rendering scale of the text.
    ///
    /// See: UITextView.usesStandardTextScaling
    /// When the value of this property is true, UIKit automatically adjusts the rendering of the text in the text view to match the standard text scaling.
    /// When using the standard text scaling, font sizes in the text view appear visually similar to how they would render in macOS and non-Apple platforms, and copying the contents of the text view to the pasteboard preserves the original font point sizes. This effectively changes the display size of the text without changing the actual font point size. For example, text using a 13-point font in iOS looks like text using a 13-point font in macOS.
    /// If your app is built with Mac Catalyst, or if your text view’s contents save to a document that a user can view in macOS or other platforms, set this property to true.
    /// The default value of this property is false.
    /// - Parameter value:a new Boolean value.
    /// - Returns: self
    @available(iOS 13.0, *)
    @discardableResult
    public func usesStandardTextScaling(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UITextView.usesStandardTextScaling),value())
		}, forKey: #function)
    }
}
