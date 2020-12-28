//
//  TextView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

/// A scrollable, multiline text region.
/// Wrapper of UITextView
///
///UITextView supports the display of text using custom style information and also supports text editing. You typically use a text view to display multiple lines of text, such as when displaying the body of a large text document.
///This class supports multiple text styles through use of the attributedText property. (Styled text is not supported in versions of iOS earlier than iOS 6.) Setting a value for this property causes the text view to use the style information provided in the attributed string. You can still use the font, textColor, and textAlignment properties to set style attributes, but those properties apply to all of the text in the text view. It’s recommended that you use a text view—and not a UIWebView object—to display both plain and rich text in your app.
///```
///TextView(text: "Hello, World!")
///     .height(100)
///     .font(size: 20)
///     .font(style: .bold)
///     .margin(edge: .top, value: 96)
///     .backgroundColor(.yellow)
///     .cornerRadius(10)
///     .didEndEditing { text in
///         print("\(String(describing: text))")
///     }
///     .shouldEndEditing { text -> Bool in
///         print("\(String(describing: text))")
///         return true
///     }
///     .didChangeText { text in
///         print("\(String(describing: text))")
///     }.gesture(gesture: getstur)
///     .onTapGesture {
///         print("on tap")
///     }.onLongPressGesture(numberOfTaps: 1, numberOfTouches: 3) {
///         print("on long press")
///     }
///```
public class TextView : ScrollView {
    private var fontSize:CGFloat = UIFont.systemFontSize
    private var fontStyle:AKFontStyle = .default
    private var font:UIFont
    private var fontName:String?
    private var textViewNode: ArgoKitTextViewNode {
        pNode as! ArgoKitTextViewNode
    }
    
    /// initialize the TextView
    required convenience init() {
        self.init(text:nil)
    }
    
