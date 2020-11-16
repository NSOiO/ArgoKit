//
//  TextView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public class TextView : ScrollView {
       
    private var textViewNode: ArgoKitTextViewNode {
        pNode as! ArgoKitTextViewNode
    }

    override convenience init() {
        self.init(nil)
    }
    
    public init(_ text: String?) {
        super.init()
        if text != nil {
            addAttribute(#selector(setter:UITextView.text),text)
        }
    }
    
    public init(textContainer: NSTextContainer?) {
        super.init()
        textViewNode.textContainer = textContainer
    }
    
    override func createNode() {
        pNode = ArgoKitTextViewNode(viewClass: UITextView.self)
    }
}

extension TextView {
    
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

extension TextView {
    
    public func shouldBeginEditing(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewShouldBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }

    public func shouldEndEditing(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewShouldEndEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }

    public func didBeginEditing(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidBeginEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }

    public func didEndEditing(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidEndEditing(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }

    public func shouldChangeTextInRangeReplacementText(_ action: @escaping (_ range: NSRange, _ text: String) -> Bool) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textView(_:shouldChangeTextIn:replacementText:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let range: NSRange = paramter![0] as! NSRange
                let text: String = paramter![1] as! String
                return action(range, text)
            }
            return nil
        })
        return self
    }

    public func didChange(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidChange(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }

    public func didChangeSelection(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTextViewNode.textViewDidChangeSelection(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }

    @available(iOS 10.0, *)
    public func shouldInteractWithURLInCharacterRangeInteraction(_ action: @escaping (_ URL: URL, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool) -> Self {
        let sel = #selector(textViewNode.textView(_:shouldInteractWith:in:interaction:) as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let URL: URL = paramter![0] as! URL
                let characterRange: NSRange = paramter![1] as! NSRange
                let interaction: UITextItemInteraction = paramter![2] as! UITextItemInteraction
                return action(URL, characterRange, interaction)
            }
            return nil
        })
        return self
    }

    @available(iOS 10.0, *)
    public func shouldInteractWithTextAttachmentInCharacterRangeInteraction(_ action: @escaping (_ textAttachment: NSTextAttachment, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool) -> Self {
        let sel = #selector(textViewNode.textView(_:shouldInteractWith:in:interaction:) as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool);
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let textAttachment: NSTextAttachment = paramter![0] as! NSTextAttachment
                let characterRange: NSRange = paramter![1] as! NSRange
                let interaction: UITextItemInteraction = paramter![2] as! UITextItemInteraction
                return action(textAttachment, characterRange, interaction)
            }
            return nil
        })
        return self
    }

}
