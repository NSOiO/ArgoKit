//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public class Button:View{
    
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
        
        label = Text(text)
        if let node = label?.node {
            pNode.addChildNode(node)
        }
        setValue(pNode, #selector(setter: UILabel.text), text)
    }
}


extension Button{
    public func textColor(_ color: UIColor?)->Self{
        setValue(pNode, #selector(setter: UILabel.textColor), color)
        return self
    }
    public func titleShadowColor(_ color: UIColor?, for state: UIControl.State)->Self{
        setValue(pNode, #selector(setter: UILabel.shadowColor), color)
        setValue(pNode, #selector(setter: UILabel.shadowOffset), CGSize(width: 0, height: 0))
        return self
    }
    
    public func font(_ value:UIFont!)->Self{
        setValue(pNode, #selector(setter: UILabel.font), value)
        return self
    }
    
    public func font(name: String? = nil, style:AKFontStyle = .default,size:CGFloat = UIFont.systemFontSize)->Self{
        let f = UIFont.font(fontName:name, fontStyle:style, fontSize:size)
        return font(f)
    }
    
    public func font(name value:String?)->Self{
        fontName = value
        let f = UIFont.font(fontName: value, fontStyle: fontStyle, fontSize: fontSize)
        return font(f)
    }
    public func font(size value:CGFloat)->Self{
        fontSize = value
        let f = UIFont.font(fontName: nil, fontStyle: fontStyle, fontSize: value)
        return font(f)
    }
    public func font(style value:AKFontStyle)->Self{
        let f = UIFont.font(fontName: nil, fontStyle: value, fontSize: fontSize)
        return font(f)
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

