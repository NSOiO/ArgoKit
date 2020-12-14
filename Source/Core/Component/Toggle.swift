//
//  Toggle.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
class ArgoKitToggleNode: ArgoKitNode {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // （IOS7,*)
        return CGSize(width: 51, height: 31)
    }
}
public struct Toggle:View{
    private let pNode:ArgoKitToggleNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(_ isOn:Bool,action:@escaping (_ isOn:Bool)->Void){
        pNode = ArgoKitToggleNode(viewClass:UISwitch.self);
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
    
    @discardableResult
    public func onTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UISwitch.onTintColor),value)
        return self
    }
    
    @discardableResult
    public func thumbTintColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UISwitch.thumbTintColor),value)
        return self
    }
    
    @discardableResult
    public func onImage(_ value:UIImage?)->Self{
        addAttribute(#selector(setter:UISwitch.onImage),value)
        return self
    }
    
    @discardableResult
    public func offImage(_ value:UIImage?)->Self{
        addAttribute(#selector(setter:UISwitch.offImage),value)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func title(_ value:String?)->Self{
        addAttribute(#selector(setter:UISwitch.title),value)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func preferredStyle(_ value:UISwitch.Style)->Self{
        addAttribute(#selector(setter:UISwitch.preferredStyle),value.rawValue)
        return self
    }
    
    @discardableResult
    public func isOn(_ value:Bool)->Self{
        addAttribute(#selector(setter:UISwitch.isOn),value)
        return self
    }
    
    @discardableResult
    public func setOn(_ on: Bool, animated: Bool)->Self{
        addAttribute(#selector(UISwitch.setOn(_:animated:)),isOn,animated)
        return self
    }
}


extension Toggle{
    @available(*, deprecated, message: "Toggle does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Toggle does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
