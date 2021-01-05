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
    var pNode : ArgoKitTextFieldNode
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
    public init(text: @escaping @autoclosure () -> String? = nil, placeholder: @escaping @autoclosure () -> String? = nil) {
        pNode = ArgoKitTextFieldNode(viewClass:UITextField.self)
        self.text(text())
        self.placeholder(placeholder())
    }
}

extension TextField {
    
    /// The default attributes to apply to the text.
    ///
    /// By default, this property returns a dictionary of text attributes with default values.
    /// Setting this property applies the specified attributes to the entire text of the text field. Unset attributes maintain their default values.
    /// Getting this property returns the previously set attributes, which may have been modified by setting properties such as font and textColor.
    /// - Parameter value: a new value
    /// - Returns: self
    @discardableResult
    public func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextField.defaultTextAttributes),value)
        return self
    }
    
    /// The text field’s delegate.
    ///
    /// A text field delegate responds to editing-related messages from the text field. You can use the delegate to respond to the text entered by the user and to some special commands, such as when the user taps Return.
    /// - Parameter value: a new delegate
    /// - Returns: self
    @discardableResult
    public func delegate(_ value: UITextFieldDelegate?) -> Self {
        addAttribute(#selector(setter:UITextField.delegate),value)
        return self
    }
    
    /// The attributes to apply to new text that the user enters.
    ///
    /// This dictionary contains the attribute keys (and corresponding values) to apply to newly typed text. When the text field’s selection changes, the contents of the dictionary are cleared automatically.
    ///
    /// If the text field is not in editing mode, this property contains the value nil. Similarly, you cannot assign a value to this property unless the text field is currently in editing mode.
    /// - Parameter value: a new attributes
    /// - Returns: self
    @discardableResult
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        addAttribute(#selector(setter:UITextField.typingAttributes),value)
        return self
    }
    
    /// The custom left view for the overlay view that displays on the left (or leading) side of the text field.
    ///
    /// You can use the left overlay view to indicate the intended behavior of the text field. For example, you might display a magnifying glass in this location to indicate that the text field is a search field. The left overlay view flips automatically in a right-to-left user interface.
    ///
    /// The default value of this property is nil.
    /// - Parameter content: a new left View
    /// - Returns:Self
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

            node.width(point: width)
            node.height(point: height)
            
            addAttribute(#selector(setter:ArgoKitTextField.leftPadding),width)
            pNode.addChildNode(node)
        }
        return self
    }
    
    /// The custom right view for the overlay view that displays on the right (or trailing) side of the text field.
    ///
    /// You can use the right overlay view to provide indicate additional features available for the text field.
    ///
    /// The default value of this property is nil.
    /// - Parameter content: a new left View
    /// - Returns:Self
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

            
            node.width(point: width)
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
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
    /// - Returns: self
    ///
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
