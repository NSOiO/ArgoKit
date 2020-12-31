//
//  Stepper.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Stepper {
    // if YES, value change events are sent any time the value changes during interaction. default = YES
    @discardableResult
    public func isContinuous(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIStepper.isContinuous),value)
        return self
    }
    
    // if YES, press & hold repeatedly alters value. default = YES
    @discardableResult
    public func autorepeat(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIStepper.autorepeat),value)
        return self
    }
    
    // if YES, value wraps from min <-> max. default = NO
    @discardableResult
    public func wraps(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIStepper.wraps),value)
        return self
    }
    
    // default is 0. sends UIControlEventValueChanged. clamped to min/max
    @discardableResult
    public func value(_ value1:Double)->Self{
        addAttribute(Selector(("setValue:")),value1)
        return self
    }
    
    // default 0. must be less than maximumValue
    @discardableResult
    public func minimumValue(_ value:Double)->Self{
        addAttribute(#selector(setter:UIStepper.minimumValue),value)
        return self
    }
    
    // default 100. must be greater than minimumValue
    @discardableResult
    public func maximumValue(_ value:Double)->Self{
        addAttribute(#selector(setter:UIStepper.maximumValue),value)
        return self
    }
    
    // default 1. must be greater than 0
    @discardableResult
    public func stepValue(_ value:Double)->Self{
        addAttribute(#selector(setter:UIStepper.stepValue),value)
        return self
    }
    
    // a background image which will be 3-way stretched over the whole of the control. Each half of the stepper will paint the image appropriate for its state
    @available(iOS 6.0, *)
    @discardableResult
    public func setBackgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIStepper.setBackgroundImage(_:for:)),image,state.rawValue)
        return self
    }

    // an image which will be painted in between the two stepper segments. The image is selected depending both segments' state
    @available(iOS 6.0, *)
    @discardableResult
    public func setDividerImage(_ image: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State)->Self{
        addAttribute(#selector(UIStepper.setDividerImage(_:forLeftSegmentState:rightSegmentState:)),leftState,rightState)
        return self
    }

    // the glyph image for the plus/increase button
    @available(iOS 6.0, *)
    @discardableResult
    public func setIncrementImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIStepper.setIncrementImage(_:for:)),image,state.rawValue)
        return self
    }
    
    // the glyph image for the minus/decrease button
    @available(iOS 6.0, *)
    @discardableResult
    public func setDecrementImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UIStepper.setDecrementImage(_:for:)),image,state.rawValue)
        return self
    }
}
