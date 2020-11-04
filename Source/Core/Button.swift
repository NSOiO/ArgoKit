//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public struct Button:View{
    public var body: View{
        self
    }
    private let button:UIButton
    private let pNode:ArgoKitNode
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public var node: ArgoKitNode?{
        pNode
    }
    
    private init(){
        button = UIButton(type:.custom)
        pNode = ArgoKitNode(view: button)
    }
    
    public init<S>(_ text:S,action :@escaping ()->Void,@ArgoKitViewBuilder builder:@escaping ()->View) where S:StringProtocol {
        self.init(text: text as? String, action: action)
        addSubNodes(builder: builder)
    }
    
}

extension Button{
    public init<S>(text:S?,action :@escaping ()->Void) where S:StringProtocol{
        self.init()
        button.setTitle(text as? String, for: UIControl.State.normal)
        pNode.addTarget(button, for: UIControl.Event.touchUpInside) { (obj, paramter) in
            action();
        }
    }
}

extension Button{
    public func imageEdgeInsets(_ value:UIEdgeInsets)->Self{
        button.imageEdgeInsets = value
        return self
    }
    public func UIEdgeInsets(_ value:UIColor!)->Self {
        button.tintColor = value
        return self
    }
    @available(iOS 14.0, *)
    public func role(_ value:UIButton.Role)->Self{
        button.role = value
        return self
    }
    
    public func title(_ title: String?, for state: UIControl.State)->Self{
        button.setTitle(title, for: state)
        return self
    }
    
    public func titleColor(_ color: UIColor?, for state: UIControl.State)->Self{
        button.setTitleColor(color, for: state)
        return self
    }
    
    public func titleShadowColor(_ color: UIColor?, for state: UIControl.State)->Self{
        button.setTitleShadowColor(color, for: state)
        return self
    }
    
    public func image(_ image: UIImage?, for state: UIControl.State)->Self{
        button.setImage(image, for: state)
        return self
    }
    public func backgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        button.setBackgroundImage(image, for: state)
        return self
    }

    @available(iOS 13.0, *)
    public func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State)->Self{
        button.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }

    @available(iOS 6.0, *)
    public func attributedTitle(_ title: NSAttributedString?, for state: UIControl.State)->Self{
        button.setAttributedTitle(title, for: state)
        return self
    }
    
}
