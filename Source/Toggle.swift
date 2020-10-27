//
//  Toggle.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
public struct Toggle:View{
    public var body: View{
        self
    }
    private var pSwitch:UISwitch
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init(_ isOn:Bool,action:@escaping (_ isOn:Bool)->Void){
        pSwitch = UISwitch()
        pNode = ArgoKitNode(view: pSwitch);
        pSwitch.setOn(isOn, animated: false)
        
        pSwitch.addTarget(pNode, action:#selector(ArgoKitNode.nodeAction(_:)), for: UIControl.Event.valueChanged)
        pNode.setNodeActionBlock{items in
            for item in items{
                if item is UISwitch {
                    action((item as! UISwitch).isOn)
                }
            }
        };
    }
}

extension Toggle{
    public func onTintColor(_ value:UIColor?)->Self{
        pSwitch.onTintColor = value
        return self
    }
    public func thumbTintColor(_ value:UIColor?)->Self{
        pSwitch.thumbTintColor = value
        return self
    }
    
    public func onImage(_ value:UIImage?)->Self{
        pSwitch.onImage = value
        return self
    }
    
    public func offImage(_ value:UIImage?)->Self{
        pSwitch.offImage = value
        return self
    }
    
    @available(iOS 14.0, *)
    public func title(_ value:String?)->Self{
        pSwitch.title = value
        return self
    }
    
    @available(iOS 14.0, *)
    public func preferredStyle(_ value:UISwitch.Style)->Self{
        pSwitch.preferredStyle = value
        return self
    }
    
    public func isOn(_ value:Bool)->Self{
        pSwitch.isOn = value
        return self
    }
    
    public func setOn(_ on: Bool, animated: Bool)->Self{
        pSwitch.setOn(on,animated: animated)
        return self
    }
}
