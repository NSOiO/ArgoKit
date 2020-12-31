//
//  Toggle.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Toggle {
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
