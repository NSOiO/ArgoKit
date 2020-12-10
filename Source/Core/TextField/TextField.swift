//
//  TextField.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct TextField : View {
    private var fontSize:CGFloat = UIFont.systemFontSize
    private var fontStyle:AKFontStyle = .default
    private var font:UIFont
    private var fontName:String?
    private var pNode : ArgoKitTextFieldNode
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init() {
        self.init(nil)
    }
    public init(_ text: String?, placeholder: String? = nil) {
        font = UIFont.systemFont(ofSize:fontSize)
        pNode = ArgoKitTextFieldNode(viewClass:UITextField.self)
        pNode.placeholder = placeholder
        pNode.alignSelfFlexStart()
        addAttribute(#selector(setter:UITextField.text),text)
        addAttribute(#selector(setter:UITextField.placeholder),placeholder)
    }
}

extension TextField {
    @discardableResult
    public func text(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.text),value)
        return self
    }
    
    @discardableResult
    public func attributedText(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedText),value)
        return self
    }
    
    @discardableResult
    public func textColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITextField.textColor),value)
        pNode.updateAttributePlaceholder()
        return self
    }
    
    @discardableResult
    public func font(_ value: UIFont?) -> Self {
        addAttribute(#selector(setter:UITextField.font),value)
        return self
    }
    
    @discardableResult
    public func font(fontName: String? = nil, fontStyle:AKFontStyle = .default,fontSize:CGFloat = UIFont.systemFontSize)->Self{
        let f = UIFont.font(fontName: fontName, fontStyle: fontStyle, fontSize: fontSize)
        return font(f)
    }
    
    @discardableResult
    public mutating func fontName(_ value:String?)->Self{
        fontName = value
        let f = UIFont.font(fontName: value, fontStyle: fontStyle, fontSize: fontSize)
        return font(f)
    }
    
    @discardableResult
    public mutating func fontSize(_ value:CGFloat)->Self{
        fontSize = value
        let f = UIFont.font(fontName: nil, fontStyle: fontStyle, fontSize: value)
        return font(f)
    }
    
    @discardableResult
    public func fontStyle(_ value:AKFontStyle)->Self{
        let f = UIFont.font(fontName: nil, fontStyle: value, fontSize: fontSize)
        return font(f)
    }
    
    @discardableResult
    public func placeholder(_ value: String?) -> Self {
        addAttribute(#selector(setter:UITextField.placeholder),value)
        pNode.placeholder = value
        return self
    }
    
    @discardableResult
    public func placeholderColor(_ value: UIColor?) -> Self {
        pNode.placeholderColor = value
        pNode.updateAttributePlaceholder()
        return self
    }
    
    @discardableResult
    public func attributedPlaceholder(_ value: NSAttributedString?) -> Self {
        addAttribute(#selector(setter:UITextField.attributedPlaceholder),value)
        return self
    }
    
    @discardableResult
    public func textAlign(_ value: NSTextAlignment) -> Self {
        addAttribute(#selector(setter:UITextField.textAlignment),value.rawValue)
        return self
    }
    
    @discardableResult
    public func borderStyle(_ value: UITextField.BorderStyle) -> Self {
        addAttribute(#selector(setter:UITextField.borderStyle),value)
        return self
    }
    
    @discardableResult
    public func defaultTextAttributes(_ value: [NSAttributedString.Key : Any]) -> Self {
        addAttribute(#selector(setter:UITextField.defaultTextAttributes),value)
        return self
    }
    
    @discardableResult
    public func clearsOnBeginEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnBeginEditing),value)
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    @discardableResult
    public func minimumFontSize(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITextField.minimumFontSize),value)
        return self
    }
    
    @discardableResult
    public func delegate(_ value: UITextFieldDelegate?) -> Self {
        addAttribute(#selector(setter:UITextField.delegate),value)
        return self
    }
    
    @discardableResult
    public func background(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.background),value)
        return self
    }
    
    @discardableResult
    public func disabledBackground(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UITextField.disabledBackground),value)
        return self
    }
    
    @discardableResult
    public func allowsEditingTextAttributes(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.allowsEditingTextAttributes),value)
        return self
    }
    
    @discardableResult
    public func typingAttributes(_ value: [NSAttributedString.Key : Any]?) -> Self {
        addAttribute(#selector(setter:UITextField.typingAttributes),value)
        return self
    }
    
    @discardableResult
    public func clearButtonMode(_ value: UITextField.ViewMode) -> Self {
        addAttribute(#selector(setter:UITextField.clearButtonMode),value)
        return self
    }
    
    @discardableResult
    public func leftView(_ viewMode: UITextField.ViewMode,_ content:()->View) -> Self {
        let lfView = content()
        if let node = lfView.alignSelf(.start).node {
            let width = node.width()
            addAttribute(#selector(setter:ArgoKitTextField.leftPadding),width)
            pNode.addChildNode(node)
        }
        return self
    }
    
    @discardableResult
    public func rightView(_ viewMode: UITextField.ViewMode,_ content:()->View) -> Self {
        let rtView = content()
        if let node = rtView.alignSelf(.end).node {
            let width = node.width()
            node.positionAbsolute()
            node.left(point: (pNode.width()-width))
            addAttribute(#selector(setter:ArgoKitTextField.rightPadding),width)
            pNode.addChildNode(node)
        }
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
            addAttribute(#selector(setter:UITextField.inputView),node.view)
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
            addAttribute(#selector(setter:UITextField.inputAccessoryView),node.view)
        }
        return self
    }
    
    @discardableResult
    public func clearsOnInsertion(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITextField.clearsOnInsertion),value)
        return self
    }
}

extension TextField {
    
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
    
    @discardableResult
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    
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
