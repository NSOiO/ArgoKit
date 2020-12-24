//
//  TextField.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

/// An object that displays an editable text area in your interface.
/// Wrapper of UITextField.
public struct TextField : View {
    private var pNode : ArgoKitTextFieldNode
    /// the node behind the TextField
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// initialize the empty textfiled.
    public init() {
        self.init(text:nil)
    }
    /// initialize the text field with specified string and placeholder string.
    /// - Parameters:
    ///   - text: string or nil
    ///   - placeholder: string for placeholder or nil
    public init(text: String? = nil, placeholder: String? = nil) {
        pNode = ArgoKitTextFieldNode(viewClass:UITextField.self)
        pNode.placeholder = placeholder
        addAttribute(#selector(setter:UITextField.text),text)
        addAttribute(#selector(setter:UITextField.placeholder),placeholder)
    }
}

extension TextField {
    /// set the text that text field displays.
    /// - Parameter value: new string vaue.
    /// - Returns: Self
    @discardableResult
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.text),value)
        return self
    }
    
    /// set the styled text that text field displays.
    /// - Parameter value: new styled text
    /// - Returns: Self
    @discardableResult
    public func attributedText(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedText),value)
        return self
    }
    /// change the color of the text
    /// - Parameter value: the new color
    /// - Returns: Self
    @discardableResult
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextField.textColor),value)
        pNode.updateAttributePlaceholder()
        return self
    }
    
    /// change the font of the text.
    /// - Parameter value: new font value.
    /// - Returns: Self
    @discardableResult
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextField.font),value)
        return self
    }
    
    /// Set the font of the receiver's text.
    /// - Parameters:
    ///   - name: font name
    ///   - style: font style
    ///   - size: font size
    /// - Returns: Self
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
        pNode.fontStyle = style
        pNode.fontSize = size
        let font = UIFont.font(fontName: name, fontStyle: style, fontSize: size)
        return self.font(font)
    }
    
    /// change the font name of the receiver's text
    /// - Parameter value: font name
    /// - Returns: Self
    @discardableResult
    public func font(name value:String?)->Self{
        pNode.fontName = value
        let font = UIFont.font(fontName: value, fontStyle: pNode.fontStyle, fontSize: pNode.fontSize)
        return self.font(font)
    }
    /// change the font size of the receiver's text
    /// - Parameter value: font size
    /// - Returns: Self
    @discardableResult
    public  func font(size value:CGFloat)->Self{
        pNode.fontSize = value
        let font = UIFont.font(fontName: pNode.fontName, fontStyle:  pNode.fontStyle, fontSize: value)
        return self.font(font)
    }
    /// change the font style of the receiver's text
    /// - Parameter value: font style
    /// - Returns:Self
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
        return self.font(font)
    }
    
    /// The string that displays when there is no other text in the text field.
    ///
    /// This value is nil by default. The placeholder string is drawn using a system-defined color.
    /// - Parameter value: new string value
    /// - Returns: Self
    @discardableResult
    public func placeholder(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.placeholder),value)
        pNode.placeholder = value
        return self
    }
    
    /// The color for the placeholder string
    /// - Parameter value: a new color
    /// - Returns: Self
    @discardableResult
    public func placeholderColor(_ value: UIColor?) -> Self {
        pNode.placeholderColor = value
        pNode.updateAttributePlaceholder()
        return self
    }
    
    /// The styled string displays when thers is no other text in the text field.
    ///
    /// This property is nil by default. If set, the placeholder string is drawn using system-defined color and the remaining style information (except the text color) of the attributed string. Assigning a new value to this property also replaces the value of the placeholder property with the same string data, albeit without any formatting information. Assigning a new value to this property does not affect any other style-related properties of the text field.
    /// - Parameter value: a new styled string.
    /// - Returns: Self
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
    /// - Returns: Self
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
    
    /// The default attributes to apply to the text.
    ///
    /// By default, this property returns a dictionary of text attributes with default values.
    /// Setting this property applies the specified attributes to the entire text of the text field. Unset attributes maintain their default values.
    /// Getting this property returns the previously set attributes, which may have been modified by setting properties such as font and textColor.
    /// - Parameter value: a new value
    /// - Returns: Self
    @discardableResult
    public func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextField.defaultTextAttributes),value)
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
    /// - Returns: Self
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
    /// - Returns: Self
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
    /// - Returns: Self
    @discardableResult
    public func minimumFontSize(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITextField.minimumFontSize),value)
        return self
    }
    
    /// The text field’s delegate.
    ///
    /// A text field delegate responds to editing-related messages from the text field. You can use the delegate to respond to the text entered by the user and to some special commands, such as when the user taps Return.
    /// - Parameter value: a new delegate
    /// - Returns: Self
    @discardableResult
    public func delegate(_ value: UITextFieldDelegate?) -> Self {
        addAttribute(#selector(setter:UITextField.delegate),value)
        return self
    }
    
    /// The image that represents the background appearance of the text field when it is in an enabled state.
    ///
    /// When set, the image referred to by this property replaces the standard appearance controlled by the borderStyle property. Background images are drawn in the border rectangle portion of the text field. Images you use for the text field’s background should be able to stretch to fit.
    ///
    /// This property is set to nil by default.
    /// - Parameter value: a new background
    /// - Returns: Self
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
    /// - Returns: Self
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
    /// - Returns: Self
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.allowsEditingTextAttributes),value)
        return self
    }
    
    /// The attributes to apply to new text that the user enters.
    ///
    /// This dictionary contains the attribute keys (and corresponding values) to apply to newly typed text. When the text field’s selection changes, the contents of the dictionary are cleared automatically.
    ///
    /// If the text field is not in editing mode, this property contains the value nil. Similarly, you cannot assign a value to this property unless the text field is currently in editing mode.
    /// - Parameter value: a new attributes
    /// - Returns: Self
    @discardableResult
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        addAttribute(#selector(setter:UITextField.typingAttributes),value)
        return self
    }
    
    /// A mode that controls when the standard Clear button appears in the text field.
    ///
    /// The standard clear button is displayed at the right side of the text field, when the text field has contents, as a way for the user to remove text quickly. This button appears automatically based on the value set for this property.
    ///
    /// The default value for this property is UITextField.ViewMode.never.
    /// - Parameter value: a new view mode
    /// - Returns: Self
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
    
    @discardableResult
    public func leftView(_ content:()->View) -> Self {
        let lfView = content()
        if let node = lfView.alignSelf(.start).node {
            
            let maxHeight = pNode.height()
            let maxWidth = pNode.width()
            let maxValue = CGFloat.minimum(maxHeight, maxWidth)
            
            var width = node.width()
            var height = node.height()
            
            if width == 0 {
                width = maxValue
            }
            
            if height == 0 {
                height = maxValue
            }

            
            node.width(point: height)
            node.height(point: height)
            
            addAttribute(#selector(setter:ArgoKitTextField.leftPadding),width)
            pNode.addChildNode(node)
        }
        return self
    }
    
    @discardableResult
    public func rightView(_ content:()->View) -> Self {
        let rtView = content()
        if let node = rtView.alignSelf(.end).node {
            
           
            let maxHeight = pNode.height()
            let maxWidth = pNode.width()
            let maxValue = CGFloat.minimum(maxHeight, maxWidth)
            
            var width = node.width()
            var height = node.height()
            
            if width == 0 {
                width = maxValue
            }
            
            if height == 0 {
                height = maxValue
            }

            
            node.width(point: height)
            node.height(point: height)
        
            node.positionAbsolute()
            node.left(point: (pNode.width()-width))
            addAttribute(#selector(setter:ArgoKitTextField.rightPadding),width)
            pNode.addChildNode(node)
        }
        return self
    }
    
    /// The custom input view to display when the text field becomes the first responder.
    ///
    /// If the value in this property is nil, the text field displays the standard system keyboard when it becomes first responder. Assigning a custom view to this property causes that view to be presented instead.
    ///
    /// The default value of this property is nil.
    /// - Parameter content: a new input View
    /// - Returns:Self
    @discardableResult
    public func inputView(_ content:()->View) -> Self {
        let inView = content()
        if let node = inView.node {
            let width = node.width()
            let height = node.height()
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            node.createNodeViewIfNeed(frame)
            addAttribute(#selector(setter:UITextField.inputView),node.view)
        }
        return self
    }
    
    /// The custom accessory view to display when the text field becomes the first responder.
    ///
    /// The default value of this property is nil. Assigning a view to this property causes that view to be displayed above the standard system keyboard (or above the custom input view if one is provided) when the text field becomes the first responder. For example, you could use this property to attach a custom toolbar to the keyboard.
    ///
    /// - Parameter content: a new view
    /// - Returns: Self
    @discardableResult
    public func inputAccessoryView(_ content:()->View) -> Self {
        let inAcView = content()
        if let node = inAcView.node {
            let width = node.width()
            let height = node.height()
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            node.createNodeViewIfNeed(frame)
            addAttribute(#selector(setter:UITextField.inputAccessoryView),node.view)
        }
        return self
    }
    
    /// A Boolean value that determines whether inserting text replaces the previous contents.
    ///
    /// The default value of this property is false. When the value of this property is true and the text field is in editing mode, the selection UI is hidden and inserting new text clears the contents of the text field and sets the value of this property back to false.
    /// - Parameter value: a new Boolean value.
    /// - Returns: Self
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnInsertion),value)
        return self
    }
}

