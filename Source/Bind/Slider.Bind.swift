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
    public func value(_ value: Float, animated: Bool)->Self{
        addAttribute(#selector(UISlider.setValue(_:animated:)),value,animated)
        return self
    }
    // default 0.0. the current value may change if outside new min value
    @discardableResult
    public func minimumValue(_ value: Float)->Self{
        addAttribute(#selector(setter:UISlider.minimumValue),value)
        return self
    }
    // default 1.0. the current value may change if outside new max value
    @discardableResult
    public func maximumValue(_ value: Float)->Self{
        addAttribute(#selector(setter:UISlider.maximumValue),value)
        return self
    }
    // default is nil. image that appears to left of control (e.g. speaker off)
    @discardableResult
    public func minimumValueImage(_ value: UIImage?)->Self{
        addAttribute(#selector(setter:UISlider.minimumValueImage),value)
        return self
    }
    
    @discardableResult
    public func minimumValueImage(_ value: String?)->Self{
        let image = UIImage(named:value ?? "")
        addAttribute(#selector(setter:UISlider.minimumValueImage),image)
        return self
    }
    
    // default is nil. image that appears to right of control (e.g. speaker max)
    @discardableResult
    public func maximumValueImage(_ value: UIImage?)->Self{
        addAttribute(#selector(setter:UISlider.maximumValueImage),value)
        return self
    }
    
    @discardableResult
    public func maximumValueImage(_ value: String?)->Self{
        let image = UIImage(named:value ?? "")
        addAttribute(#selector(setter:UISlider.maximumValueImage),image)
        return self
    }
    
    // if set, value change events are generated any time the value changes due to dragging. default = YES
    @discardableResult
    public func isContinuous(_ value: Bool)->Self{
        addAttribute(#selector(setter:UISlider.isContinuous),value)
        return self
    }
    
    @discardableResult
    public func minimumTrackTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.minimumTrackTintColor),value)
        return self
    }
    
    @discardableResult
    public func maximumTrackTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.maximumTrackTintColor),value)
        return self
    }
    
    @discardableResult
    public func thumbTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.thumbTintColor),value)
        return self
    }
    
    @discardableResult
    public func thumbImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setThumbImage(_:for:)),image,state.rawValue)
        return self
    }

    @discardableResult
    public func minimumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setMinimumTrackImage(_:for:)),image,state.rawValue)
        return self
    }
    
    @discardableResult
    public func maximumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setMaximumTrackImage(_:for:)),image,state.rawValue)
        return self
    }
    
}
