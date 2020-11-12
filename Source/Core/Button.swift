//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public class Button:View{
    public var body: View{
        ViewEmpty()
    }
    private let pNode:ArgoKitNode
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
        pNode = ArgoKitNode(viewClass: UIButton.self)
    }
    
    public convenience init<S>(_ text:S,action :@escaping ()->Void,@ArgoKitViewBuilder builder:@escaping ()->View) where S:StringProtocol {
        self.init(text: text as? String, action: action)
        addSubNodes(builder: builder)
    }
    
}

extension Button{
    public convenience init<S>(text:S?,action :@escaping ()->Void) where S:StringProtocol{
        self.init()
        addAttribute(#selector(UIButton.setTitle(_:for:)),text as? String,UIControl.State.normal.rawValue)
        
        pNode.addAction({ (obj, paramter) -> Any? in
            action();
        }, for: UIControl.Event.touchUpInside)
    }
}

extension Button{
    public func imageEdgeInsets(_ value:UIEdgeInsets)->Self{
        addAttribute(#selector(setter:UIButton.imageEdgeInsets),value)
        return self
    }
    public func UIEdgeInsets(_ value:UIColor!)->Self {
        addAttribute(#selector(setter:UIButton.tintColor),value)
        return self
    }
    @available(iOS 14.0, *)
    public func role(_ value:UIButton.Role)->Self{
        addAttribute(#selector(setter:UIButton.role),value)
        return self
    }
    
    public func title(_ title: String?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setTitle(_:for:)),title,state.rawValue)
        return self
    }
    
    public func titleColor(_ color: UIColor?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setTitleColor(_:for:)),color,state.rawValue)
        return self
    }
    
    public func titleShadowColor(_ color: UIColor?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setTitleShadowColor(_:for:)),color,state.rawValue)
        return self
    }
    
    public func image(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setImage(_:for:)),image,state.rawValue)
        return self
    }
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
        return self
    }

    @available(iOS 13.0, *)
    public func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setPreferredSymbolConfiguration(_:forImageIn:)),configuration,state.rawValue)
        return self
    }

    @available(iOS 6.0, *)
    public func attributedTitle(_ title: NSAttributedString?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setAttributedTitle(_:for:)),title,state.rawValue)
        return self
    }
    
}
