//
//  Toggle.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Toggle {
    @discardableResult
    public func onTintColor(_ value:@escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.onTintColor),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func thumbTintColor(_ value:@escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.thumbTintColor),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func onImage(_ value:@escaping @autoclosure () -> UIImage?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.onImage),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func offImage(_ value:@escaping @autoclosure () -> UIImage?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.offImage),value())
		}, forKey: #function)
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func title(_ value:@escaping @autoclosure () -> String?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.title),value())
		}, forKey: #function)
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func preferredStyle(_ value:@escaping @autoclosure () -> UISwitch.Style)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.preferredStyle),value().rawValue)
		}, forKey: #function)
    }
    
    @discardableResult
    public func isOn(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISwitch.isOn),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func setOn(_ on: @escaping @autoclosure () -> Bool, animated: @escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UISwitch.setOn(_:animated:)),isOn,animated())
		}, forKey: #function)
    }
}
