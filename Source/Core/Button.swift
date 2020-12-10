//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
open class Button:View{
    
    private var fontSize:CGFloat
    private var fontStyle:AKFontStyle
    private var font:UIFont
    private var fontName:String?
    
    private let pNode:ArgoKitNode
    private var label:Text?
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
        fontStyle = .default
        fontSize = UIFont.systemFontSize
        font = UIFont.systemFont(ofSize:fontSize)
        
        pNode = ArgoKitNode(viewClass: UIButton.self)
        pNode.row()
        pNode.alignItemsFlexStart()
    }
    
    public convenience init(action :@escaping ()->Void,@ArgoKitViewBuilder builder:@escaping ()->View){
        self.init(text: nil, action: action)
        addSubNodes(builder: builder)
    }
    
    public convenience init(text:String?,action :@escaping ()->Void){
        self.init()
        pNode.addAction({ (obj, paramter) -> Any? in
            action();
        }, for: UIControl.Event.touchUpInside)
        
        if let t = text {
            label = Text(t).alignSelf(.center).width(100%).textAlign(.center)
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
    public func font(_ value:UIFont!)->Self{
        setValue(pNode, #selector(setter: UILabel.font), value)
        return self
    }
    
    @discardableResult
    public func font(name: String? = nil, style:AKFontStyle = .default,size:CGFloat = UIFont.systemFontSize)->Self{
        let f = UIFont.font(fontName:name, fontStyle:style, fontSize:size)
        return font(f)
    }
    
    @discardableResult
    public func font(name value:String?)->Self{
        fontName = value
        let f = UIFont.font(fontName: value, fontStyle: fontStyle, fontSize: fontSize)
        return font(f)
    }
    
    @discardableResult
    public func font(size value:CGFloat)->Self{
        fontSize = value
        let f = UIFont.font(fontName: nil, fontStyle: fontStyle, fontSize: value)
        return font(f)
    }
    
    @discardableResult
    public func font(style value:AKFontStyle)->Self{
        let f = UIFont.font(fontName: nil, fontStyle: value, fontSize: fontSize)
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
        if let nodes = pNode.childs{
            for node in nodes {
                if node is ArgoKitTextNode {
                    if let _ =  (node as! ArgoKitTextNode).value(with: selector){
                    }else{
                        ArgoKitNodeViewModifier.addAttribute(node as? ArgoKitTextNode, selector, value)
                    }
                }else{
                    setValue(node as! ArgoKitNode, selector, value)
                }
            }
        }
    }
}

