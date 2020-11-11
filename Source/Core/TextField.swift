//
//  TextField.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct TextField : View {
    
    private var pNode : ArgoKitNode
    
    public var body: View {
        ViewEmpty()
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init() {
        self.init(nil)
    }
    
    public init(_ text: String?) {
        pNode = ArgoKitNode(viewClass:UITextField.self)
        addAttribute(#selector(setter:UITextField.text),text)
    }
}

extension TextField {
    
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.text),value)
        return self
    }
    
    public func attributedText(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedText),value)
        return self
    }
    
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextField.textColor),value)
        return self
    }
    
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextField.font),value)
        return self
    }
    
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextField.textAlignment),value)
        return self
    }
    
    public func borderStyle(_ value: UITextField.BorderStyle) -> Self {
        addAttribute(#selector(setter:UITextField.borderStyle),value)
        return self
    }
    
    public func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextField.defaultTextAttributes),value)
        return self
    }
    
    public func placeholder(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.placeholder),value)
        return self
    }
    
    public func attributedPlaceholder(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedPlaceholder),value)
        return self
    }
    
    public func clearsOnBeginEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnBeginEditing),value)
        return self
    }
    
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    public func minimumFontSize(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITextField.minimumFontSize),value)
        return self
    }
    
    public func delegate(_ value: UITextFieldDelegate?) -> Self {
        addAttribute(#selector(setter:UITextField.delegate),value)
        return self
    }
    
    public func background(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.background),value)
        return self
    }
    
    public func disabledBackground(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.disabledBackground),value)
        return self
    }
    
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.allowsEditingTextAttributes),value)
        return self
    }
    
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        addAttribute(#selector(setter:UITextField.typingAttributes),value)
        return self
    }
    
    public func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
        addAttribute(#selector(setter:UITextField.clearButtonMode),value)
        return self
    }
    
    public func leftView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextField.leftView),value)
        return self
    }
    
    public func leftViewMode(_ value: UITextField.ViewMode) -> Self {
        addAttribute(#selector(setter:UITextField.leftViewMode),value)
        return self
    }
    
    public func rightView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextField.rightView),value)
        return self
    }
    
    public func rightViewMode(_ value: UITextField.ViewMode) -> Self {
        addAttribute(#selector(setter:UITextField.rightViewMode),value)
        return self
    }
    
    public func inputView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextField.inputView),value)
        return self
    }
    
    public func inputAccessoryView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextField.inputAccessoryView),value)
        return self
    }
    
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnInsertion),value)
        return self
    }
}
