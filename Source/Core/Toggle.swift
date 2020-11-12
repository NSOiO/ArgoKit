//
//  Toggle.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public class Toggle:View{
    public var body: View{
        ViewEmpty()
    }
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init(_ isOn:Bool,action:@escaping (_ isOn:Bool)->Void){
        pNode = ArgoKitNode(viewClass:UISwitch.self);
        addAttribute(#selector(UISwitch.setOn(_:animated:)),isOn,false)
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let swit = obj as? UISwitch {
                action(swit.isOn)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}

extension Toggle{
    public func onTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UISwitch.onTintColor),value)
        return self
    }
    public func thumbTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UISwitch.thumbTintColor),value)
        return self
    }
    
    public func onImage(_ value:UIImage?)->Self{
        addAttribute(#selector(setter:UISwitch.onImage),value)
        return self
    }
    
    public func offImage(_ value:UIImage?)->Self{
        addAttribute(#selector(setter:UISwitch.offImage),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func title(_ value:String?)->Self{
        addAttribute(#selector(setter:UISwitch.title),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func preferredStyle(_ value:UISwitch.Style)->Self{
        addAttribute(#selector(setter:UISwitch.preferredStyle),value.rawValue)
        return self
    }
    
    public func isOn(_ value:Bool)->Self{
        addAttribute(#selector(setter:UISwitch.isOn),value)
        return self
    }
    
    public func setOn(_ on: Bool, animated: Bool)->Self{
        addAttribute(#selector(UISwitch.setOn(_:animated:)),isOn,animated)
        return self
    }
}
