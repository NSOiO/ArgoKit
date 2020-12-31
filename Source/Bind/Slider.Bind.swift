//
//  Slider.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Slider{
    // default 0.0. this value will be pinned to min/max
    @discardableResult
    public func value(_ value: @escaping @autoclosure () -> Float, animated: @escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UISlider.setValue(_:animated:)),value(),animated())
		}, forKey: #function)
    }
    // default 0.0. the current value may change if outside new min value
    @discardableResult
    public func minimumValue(_ value: @escaping @autoclosure () -> Float)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.minimumValue),value())
		}, forKey: #function)
    }
    // default 1.0. the current value may change if outside new max value
    @discardableResult
    public func maximumValue(_ value: @escaping @autoclosure () -> Float)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.maximumValue),value())
		}, forKey: #function)
    }
    // default is nil. image that appears to left of control (e.g. speaker off)
    @discardableResult
    public func minimumValueImage(_ value: @escaping @autoclosure () -> UIImage?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.minimumValueImage),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func minimumValueImage(_ value: @escaping @autoclosure () -> String?)->Self{
		return self.bindCallback({ [self] in 
			let image = UIImage(named:value() ?? "")
			addAttribute(#selector(setter:UISlider.minimumValueImage),image)
		}, forKey: #function)
    }
    
    // default is nil. image that appears to right of control (e.g. speaker max)
    @discardableResult
    public func maximumValueImage(_ value: @escaping @autoclosure () -> UIImage?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.maximumValueImage),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func maximumValueImage(_ value: @escaping @autoclosure () -> String?)->Self{
		return self.bindCallback({ [self] in 
			let image = UIImage(named:value() ?? "")
			addAttribute(#selector(setter:UISlider.maximumValueImage),image)
		}, forKey: #function)
    }
    
    // if set, value change events are generated any time the value changes due to dragging. default = YES
    @discardableResult
    public func isContinuous(_ value: @escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.isContinuous),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func minimumTrackTintColor(_ value: @escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.minimumTrackTintColor),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func maximumTrackTintColor(_ value: @escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.maximumTrackTintColor),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func thumbTintColor(_ value: @escaping @autoclosure () -> UIColor?)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UISlider.thumbTintColor),value())
		}, forKey: #function)
    }
    
    @discardableResult
    public func thumbImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UISlider.setThumbImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }

    @discardableResult
    public func minimumTrackImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UISlider.setMinimumTrackImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }
    
    @discardableResult
    public func maximumTrackImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UISlider.setMaximumTrackImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }
    
}
