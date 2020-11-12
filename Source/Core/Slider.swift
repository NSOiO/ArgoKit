//
//  Slider.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public class Slider:View{
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
    public init<V>(value: V, in bounds: ClosedRange<V> = 0...1, onValueChanged: @escaping (_ value:Float) -> Void = { _ in })where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint{
        pNode = ArgoKitNode(viewClass:UISlider.self)
        addAttribute(Selector(("setValue:")),value)
        addAttribute(#selector(setter:UISlider.minimumValue),Float(bounds.lowerBound))
        addAttribute(#selector(setter:UISlider.maximumValue),Float(bounds.upperBound))
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let slider = obj as? UISlider {
                onValueChanged(slider.value)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}
extension Slider{
    // default 0.0. this value will be pinned to min/max
    public func value(_ value: Float, animated: Bool)->Self{
        addAttribute(#selector(UISlider.setValue(_:animated:)),value,animated)
        return self
    }
    // default 0.0. the current value may change if outside new min value
    public func minimumValue(_ value: Float)->Self{
        addAttribute(#selector(setter:UISlider.minimumValue),value)
        return self
    }
    // default 1.0. the current value may change if outside new max value
    public func maximumValue(_ value: Float)->Self{
        addAttribute(#selector(setter:UISlider.maximumValue),value)
        return self
    }
    // default is nil. image that appears to left of control (e.g. speaker off)
    public func minimumValueImage(_ value: UIImage?)->Self{
        addAttribute(#selector(setter:UISlider.minimumValueImage),value)
        return self
    }
    // default is nil. image that appears to right of control (e.g. speaker max)
    public func maximumValueImage(_ value: UIImage?)->Self{
        addAttribute(#selector(setter:UISlider.maximumValueImage),value)
        return self
    }
    // if set, value change events are generated any time the value changes due to dragging. default = YES
    public func isContinuous(_ value: Bool)->Self{
        addAttribute(#selector(setter:UISlider.isContinuous),value)
        return self
    }
    
    public func minimumTrackTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.minimumTrackTintColor),value)
        return self
    }
    
    public func maximumTrackTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.maximumTrackTintColor),value)
        return self
    }
    
    public func thumbTintColor(_ value: UIColor?)->Self{
        addAttribute(#selector(setter:UISlider.thumbTintColor),value)
        return self
    }
    

    
    public func thumbImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setThumbImage(_:for:)),image,state.rawValue)
        return self
    }

    public func minimumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setMinimumTrackImage(_:for:)),image,state.rawValue)
        return self
    }
    
    public func maximumTrackImage(_ image: UIImage?, for state: UIControl.State)->Self{
        addAttribute(#selector(UISlider.setMaximumTrackImage(_:for:)),image,state.rawValue)
        return self
    }
    
}