    /// Create a new TextView with specified text string.
    /// - Parameter text: a string value.
    public init(text: String?) {
        font = UIFont.systemFont(ofSize:fontSize)
        super.init()
        if text != nil {
            addAttribute(#selector(setter:UITextView.text),text)
        }
    }
    
    
    /// Create a new TextView with specified text container.
    /// - Parameter textContainer: a new text container.
    public init(textContainer:()->NSTextContainer?) {
        font = UIFont.systemFont(ofSize:fontSize)
        super.init()
        textViewNode.textContainer = textContainer()
    }
    
    override func createNode() {
        pNode = ArgoKitTextViewNode(viewClass: UITextView.self)
    }
}

extension TextView {
    /// The text that the text view displays.
    /// In iOS6 and later, assigning a new value to this property also replaces the value of the attributedText property with the same text, albeit without any inherent style attributes. Instead the text view styles the new string using the font, textColor, and other style-related properties of the class.
    /// - Parameter value: a new string value.
    /// - Returns: self
    @discardableResult
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextView.text),value)
        return self
    }
    
    /// The font of the text
    ///
    /// This property applies to the entire text string. The default value of this property is the body style of the system font.
    /// - Parameter value: a new font value
    /// - Returns: self
    @discardableResult
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextView.font),value)
        return self
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
    public func font(name: String?, style:AKFontStyle,size:CGFloat)->Self{
        textViewNode.fontName = name
        textViewNode.fontStyle = style
        textViewNode.fontSize = size
        let font = UIFont.font(fontName: name, fontStyle: style, fontSize: size)
        return self.font(font)
    }
    
    /// Change the font name of the text.
    /// - Parameter value: a new font name.
    /// - Returns: self
    @discardableResult
    public func font(name value:String?)->Self{
        textViewNode.fontName = value
        let font = UIFont.font(fontName: value, fontStyle: textViewNode.fontStyle, fontSize: textViewNode.fontSize)
        return self.font(font)
    }
    
    /// Change the font size of the text.
    /// - Parameter value: a new font size.
    /// - Returns: self
    @discardableResult
    public  func font(size value:CGFloat)->Self{
        textViewNode.fontSize = value
        let font = UIFont.font(fontName: textViewNode.fontName, fontStyle:  textViewNode.fontStyle, fontSize: value)
        return self.font(font)
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
    public func font(style value:AKFontStyle)->Self{
        textViewNode.fontStyle = value
        let font = UIFont.font(fontName: textViewNode.fontName, fontStyle: value, fontSize: textViewNode.fontSize)
        return self.font(font)
    }
    
    /// The color of the text.
    ///
    /// This property applies to the entire text string. The default text color is black.
    /// In iOS 6 and later, assigning a new value to this property causes the new text color to be applied to the entire contents of the text view. If you want to apply the color to only a portion of the text, you must create a new attributed string with the desired style information and assign it to the attributedText property.
    /// - Parameter value: a new color
    /// - Returns: self
    @discardableResult
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self
    }
    
    /// Change the color the text, the color is created by the rgba value.
    /// - Parameters:
    ///   - r: the red value of the color object, data range from 0 to 255.
    ///   - g: the green value of the color object, data range from 0 to 255.
    ///   - b: the blue value of the color object, data range from 0 to 255.
    ///   - a: the opacity value of the color object, data range from 0 to 1.
    /// - Returns: description
    @discardableResult
    public func textColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self;
    }
    
    /// Change the color of the text, the color is created by the hex and alpha.
    /// - Parameters:
    ///   - hex: hex number
    ///   - a: alpha value
    /// - Returns: self
    @discardableResult
    public func textColor(hex:Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self;
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
    public func textAlign(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextView.textAlignment),value.rawValue)
        return self
    }
    
    /// The current selection range of the text view. See: UITextView.selectedRange
    ///
    /// In iOS 2.2 and earlier, the length of the selection range is always 0, indicating that the selection is actually an insertion point. In iOS 3.0 and later, the length of the selection range may be non-zero.
    /// - Parameter value: a range value
    /// - Returns: self
    @discardableResult
    public func selectedRange(_ value: NSRange) -> Self {
        addAttribute(#selector(setter:UITextView.selectedRange),value)
        return self
    }
    
    /// A Boolean value that indicates whether the text view is editable.
    ///
    /// See: UITextView.isEditable
    /// The default value of this property is true.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func isEditable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isEditable),value)
        return self
    }
    
    /// A Boolean value that indicates whether the text view is selectable.
    ///
    /// See: UITextView.isSelectable
    /// This property controls the ability of the user to select content and interact with URLs and text attachments. The default value is true.
    /// - Parameter value: a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func isSelectable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isSelectable),value)
        return self
    }
    
    /// The types of data that convert to tappable URLs in the text view.
    ///
    /// See: UITextView.dataDetectorTypes
    /// You can use this property to specify the types of data (phone numbers, http links, and so on) that should be automatically converted to URLs in the text view. When tapped, the text view opens the application responsible for handling the URL type and passes it the URL. Note that data detection does not occur if the text view's isEditable property is set to true.
    /// - Parameter value: a new UIDataDetectorTypes value.
    /// - Returns: self
    @discardableResult
    public func dataDetectorTypes(detectorType value: ()->UIDataDetectorTypes) -> Self {
        addAttribute(#selector(setter:UITextView.dataDetectorTypes),value())
        return self
    }
    
    /// A Boolean value that indicates whether the text view allows the user to edit style information.
    ///
    ///See: UITextView.allowsEditingTextAttributes
    /// When set to true, the text view allows the user to change the basic styling of the currently selected text. The available style options are listed in the edit menu and only apply to the selection.
    /// The default value of this property is false.
    /// - Parameter value: a new Boolean value
    /// - Returns: self
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.allowsEditingTextAttributes),value)
        return self
    }
    
    /// The styled text that the text view displays.
    ///
    ///See: UITextView.attributedText.
    ///Assigning a new value to this property also replaces the value of the text property with the same string data, albeit without any formatting information. In addition, the font, textColor, and textAlignment properties are updated to reflect the typing attributes of the text view.
    /// - Parameter value: a new NSAttributedString value.
    /// - Returns: self
    @discardableResult
    public func attributedText(_ value: NSAttributedString!) -> Self {
        addAttribute(#selector(setter:UITextView.attributedText),value)
        return self
    }
    
    /// The attributes to apply to new text that the user enters.
    ///
    /// See: UITextView.typingAttributes
    /// This dictionary contains the attribute keys (and corresponding values) to apply to newly typed text. When the text view’s selection changes, the contents of the dictionary are cleared automatically.
    /// - Parameter value:new attributes
    /// - Returns: self
    @discardableResult
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextView.typingAttributes),value)
        return self
    }
    
    /// Scrolls the text view until the text in the specified range is visible.
    ///
    /// See: UITextView.scrollRangeToVisible
    /// - Parameter value: The range of text to scroll into view.
    /// - Returns: self
    @discardableResult
    public func scrollRangeToVisible(_ value: NSRange) -> Self {
        addAttribute(#selector(UITextView.scrollRangeToVisible),value)
        return self
    }
    
    /// The custom input view to display when the text view becomes the first responder.
    ///
    /// See: UITextView.inputView
    /// If the value in this property is nil, the text view displays the standard system keyboard when it becomes first responder. Assigning a custom view to this property causes that view to be presented instead.
    /// The default value of this property is nil.
    /// - Parameter content: the content of input view.
    /// - Returns: self
    @discardableResult
    public func inputView(_ content:()->View) -> Self {
        let inView = content()
        if let node = inView.node {
            let width = node.width()
            let height = node.height()
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            node.createNodeViewIfNeed(frame)
            addAttribute(#selector(setter:UITextView.inputView),node.view)
        }
        return self
    }
    
    /// The custom accessory view to display when the text view becomes the first responder.
    ///
    /// See: UITextView.inputAccessoryView
    ///The default value of this property is nil. Assigning a view to this property causes that view to be displayed above the standard system keyboard (or above the custom input view if one is provided) when the text view becomes the first responder. For example, you could use this property to attach a custom toolbar to the keyboard.
    /// - Parameter content: the content of inputAccessoryView.
    /// - Returns: self
    @discardableResult
    public func inputAccessoryView(_ content:()->View) -> Self {
        let inAcView = content()
        if let node = inAcView.node {
            let width = node.width()
            let height = node.height()
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            node.createNodeViewIfNeed(frame)
            addAttribute(#selector(setter:UITextView.inputAccessoryView),node.view)
        }
        return self
    }
    
    /// A Boolean value that indicates whether inserting text replaces the previous contents.
    ///
    ///The default value of this property is false. When the value of this property is true and the text view is in editing mode, the selection UI is hidden and inserting new text clears the contents of the text view and sets the value of this property back to false.
    /// - Parameter value:a new Boolean value.
    /// - Returns: self
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.clearsOnInsertion),value)
        return self
    }
    
    /// The inset of the text container's layout area within the text view's content area.
    ///
    /// See: UITextView.textContainerInset.
    /// This property provides text margins for text laid out in the text view. By default the value of this property is (8, 0, 8, 0).
    /// - Parameter value: new edge insets.
    /// - Returns: self
    @discardableResult
    public func textContainerInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITextView.textContainerInset),value)
        return self
    }
    
    /// The attributes to apply to links.
    ///
    /// See: UITextView.linkTextAttributes.
    /// The default attributes specify blue text with a single underline and the pointing hand cursor.
    /// - Parameter value: new attributes.
    /// - Returns: self
    @discardableResult
    public func linkTextAttributes(_ value: [NSAttributedString.Key : Any]!) -> Self {
        addAttribute(#selector(setter:UITextView.linkTextAttributes),value)
        return self
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
    public func usesStandardTextScaling(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.usesStandardTextScaling),value)
        return self
    }
}

