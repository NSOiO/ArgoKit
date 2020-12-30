//
//  Slider.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public struct Slider:View{
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
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
    @available(*, unavailable, message: "Slider does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, unavailable, message: "Slider does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
