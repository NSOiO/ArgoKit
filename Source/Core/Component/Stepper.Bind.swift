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
    public func isContinuous(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.isContinuous),value())
		}, forKey: #function)
    }
    
    // if YES, press & hold repeatedly alters value. default = YES
    @discardableResult
    public func autorepeat(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.autorepeat),value())
		}, forKey: #function)
    }
    
    // if YES, value wraps from min <-> max. default = NO
    @discardableResult
    public func wraps(_ value:@escaping @autoclosure () -> Bool)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.wraps),value())
		}, forKey: #function)
    }
    
    // default is 0. sends UIControlEventValueChanged. clamped to min/max
    @discardableResult
    public func value(_ value1:@escaping @autoclosure () -> Double)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(Selector(("setValue:")),value1())
		}, forKey: #function)
    }
    
    // default 0. must be less than maximumValue
    @discardableResult
    public func minimumValue(_ value:@escaping @autoclosure () -> Double)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.minimumValue),value())
		}, forKey: #function)
    }
    
    // default 100. must be greater than minimumValue
    @discardableResult
    public func maximumValue(_ value:@escaping @autoclosure () -> Double)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.maximumValue),value())
		}, forKey: #function)
    }
    
    // default 1. must be greater than 0
    @discardableResult
    public func stepValue(_ value:@escaping @autoclosure () -> Double)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIStepper.stepValue),value())
		}, forKey: #function)
    }
    
    // a background image which will be 3-way stretched over the whole of the control. Each half of the stepper will paint the image appropriate for its state
    @available(iOS 6.0, *)
    @discardableResult
    public func setBackgroundImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIStepper.setBackgroundImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }

    // an image which will be painted in between the two stepper segments. The image is selected depending both segments' state
    @available(iOS 6.0, *)
    @discardableResult
    public func setDividerImage(_ image: @escaping @autoclosure () -> UIImage?, forLeftSegmentState leftState: @escaping @autoclosure () -> UIControl.State, rightSegmentState rightState: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIStepper.setDividerImage(_:forLeftSegmentState:rightSegmentState:)),leftState(),rightState())
		}, forKey: #function)
    }

    // the glyph image for the plus/increase button
    @available(iOS 6.0, *)
    @discardableResult
    public func setIncrementImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIStepper.setIncrementImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }
    
    // the glyph image for the minus/decrease button
    @available(iOS 6.0, *)
    @discardableResult
    public func setDecrementImage(_ image: @escaping @autoclosure () -> UIImage?, for state: @escaping @autoclosure () -> UIControl.State)->Self{
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIStepper.setDecrementImage(_:for:)),image(),state().rawValue)
		}, forKey: #function)
    }
}
