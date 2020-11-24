//
//  ArgoKitTextFieldNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/16.
//

import Foundation
class ArgoKitTextField: UITextField {
    @objc var leftPadding:CGFloat = 1
    @objc var rightPadding:CGFloat = 1
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x+leftPadding, y: bounds.origin.y, width: bounds.size.width-leftPadding-rightPadding, height: bounds.size.height)
        return inset
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x+leftPadding, y: bounds.origin.y, width: bounds.size.width-leftPadding-rightPadding, height: bounds.size.height)
        return inset
    }
}
class ArgoKitTextFieldNode: ArgoKitNode, UITextFieldDelegate {
    var placeholder:String?
    var placeholderColor:UIColor?
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let textView = ArgoKitTextField(frame: frame)
        textView.delegate = self
        return textView
    }
    
    override func prepareForUse() {
        if let view = self.view as? ArgoKitTextField {
            view.rightViewMode = .never
            view.rightView = nil
        }
    }
    
    func updateAttributePlaceholder() {
        if let pholder = placeholder{
            var attribute:[NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
            if let color = self.placeholderColor {
                attribute[NSAttributedString.Key.foregroundColor] = color
            }
            if let font = self.font() {
                attribute[NSAttributedString.Key.font] = font
            }
            if attribute.count > 0 {
                let placeholder = NSMutableAttributedString(string: pholder,attributes:attribute as [NSAttributedString.Key : Any])
                ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UITextField.attributedPlaceholder),placeholder)
            }
        }
    }
}

extension ArgoKitTextFieldNode {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldBeginEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textField]) as? Bool ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let sel = #selector(self.textFieldDidBeginEditing(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textField])
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldEndEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textField]) as? Bool ?? true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let sel = #selector(self.textFieldDidEndEditing(_:reason:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textField, reason])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sel = #selector(self.textField(_:shouldChangeCharactersIn:replacementString:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textField, range, string]) as? Bool ?? true
    }
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let sel = #selector(self.textFieldDidChangeSelection(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textField])
    }
        
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldClear(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textField]) as? Bool ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldReturn(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textField]) as? Bool ?? true
    }
}
