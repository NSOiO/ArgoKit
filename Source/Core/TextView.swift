//
//  TextView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public class TextView : ScrollView {
    
    private var pNode : ArgoKitNode
    
    public var scrollView: UIScrollView? {
        type.viewNode()?.view as? UITextView
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public convenience init() {
        self.init(nil)
    }
    
    public init(_ text: String?) {
        pNode = ArgoKitNode(viewClass: UITextView.self)
        addAttribute(#selector(setter:UITextView.text),text)
    }
    
    public init(textContainer: NSTextContainer?) {
        pNode = ArgoKitNode(viewClass:  UITextView.self)
    }
}

extension TextView {

    public func delegate(_ value: UITextViewDelegate?) -> Self {
        addAttribute(#selector(setter:UITextView.delegate),value)
        return self
    }
    
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextView.text),value)
        return self
    }
    
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextView.font),value)
        return self
    }
    
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self
    }
    
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextView.textAlignment),value)
        return self
    }
    
    public func selectedRange(_ value: NSRange) -> Self {
        addAttribute(#selector(setter:UITextView.selectedRange),value)
        return self
    }
    
    public func isEditable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isEditable),value)
        return self
    }
    
    public func isSelectable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isSelectable),value)
        return self
    }
    
    public func dataDetectorTypes(_ value: UIDataDetectorTypes) -> Self {
        addAttribute(#selector(setter:UITextView.dataDetectorTypes),value)
        return self
    }
    
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.allowsEditingTextAttributes),value)
        return self
    }
    
    public func attributedText(_ value: NSAttributedString!) -> Self {
        addAttribute(#selector(setter:UITextView.attributedText),value)
        return self
    }
    
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextView.typingAttributes),value)
        return self
    }
    
    public func scrollRangeToVisible(_ value: NSRange) -> Self {
        addAttribute(#selector(UITextView.scrollRangeToVisible),value)
        return self
    }
    
    public func inputView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextView.inputView),value)
        return self
    }
    
    public func inputAccessoryView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITextView.inputAccessoryView),value)
        return self
    }
    
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.clearsOnInsertion),value)
        return self
    }
    
    public func textContainerInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITextView.textContainerInset),value)
        return self
    }
    
    public func linkTextAttributes(_ value: [NSAttributedString.Key : Any]!) -> Self {
        addAttribute(#selector(setter:UITextView.linkTextAttributes),value)
        return self
    }
    
    @available(iOS 13.0, *)
    public func usesStandardTextScaling(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.usesStandardTextScaling),value)
        return self
    }
}
