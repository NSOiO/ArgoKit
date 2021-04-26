//
//  Toggle.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
class ArgoKitToggleNode: ArgoKitNode {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // （IOS7,*)
        return CGSize(width: 51, height: 31)
    }
}
public struct Toggle:View{
    private let pNode:ArgoKitToggleNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init(_ isOn: @escaping @autoclosure () -> Bool,action:@escaping (_ isOn:Bool)->Void){
        pNode = ArgoKitToggleNode(viewClass:UISwitch.self, type: Self.self)
        self.setOn(isOn(), animated: false)
        pNode.addAction({ (obj, paramter) -> Any? in
            if let swit = obj as? UISwitch {
                action(swit.isOn)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}

extension Toggle{
   @available(*, deprecated, message: "Toggle does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "Toggle does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
