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
    private var pStepper:UIStepper
    private var pNode:ArgoKitNode
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
        pStepper.addTarget(pNode, action: #selector(ArgoKitNode.nodeAction(_:)), for: UIControl.Event.valueChanged)
        pNode.setNodeActionBlock{items in
            for item in items{
                if item is UIStepper {
                    onValueChanged((item as! UIStepper).value)
                }
            }
        };
    }
}