extension TextField {
    
    /// set the callback of which return value determine whether to begin editing in the specified text field.
    /// - Parameter action: callback
    /// - Returns:Self
    @discardableResult
    public func shouldBeginEditing(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldShouldBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                return action(textField.text)
            }
            return nil
        })
        return self
    }
    
    /// Tells the callback when editing begins in the specified text field.
    /// - Parameter action: callback
    /// - Returns: Self
    @discardableResult
    public func didBeginEditing(_ action: @escaping (_ text: String?) -> Void) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldDidBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                action(textField.text)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether to stop editing in the specified text field.
    /// - Parameter action: callback
    /// - Returns: Self
    @discardableResult
    public func shouldEndEditing(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldShouldEndEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                return action(textField.text)
            }
            return nil
        })
        return self
    }
    
    /// Tells the callback when editing stops for the specified text field, and the reason it stopped.
    /// - Parameter action: callback
    /// - Returns: Self
    @available(iOS 10.0, *)
    @discardableResult
    public func didEndEditing(_ action: @escaping (_ text: String?, _ reason: UITextField.DidEndEditingReason) -> Void) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldDidEndEditing(_:reason:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let textField: UITextField = paramter![0] as! UITextField
                let reason: UITextField.DidEndEditingReason = paramter![1] as! UITextField.DidEndEditingReason
                action(textField.text, reason)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether to change characters.
    /// - Parameter action: callback
    /// - Returns: Self
    @discardableResult
    public func shouldChangeCharacters(_ action: @escaping (_ text: String?, _ range: NSRange, _ replacementString: String) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textField(_:shouldChangeCharactersIn:replacementString:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let textField: UITextField = paramter![0] as! UITextField
                let range: NSRange = paramter![1] as! NSRange
                let replacementString: String = paramter![2] as! String
                return action(textField.text, range, replacementString)
            }
            return nil
        })
        return self
    }
    
    /// Tells the callback when the text selection changes in the specified text field.
    /// - Parameter action: callback
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func didChangeSelection(_ action: @escaping (_ text: String?) -> Void) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldDidChangeSelection(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                action(textField.text)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether to remove the text field’s current contents.
    /// - Parameter action: callback
    /// - Returns: Self
    @discardableResult
    public func shouldClear(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldShouldClear(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                return action(textField.text)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether to process the pressing of the Return button for the text field.
    /// - Parameter action: callback
    /// - Returns: Self
    @discardableResult
    public func shouldReturn(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextFieldNode.textFieldShouldReturn(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textField: UITextField = paramter![0] as! UITextField
                return action(textField.text)
            }
            return nil
        })
        return self
    }
}



