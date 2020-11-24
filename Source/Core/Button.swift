//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public class Button:View{
    private let pNode:ArgoKitNode
    private var label:Text?
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
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
    }
}


extension Button{
    
    public func title(_ title: String?, for state: UIControl.State)->Self{
        _ = label?.text(title)
        return self
    }
    public func titleColor(_ color: UIColor?, for state: UIControl.State)->Self{
        _ = label?.textColor(color)
        return self
    }
    public func titleShadowColor(_ color: UIColor?, for state: UIControl.State)->Self{
        _ = label?.shadowColor(color).shadowOffset(CGSize(width: 0, height: 0))
        return self
    }
    
    
    
    
//    public func imageEdgeInsets(_ value: UIEdgeInsets)->Self{
//        addAttribute(#selector(setter:UIButton.imageEdgeInsets),value)
//        return self
//    }
//    public func contentEdgeInsets(_ value: UIEdgeInsets)->Self{
//        addAttribute(#selector(setter:UIButton.contentEdgeInsets),value)
//        return self
//    }
//    public func titleEdgeInsets(_ value: UIEdgeInsets)->Self{
//        addAttribute(#selector(setter:UIButton.titleEdgeInsets),value)
//        return self
//    }
//    @available(iOS 14.0, *)
//    public func role(_ value:UIButton.Role)->Self{
//        addAttribute(#selector(setter:UIButton.role),value)
//        return self
//    }
//
//    public func image(_ image: UIImage?, for state: UIControl.State)->Self{
//        addAttribute(#selector(UIButton.setImage(_:for:)),image,state.rawValue)
//        return self
//    }
//    public func image(path: String?, for state: UIControl.State)->Self{
//        if let p =  path{
//            if let image =  UIImage(named:p){
//                addAttribute(#selector(UIButton.setImage(_:for:)),image,state.rawValue)
//            }
//        }
//        return self
//    }
//    public func backgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
//        addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
//        return self
//    }
//    public func backgroundImage(path: String?, for state: UIControl.State)->Self{
//        if let p =  path{
//            if let image =  UIImage(named:p){
//                addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
//            }
//        }
//        return self
//    }
//
//    @available(iOS 13.0, *)
//    public func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State)->Self{
//        addAttribute(#selector(UIButton.setPreferredSymbolConfiguration(_:forImageIn:)),configuration,state.rawValue)
//        return self
//    }
//
//    @available(iOS 6.0, *)
//    public func attributedTitle(_ title: NSAttributedString?, for state: UIControl.State)->Self{
//        addAttribute(#selector(UIButton.setAttributedTitle(_:for:)),title,state.rawValue)
//        return self
//    }
}

