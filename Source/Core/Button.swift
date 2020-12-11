//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
class ArgoKitButtonNode: ArgoKitNode {
     var fontSize:CGFloat = 17.0
     var fontStyle:AKFontStyle = .default
     var fontName:String?
}
public struct Button:View{
    
    
    private let pNode:ArgoKitButtonNode
    private var label:Text?
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
        pNode = ArgoKitButtonNode(viewClass: UIButton.self)
        pNode.row()
        pNode.alignSelfFlexStart()
    }
    
    public init(action :@escaping ()->Void,@ArgoKitViewBuilder builder:@escaping ()->View){
        self.init(text: nil, action: action)
        addSubNodes(builder: builder)
    }
    
    public init(text:String?,action :@escaping ()->Void){
        self.init()
        pNode.addAction({ (obj, paramter) -> Any? in
            action();
        }, for: UIControl.Event.touchUpInside)
        
        if let t = text {
            label = Text(t).alignSelf(.center).textAlign(.center).grow(1)
            if let node = label?.node {
                pNode.addChildNode(node)
            }
            setValue(pNode, #selector(setter: UILabel.text), t)
        }
    }
}


extension Button{
    
    @discardableResult
    public func text(_ value: String?)->Self{
        setValue(pNode, #selector(setter: UILabel.text), value)
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor?)->Self{
        setValue(pNode, #selector(setter: UILabel.textColor), color)
        return self
    }
    
    @discardableResult
    public func textColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        return self.textColor(value)
    }
    
    @discardableResult
    public func textColor(hex:Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        return self.textColor(value)
    }
    
    @discardableResult
    public func font(_ value:UIFont!)->Self{
        setValue(pNode, #selector(setter: UILabel.font), value)
        return self
    }
    
    @discardableResult
    public func font(name: String?, style:AKFontStyle,size:CGFloat)->Self{
        let f = UIFont.font(fontName:name, fontStyle:style, fontSize:size)
        return font(f)
    }
    
    @discardableResult
    public  func font(name value:String?)->Self{
        pNode.fontName = value
        let f = UIFont.font(fontName: value, fontStyle: pNode.fontStyle, fontSize: pNode.fontSize)
        return font(f)
    }
    
    @discardableResult
    public func font(size value:CGFloat)->Self{
        pNode.fontSize = value
        let f = UIFont.font(fontName: pNode.fontName, fontStyle: pNode.fontStyle, fontSize: value)
        return font(f)
    }
    
    @discardableResult
    public func font(style value:AKFontStyle)->Self{
        pNode.fontStyle = value
        let f = UIFont.font(fontName: pNode.fontName, fontStyle: value, fontSize: pNode.fontSize)
        return font(f)
    }
    
    @discardableResult
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
        return self
    }
    
    @discardableResult
    public func backgroundImage(path: String?, for state: UIControl.State)->Self{
        if let p =  path{
            if let image =  UIImage(named:p){
                addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
            }
        }
        return self
    }
    
    
    func setValue(_ node:ArgoKitNode,_ selector:Selector,_ value:Any?) -> Void {
        if let nodes = node.childs{
            for subNode in nodes {
                if let lableNode = label?.node {
                    if subNode as! NSObject == lableNode {
                        ArgoKitNodeViewModifier.addAttribute(lableNode as? ArgoKitTextNode, selector, value)
                        continue
                    }
                }
                
                if subNode is ArgoKitTextNode {
                    if let _ =  (subNode as! ArgoKitTextNode).value(with: selector){
                    }else{
                        ArgoKitNodeViewModifier.addAttribute(subNode as? ArgoKitTextNode, selector, value)
                    }
                }else{
                    setValue(subNode as! ArgoKitNode, selector, value)
                }
            }
        }
    }
}

