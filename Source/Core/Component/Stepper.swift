//
//  Stepper.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
class ArgoKitStepperNode: ArgoKitNode {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 94, height: 32)
    }
}
public struct Stepper:View{
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init<V>(value: @escaping @autoclosure () -> V, in bounds: @escaping @autoclosure () -> ClosedRange<V> = 0...1,step:Double = 1.0, onValueChanged: @escaping (_ value:Double) -> Void = { _ in })where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint{
        pNode = ArgoKitNode(viewClass:UIStepper.self, type: Self.self)
        
        self.stepValue(Double(value()))
        self.minimumValue(Double(bounds().lowerBound))
        self.maximumValue(Double(bounds().upperBound))
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let stepper = obj as? UIStepper {
                onValueChanged(stepper.value)
            }
            return nil
        }, for: UIControl.Event.touchUpInside)
    }
}

extension Stepper{
    @available(*, deprecated, message: "Stepper does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Stepper does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