extension TextField{
    
    /// sets the padding aera on all four sides of an element.
    /// - Parameters:
    ///   - top: top side value
    ///   - right: right side value
    ///   - bottom: bottom side value
    ///   - left: left side value
    /// - Returns: Self
    @discardableResult
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    
    /// sets the padding aera on the sides from edge.
    /// - Parameters:
    ///   - edge: a ArgoEdge value.
    ///   - value: a ArgoValue value.
    /// - Returns: Self
    ///```
    ///public enum ArgoEdge{
    ///    case left
    ///    case top
    ///    case right
    ///    case bottom
    ///    case start
    ///    case end
    ///    case horizontal
    ///    case vertical
    ///    case all
    ///}
    ///
    ///public enum ArgoValue {
    ///    case undefined
    ///    case auto
    ///    case point(CGFloat)
    ///    case percent(CGFloat)
    ///}
    ///```
    
    @discardableResult
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value {
            case .point(let value):
                addAttribute(#selector(setter:ArgoKitTextField.leftPadding),value)
                break
            default:
                break
            }
            break
        case .top:
            switch value {
            case .point(let value):
                addAttribute(#selector(setter:ArgoKitTextField.topPadding),value)
                break
            default:
                break
            }
            break
        case .right:
            switch value {
            case .point(let value):
                addAttribute(#selector(setter:ArgoKitTextField.rightPadding),value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value {
            case .point(let value):
                addAttribute(#selector(setter:ArgoKitTextField.bottomPadding),value)
                break
            default:
                break
            }
            break
       
        default:
            break
        }
        return self;
    }
    
}
