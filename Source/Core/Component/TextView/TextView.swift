//
//  TextView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public class TextView : ScrollView {
    private var fontSize:CGFloat = UIFont.systemFontSize
    private var fontStyle:AKFontStyle = .default
    private var font:UIFont
    private var fontName:String?
    private var textViewNode: ArgoKitTextViewNode {
        pNode as! ArgoKitTextViewNode
    }
    
    override convenience init() {
        self.init(text:nil)
    }
    
    public init(text: String?) {
        font = UIFont.systemFont(ofSize:fontSize)
        super.init()
        if text != nil {
            addAttribute(#selector(setter:UITextView.text),text)
        }
    }
    
    
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
    @discardableResult
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextView.text),value)
        return self
    }
    
    @discardableResult
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextView.font),value)
        return self
    }
    
    @discardableResult
    public func font(name: String?, style:AKFontStyle,size:CGFloat)->Self{
        textViewNode.fontName = name
        textViewNode.fontStyle = style
        textViewNode.fontSize = size
        let font = UIFont.font(fontName: name, fontStyle: style, fontSize: size)
        return self.font(font)
    }
    
    @discardableResult
    public func font(name value:String?)->Self{
        textViewNode.fontName = value
        let font = UIFont.font(fontName: value, fontStyle: textViewNode.fontStyle, fontSize: textViewNode.fontSize)
        return self.font(font)
    }
    
    @discardableResult
    public  func font(size value:CGFloat)->Self{
        textViewNode.fontSize = value
        let font = UIFont.font(fontName: textViewNode.fontName, fontStyle:  textViewNode.fontStyle, fontSize: value)
        return self.font(font)
    }
    
    @discardableResult
    public func font(style value:AKFontStyle)->Self{
        textViewNode.fontStyle = value
        let font = UIFont.font(fontName: textViewNode.fontName, fontStyle: value, fontSize: textViewNode.fontSize)
        return self.font(font)
    }
    
    @discardableResult
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self
    }
    
    @discardableResult
    public func textColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self;
    }
    
    @discardableResult
    public func textColor(hex:Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UITextView.textColor),value)
        return self;
    }
    
    @discardableResult
    public func textAlign(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextView.textAlignment),value.rawValue)
        return self
    }
    
    @discardableResult
    public func selectedRange(_ value: NSRange) -> Self {
        addAttribute(#selector(setter:UITextView.selectedRange),value)
        return self
    }
    
    @discardableResult
    public func isEditable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isEditable),value)
        return self
    }
    
    @discardableResult
    public func isSelectable(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.isSelectable),value)
        return self
    }
    
    @discardableResult
    public func dataDetectorTypes(detectorType value: ()->UIDataDetectorTypes) -> Self {
        addAttribute(#selector(setter:UITextView.dataDetectorTypes),value())
        return self
    }
    
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.allowsEditingTextAttributes),value)
        return self
    }
    
    @discardableResult
    public func attributedText(_ value: NSAttributedString!) -> Self {
        addAttribute(#selector(setter:UITextView.attributedText),value)
        return self
    }
    
    @discardableResult
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextView.typingAttributes),value)
        return self
    }
    
    @discardableResult
    public func scrollRangeToVisible(_ value: NSRange) -> Self {
        addAttribute(#selector(UITextView.scrollRangeToVisible),value)
        return self
    }
    
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
    
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.clearsOnInsertion),value)
        return self
    }
    
    @discardableResult
    public func textContainerInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITextView.textContainerInset),value)
        return self
    }
    
    @discardableResult
    public func linkTextAttributes(_ value: [NSAttributedString.Key : Any]!) -> Self {
        addAttribute(#selector(setter:UITextView.linkTextAttributes),value)
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func usesStandardTextScaling(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextView.usesStandardTextScaling),value)
        return self
    }
}

extension TextView {
    
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
