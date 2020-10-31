//
//  Stepper.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public struct Stepper:View{
    public var body: View{
        self
    }
    private let pStepper:UIStepper
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1,step:Double = 1.0, onValueChanged: @escaping (_ value:Double) -> Void = { _ in })where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint{
        pStepper = UIStepper()
        pNode = ArgoKitNode(view: pStepper)
        pStepper.stepValue = step
        pStepper.minimumValue = Double(bounds.lowerBound)
        pStepper.maximumValue = Double(bounds.upperBound)
        
        pNode.addTarget(pStepper, for: UIControl.Event.valueChanged) { (items) in
            for item in items{
                if item is UIStepper {
                    onValueChanged((item as! UIStepper).value)
                }
            }
        }
    }
}
extension Stepper{
    // if YES, value change events are sent any time the value changes during interaction. default = YES
    public func isContinuous(_ value:Bool)->Self{
        pStepper.isContinuous = value
        return self
    }
    
    // if YES, press & hold repeatedly alters value. default = YES
    public func autorepeat(_ value:Bool)->Self{
        pStepper.autorepeat = value
        return self
    }
    
    // if YES, value wraps from min <-> max. default = NO
    public func wraps(_ value:Bool)->Self{
        pStepper.wraps = value
        return self
    }
    
    // default is 0. sends UIControlEventValueChanged. clamped to min/max
    public func value(_ value:Double)->Self{
        pStepper.value = value
        return self
    }
    
    // default 0. must be less than maximumValue
    public func minimumValue(_ value:Double)->Self{
        pStepper.minimumValue = value
        return self
    }
    
    // default 100. must be greater than minimumValue
    public func maximumValue(_ value:Double)->Self{
        pStepper.maximumValue = value
        return self
    }
    
    // default 1. must be greater than 0
    public func stepValue(_ value:Double)->Self{
        pStepper.stepValue = value
        return self
    }
    
    // a background image which will be 3-way stretched over the whole of the control. Each half of the stepper will paint the image appropriate for its state
    @available(iOS 6.0, *)
    public func setBackgroundImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pStepper.setBackgroundImage(image,for: state)
        return self
    }

    // an image which will be painted in between the two stepper segments. The image is selected depending both segments' state
    @available(iOS 6.0, *)
    public func setDividerImage(_ image: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State)->Self{
        pStepper.setDividerImage(image,forLeftSegmentState:leftState,rightSegmentState: rightState)
        return self
    }

    // the glyph image for the plus/increase button
    @available(iOS 6.0, *)
    public func setIncrementImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pStepper.setIncrementImage(image,for:state)
        return self
    }
    
    // the glyph image for the minus/decrease button
    @available(iOS 6.0, *)
    public func setDecrementImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pStepper.setDecrementImage(image,for:state)
        return self
    }

}
