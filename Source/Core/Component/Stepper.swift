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
    private let pNode:ArgoKitStepperNode
    public var node: ArgoKitNode?{
        pNode
    }
    
    public init(stepValue: @escaping @autoclosure () -> Double, in bounds: @escaping @autoclosure () -> ClosedRange<Double> = 0...1, onValueChanged: @escaping (_ value:Double) -> Void = { _ in }){
        pNode = ArgoKitStepperNode(viewClass:UIStepper.self, type: Self.self)
        
        self.stepValue(stepValue())
        self.minimumValue(bounds().lowerBound)
        self.maximumValue(bounds().upperBound)
        
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
