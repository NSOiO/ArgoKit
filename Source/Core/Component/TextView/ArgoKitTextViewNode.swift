//
//  ArgoKitTextViewNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/13.
//

import Foundation

class ArgoKitTextViewNode: ArgoKitScrollViewNode {
    
    var textContainer: NSTextContainer?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let textView = UITextView(frame: frame, textContainer: textContainer)
        textView.delegate = self
        return textView
    }
}

extension ArgoKitTextViewNode: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let sel = #selector(self.textViewShouldBeginEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textView]) as? Bool ?? true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let sel = #selector(self.textViewShouldEndEditing(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textView]) as? Bool ?? true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        let sel = #selector(self.textViewDidBeginEditing(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textView])
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let sel = #selector(self.textViewDidEndEditing(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textView])
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let sel = #selector(self.textView(_:shouldChangeTextIn:replacementText:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [textView, range, text]) as? Bool ?? true
    }

    func textViewDidChange(_ textView: UITextView) {
        let sel = #selector(self.textViewDidChange(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textView])
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let sel = #selector(self.textViewDidChangeSelection(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [textView])
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let sel = #selector(self.textView(_:shouldInteractWith:in:interaction:) as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
        return self.sendAction(withObj: String(_sel: sel), paramter: [textView, URL, characterRange, interaction]) as? Bool ?? true
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let sel = #selector(self.textView(_ :shouldInteractWith:in:interaction:) as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)
        return self.sendAction(withObj: String(_sel: sel), paramter: [textView, textAttachment, characterRange, interaction]) as? Bool ?? true
    }
}
