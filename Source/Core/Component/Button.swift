//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public struct Button:View{
    
    private let pNode:ArgoKitArttibuteNode
    private var label:Text?
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
        pNode = ArgoKitArttibuteNode(viewClass: UIButton.self)
        pNode.row()
        pNode.alignItemsCenter()
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
    public func font(name: String? = nil, style:AKFontStyle,size:CGFloat)->Self{
        pNode.fontName = name
        pNode.fontSize = size
        pNode.fontStyle = style
        let f = UIFont.font(fontName:name, fontStyle:style, fontSize:size)
        return font(f)
    }
    
    @discardableResult
    public func backgroundImage(image: UIImage?, for state: UIControl.State)->Self{
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

