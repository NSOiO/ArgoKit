//
//  TextView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct TextView : View {
    
    private var textView : UITextView
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
        textView = UITextView()
        pNode = ArgoKitNode(view: textView)
        textView.text = text;
    }
    
    public init(textContainer: NSTextContainer?) {
        textView = UITextView(frame: .zero, textContainer: textContainer)
        pNode = ArgoKitNode(view: textView)
    }
}

extension TextView {

    public func delegate(_ value: UITextViewDelegate?) -> Self {
        textView.delegate = value
        return self
    }
    
    public func text(_ value: String?) -> Self {
        textView.text = value
        return self
    }
    
    public func font(_ value: UIFont?) -> Self {
        textView.font = value
        return self
    }
    
    public func textColor(_ value: UIColor?) -> Self {
        textView.textColor = value
        return self
    }
    
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        textView.textAlignment = value
        return self
    }
    
    public func selectedRange(_ value: NSRange) -> Self {
        textView.selectedRange = value
        return self
    }
    
    public func isEditable(_ value: Bool) -> Self {
        textView.isEditable = value
        return self
    }
    
    public func isSelectable(_ value: Bool) -> Self {
        textView.isSelectable = value
        return self
    }
    
    public func dataDetectorTypes(_ value: UIDataDetectorTypes) -> Self {
        textView.dataDetectorTypes = value
        return self
    }
    
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        textView.allowsEditingTextAttributes = value
        return self
    }
    
    public func attributedText(_ value: NSAttributedString!) -> Self {
        textView.attributedText = value
        return self
    }
    
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        textView.typingAttributes = value
        return self
    }
    
    public func scrollRangeToVisible(_ value: NSRange) -> Self {
        textView.scrollRangeToVisible(value)
        return self
    }
    
    public func inputView(_ value: UIView?) -> Self {
        textView.inputView = value
        return self
    }
    
    public func inputAccessoryView(_ value: UIView?) -> Self {
        textView.inputAccessoryView = value
        return self
    }
    
    public func clearsOnInsertion(_ value: Bool) -> Self {
        textView.clearsOnInsertion = value
        return self
    }
    
    public func textContainerInset(_ value: UIEdgeInsets) -> Self {
        textView.textContainerInset = value
        return self
    }
    
    public func linkTextAttributes(_ value: [NSAttributedString.Key : Any]!) -> Self {
        textView.linkTextAttributes = value
        return self
    }
    
    @available(iOS 13.0, *)
    public func usesStandardTextScaling(_ value: Bool) -> Self {
        textView.usesStandardTextScaling = value
        return self
    }
}
