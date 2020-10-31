//
//  TextField.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct TextField : View {
    
    private var textField : UITextField
    private var pNode : ArgoKitNode
    
    public var body: View {
        self
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
        textField = UITextField()
        pNode = ArgoKitNode(view: textField)
        textField.text = text;
    }
}

extension TextField {
    
    public func text(_ value: String?) -> Self {
        textField.text = value
        return self
    }
    
    public func attributedText(_ value: NSAttributedString?) -> Self {
        textField.attributedText = value
        return self
    }
    
    public func textColor(_ value: UIColor?) -> Self {
        textField.textColor = value
        return self
    }
    
    public func font(_ value: UIFont?) -> Self {
        textField.font = value
        return self
    }
    
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        textField.textAlignment = value
        return self
    }
    
    public func borderStyle(_ value: UITextField.BorderStyle) -> Self {
        textField.borderStyle = value
        return self
    }
    
    public func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        textField.defaultTextAttributes = value
        return self
    }
    
    public func placeholder(_ value: String?) -> Self {
        textField.placeholder = value
        return self
    }
    
    public func attributedPlaceholder(_ value: NSAttributedString?) -> Self {
        textField.attributedPlaceholder = value
        return self
    }
    
    public func clearsOnBeginEditing(_ value: Bool) -> Self {
        textField.clearsOnBeginEditing = value
        return self
    }
    
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        textField.adjustsFontSizeToFitWidth = value
        return self
    }
    
    public func minimumFontSize(_ value: CGFloat) -> Self {
        textField.minimumFontSize = value
        return self
    }
    
    public func delegate(_ value: UITextFieldDelegate?) -> Self {
        textField.delegate = value
        return self
    }
    
    public func background(_ value: UIImage?) -> Self {
        textField.background = value
        return self
    }
    
    public func disabledBackground(_ value: UIImage?) -> Self {
        textField.disabledBackground = value
        return self
    }
    
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        textField.allowsEditingTextAttributes = value
        return self
    }
    
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        textField.typingAttributes = value
        return self
    }
    
    public func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
        textField.clearButtonMode = value
        return self
    }
    
    public func leftView(_ value: UIView?) -> Self {
        textField.leftView = value
        return self
    }
    
    public func leftViewMode(_ value: UITextField.ViewMode) -> Self {
        textField.leftViewMode = value
        return self
    }
    
    public func rightView(_ value: UIView?) -> Self {
        textField.rightView = value
        return self
    }
    
    public func rightViewMode(_ value: UITextField.ViewMode) -> Self {
        textField.rightViewMode = value
        return self
    }
    
    public func inputView(_ value: UIView?) -> Self {
        textField.inputView = value
        return self
    }
    
    public func inputAccessoryView(_ value: UIView?) -> Self {
        textField.inputAccessoryView = value
        return self
    }
    
    public func clearsOnInsertion(_ value: Bool) -> Self {
        textField.clearsOnInsertion = value
        return self
    }
}
