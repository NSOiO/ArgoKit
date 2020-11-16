//
//  ArgoKitTextFieldNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/16.
//

import Foundation

class ArgoKitTextFieldNode: ArgoKitNode {
        
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let textView = UITextField(frame: frame)
        textView.delegate = self
        return textView
    }
}

extension ArgoKitTextFieldNode: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldBeginEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? Bool ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let sel = #selector(self.textFieldDidBeginEditing(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: nil)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldEndEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? Bool ?? true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let sel = #selector(self.textFieldDidEndEditing(_:reason:))
        self.sendAction(withObj: String(_sel: sel), paramter: [reason])
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sel = #selector(self.textField(_:shouldChangeCharactersIn:replacementString:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [range, string]) as? Bool ?? true
    }
    
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let sel = #selector(self.textFieldDidChangeSelection(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: nil)
    }
        
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldClear(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? Bool ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let sel = #selector(self.textFieldShouldReturn(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? Bool ?? true
    }
}
