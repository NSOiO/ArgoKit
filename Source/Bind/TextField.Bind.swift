//
//  TextField.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension TextField {
    /// set the text that text field displays.
    /// - Parameter value: new string vaue.
    /// - Returns: self
    @discardableResult
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.text),value)
        return self
    }
    
    /// set the styled text that text field displays.
    /// - Parameter value: new styled text
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedText),value)
        return self
    }
    
    /// change the font of the text.
    /// - Parameter value: new font value.
    /// - Returns: self
    @discardableResult
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextField.font),value)
        return self
    }
    
    /// The styled string displays when thers is no other text in the text field.
    ///
    /// This property is nil by default. If set, the placeholder string is drawn using system-defined color and the remaining style information (except the text color) of the attributed string. Assigning a new value to this property also replaces the value of the placeholder property with the same string data, albeit without any formatting information. Assigning a new value to this property does not affect any other style-related properties of the text field.
    /// - Parameter value: a new styled string.
    /// - Returns: self
    @discardableResult
    public func attributedPlaceholder(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedPlaceholder),value)
        return self
    }
    
    /// The techinque for aligning the text
    ///
    /// This property applies to the both main text string and the placeholder string. The default value os this property is NSTextAlignment.Left.
    /// If you are using styled text, assigning a new value to this property causes the text alignment to be applied to the entire string int the attributedText peoperty. If you want to apply the alignment to only a portion of the text, create a new attributed string with the desired style infomation and associate it with the text field.
    /// - Parameter value:a new
    /// - Returns: self
    ///
    /// ```
    ///    public enum NSTextAlignment : Int {
    ///
    ///        case left = 0 // Visually left aligned
    ///
    ///
    ///        case center = 1 // Visually centered
    ///
    ///        case right = 2 // Visually right aligned
    ///
    ///        /* !TARGET_ABI_USES_IOS_VALUES */
    ///        // Visually right aligned
    ///        // Visually centered
    ///
    ///        case justified = 3 // Fully-justified. The last line in a paragraph is natural-aligned.
    ///
    ///        case natural = 4 // Indicates the default alignment for script
    ///    }
    /// ```
    @discardableResult
    public func textAlign(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextField.textAlignment),value.rawValue)
        return self
    }
    
    /// The border style of the text.
    ///
    /// The default value for this property is UITextField.BorderStyle.none. If the value is set to the UITextField.BorderStyle.roundeRect style, the custom background image associated with the text field is ignored.
    /// - Parameter value: a new border style
    /// - Returns:Self
    ///
    ///```
    /// public enum BorderStyle : Int {
    ///
    ///    case none = 0
    ///
    ///    case line = 1
    ///
    ///    case bezel = 2
    ///
    ///   case roundedRect = 3
    ///}
    ///```
    ///
    @discardableResult
    public func borderStyle(_ value: UITextField.BorderStyle) -> Self {
        addAttribute(#selector(setter:UITextField.borderStyle),value)
        return self
    }
    
    /// A Boolean value that determines whether the text field removes old text when editing begins.
    ///
    /// If this property is set to true, the text field’s previous text is cleared when the user selects the text field to begin editing. If false, the text field places an insertion point at the place where the user tapped the field.
    ///
    /// **Note**
    ///
    ///Even if this property is set to true, the text field delegate can override this behavior by returning false from its textFieldShouldClear(_:) method.
    /// - Parameter value: a new Boolean value
    /// - Returns: self
    @discardableResult
    public func clearsOnBeginEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnBeginEditing),value)
        return self
    }
    
    /// A Boolean value that indicates whether to reduce the font size to fit the text string into the text field’s bounding rectangle.
    ///
    ///Normally, the text field’s content is drawn with the font you specify in the font property. If this property is set to true, however, and the contents in the text property exceed the text field’s bounding rectangle, the receiver starts reducing the font size until the string fits or the minimum font size is reached. The text is shrunk along the baseline.
    ///
    /// The default value for this property is false. If you change it to true, you should also set an appropriate minimum font size by modifying the minimumFontSize property.
    /// - Parameter value: a new Boolean value
    /// - Returns: self
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    /// The size of the smallest permissible font when drawing the text field’s text.
    ///
    ///When drawing text that might not fit within the bounding rectangle of the text field, you can use this property to prevent the receiver from reducing the font size to the point where it is no longer legible.
    ///
    ///The default value for this property is 0.0. If you enable font adjustment for the text field, you should always increase this value.
    ///
    ///If you are using styled text in iOS 6 or later, assigning a new value to this property causes the minimum font size to be applied to the entirety of the string in the attributedText property. If you want to apply different minimum font sizes to different parts of your string, create a new attributed string with the desired style information and associate it with the text field.
    /// - Parameter value: a new size
    /// - Returns: self
    @discardableResult
    public func minimumFontSize(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITextField.minimumFontSize),value)
        return self
    }
    
    /// The image that represents the background appearance of the text field when it is in an enabled state.
    ///
    /// When set, the image referred to by this property replaces the standard appearance controlled by the borderStyle property. Background images are drawn in the border rectangle portion of the text field. Images you use for the text field’s background should be able to stretch to fit.
    ///
    /// This property is set to nil by default.
    /// - Parameter value: a new background
    /// - Returns: self
    @discardableResult
    public func background(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.background),value)
        return self
    }
    
    /// The image that represents the background appearance of the text field when it is in a disabled state.
    ///
    /// Background images are drawn in the border rectangle portion of the text field. Images you use for the text field’s background should be able to stretch to fit. This property is ignored if the background property is not also set.
    ///
    /// This property is set to nil by default.
    /// - Parameter value: a new image or nil
    /// - Returns: self
    @discardableResult
    public func disabledBackground(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.disabledBackground),value)
        return self
    }
    
    /// A Boolean value that determines whether the user can edit the attributes of the text in the text field.
    ///
    /// If this property is set to true, the user may edit the style information of the text. In addition, pasting styled text into the text field retains any embedded style information. If false, the text field prohibits the editing of style information and strips style information from any pasted text. However, you can still set the style information programmatically using the methods of this class.
    ///
    /// The default value of this property is false
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.allowsEditingTextAttributes),value)
        return self
    }
    
    /// A mode that controls when the standard Clear button appears in the text field.
    ///
    /// The standard clear button is displayed at the right side of the text field, when the text field has contents, as a way for the user to remove text quickly. This button appears automatically based on the value set for this property.
    ///
    /// The default value for this property is UITextField.ViewMode.never.
    /// - Parameter value: a new view mode
    /// - Returns: self
    ///
    /// ```
    ///public enum ViewMode : Int {
    ///
    ///    case never = 0
    ///
    ///    case whileEditing = 1
    ///
    ///    case unlessEditing = 2
    ///
    ///    case always = 3
    ///}
    /// ```
    @discardableResult
    public func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
        addAttribute(#selector(setter:UITextField.clearButtonMode),value)
        return self
    }
    
    /// A Boolean value that determines whether inserting text replaces the previous contents.
    ///
    /// The default value of this property is false. When the value of this property is true and the text field is in editing mode, the selection UI is hidden and inserting new text clears the contents of the text field and sets the value of this property back to false.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnInsertion),value)
        return self
    }
}
