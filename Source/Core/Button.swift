//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public class Button:View{
    private let pNode:ArgoKitNode
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
    public func imageEdgeInsets(_ value: UIEdgeInsets)->Self{
        addAttribute(#selector(setter:UIButton.imageEdgeInsets),value)
        return self
    }
    public func contentEdgeInsets(_ value: UIEdgeInsets)->Self{
        addAttribute(#selector(setter:UIButton.contentEdgeInsets),value)
        return self
    }
    public func titleEdgeInsets(_ value: UIEdgeInsets)->Self{
        addAttribute(#selector(setter:UIButton.titleEdgeInsets),value)
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
    public func image(path: String?, for state: UIControl.State)->Self{
        if let p =  path{
            if let image =  UIImage(named:p){
                addAttribute(#selector(UIButton.setImage(_:for:)),image,state.rawValue)
            }
        }
        return self
    }
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
        return self
    }
    public func backgroundImage(path: String?, for state: UIControl.State)->Self{
        if let p =  path{
            if let image =  UIImage(named:p){
                addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
            }
        }
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

extension Button{
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        var edgeInsets = UIEdgeInsets()
        switch top {
        case .point(let value):
            edgeInsets.top = value
        default:
            break
        }
        switch right {
        case .point(let value):
            edgeInsets.right = value
        default:
            break
        }
        switch bottom {
        case .point(let value):
            edgeInsets.bottom = value
        default:
            break
        }
        switch left {
        case .point(let value):
            edgeInsets.left = value
        default:
            break
        }
        addAttribute(#selector(setter:UIButton.imageEdgeInsets),edgeInsets)
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
