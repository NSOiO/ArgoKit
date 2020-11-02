//
//  Slider.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public struct Slider:View{
    public var body: View{
        self
    }
    private let pSlider:UISlider
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, onValueChanged: @escaping (_ value:Float) -> Void = { _ in })where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint{
        pSlider = UISlider()
        pSlider.isEnabled = true
        pNode = ArgoKitNode(view: pSlider)
        pSlider.value = Float(value)
        pSlider.minimumValue = Float(bounds.lowerBound)
        pSlider.maximumValue = Float(bounds.upperBound)
        
        pNode.addTarget(pSlider, for: UIControl.Event.valueChanged) { (target, paramter) in
            if let slider = target as? UISlider {
                onValueChanged(slider.value)
            }
            return nil
        }
    }
}
extension Slider{
    // default 0.0. this value will be pinned to min/max
    public func value(_ value: Float)->Self{
        pSlider.value = value
        return self
    }
    // default 0.0. the current value may change if outside new min value
    public func minimumValue(_ value: Float)->Self{
        pSlider.minimumValue = value
        return self
    }
    // default 1.0. the current value may change if outside new max value
    public func maximumValue(_ value: Float)->Self{
        pSlider.maximumValue = value
        return self
    }
    // default is nil. image that appears to left of control (e.g. speaker off)
    public func minimumValueImage(_ value: UIImage?)->Self{
        pSlider.minimumValueImage = value
        return self
    }
    // default is nil. image that appears to right of control (e.g. speaker max)
    public func maximumValueImage(_ value: UIImage?)->Self{
        pSlider.maximumValueImage = value
        return self
    }
    // if set, value change events are generated any time the value changes due to dragging. default = YES
    public func isContinuous(_ value: Bool)->Self{
        pSlider.isContinuous = value
        return self
    }
    
    public func minimumTrackTintColor(_ value: UIColor?)->Self{
        pSlider.minimumTrackTintColor = value
        return self
    }
    
    public func maximumTrackTintColor(_ value: UIColor?)->Self{
        pSlider.maximumTrackTintColor = value
        return self
    }
    
    public func thumbTintColor(_ value: UIColor?)->Self{
        pSlider.thumbTintColor = value
        return self
    }
    
    public func setValue(_ value: Float, animated: Bool)->Self{
        pSlider.setValue(value,animated: animated)
        return self
    }
    
    public func setThumbImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pSlider.setThumbImage(image,for: state)
        return self
    }

    public func setMinimumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pSlider.setMinimumTrackImage(image,for: state)
        return self
    }
    
    public func setMaximumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        pSlider.setMaximumTrackImage(image,for: state)
        return self
    }
    
}