extension TextView {
    
    /// set the callback of which return value determine whether to begin editing in the specified text view.
    /// - Parameter action: callback
    /// - Returns:Self
    @discardableResult
    public func shouldBeginEditing(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewShouldBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                return action(textView.text)
            }
            return nil
        })
        return self
    }
    /// Asks the callback whether to stop editing in the specified text view.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func shouldEndEditing(_ action: @escaping (_ text: String?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewShouldEndEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                return action(textView.text)
            }
            return nil
        })
        return self
    }
    /// Tells the callback when editing begins in the specified text view.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didBeginEditing(_ action: @escaping (_ text: String?) -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                action(textView.text)
            }
            return nil
        })
        return self
    }
    /// Tells the callback when editing stops for the specified text view, and the reason it stopped.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didEndEditing(_ action: @escaping (_ text: String?) -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidEndEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                action(textView.text)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether to change the text at the specified range.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func shouldChangeText(_ action: @escaping (_ text: String?, _ range: NSRange, _ replacementText: String) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textView(_:shouldChangeTextIn:replacementText:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let textView: UITextView = paramter![0] as! UITextView
                let range: NSRange = paramter![1] as! NSRange
                let replacementText: String = paramter![2] as! String
                return action(textView.text, range, replacementText)
            }
            return nil
        })
        return self
    }
    
    /// Tells the callback the text at the specified range had been changed.
    /// - Parameter action: callback
    /// - Returns:self
    @discardableResult
    public func didChangeText(_ action: @escaping (_ text: String?) -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidChange(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                action(textView.text)
            }
            return nil
        })
        return self
    }
    /// Tells the callback when the text selection changes in the specified text view.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didChangeSelection(_ action: @escaping (_ text: String?, _ selectedRange: NSRange) -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidChangeSelection(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let textView: UITextView = paramter![0] as! UITextView
                action(textView.text, textView.selectedRange)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether the specified text view allows user interaction with the specified URL in the specified range of text.
    ///
    /// See: UITextViewDelegate
    /// - Parameter action: callback
    /// - Returns: self
    @available(iOS 10.0, *)
    @discardableResult
    public func shouldInteractWithURL(_ action: @escaping (_ text: String?, _ URL: URL, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool) -> Self {
        let sel = #selector(textViewNode.textView(_:shouldInteractWith:in:interaction:) as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4 {
                let textView: UITextView = paramter![0] as! UITextView
                let URL: URL = paramter![1] as! URL
                let characterRange: NSRange = paramter![2] as! NSRange
                let interaction: UITextItemInteraction = paramter![3] as! UITextItemInteraction
                return action(textView.text, URL, characterRange, interaction)
            }
            return nil
        })
        return self
    }
    
    /// Asks the callback whether the specified text view allows user interaction with the provided text attachment in the specified range of text.
    ///
    /// See: UITextViewDelegate
    /// - Parameter action: callback
    /// - Returns: self
    @available(iOS 10.0, *)
    @discardableResult
    public func shouldInteractWithTextAttachment(_ action: @escaping (_ text: String?, _ textAttachment: NSTextAttachment, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool) -> Self {
        let sel = #selector(textViewNode.textView(_:shouldInteractWith:in:interaction:) as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool);
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4 {
                let textView: UITextView = paramter![0] as! UITextView
                let textAttachment: NSTextAttachment = paramter![1] as! NSTextAttachment
                let characterRange: NSRange = paramter![2] as! NSRange
                let interaction: UITextItemInteraction = paramter![3] as! UITextItemInteraction
                return action(textView.text, textAttachment, characterRange, interaction)
            }
            return nil
        })
        return self
    }

}
