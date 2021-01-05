//
//  DatePicker.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
/**
Wrapper of UIDatePicker.
A control for the inputting of date and time values.

You can use a date picker to allow a user to enter either a point in time (calendar date, time value, or both) or a time interval (for example, for a timer). The date picker reports interactions to its associated target object.
To add a date picker to your interface:
Set the date picker mode at creation time.
Supply additional configuration options such as minimum and maximum dates if required.
Connect an action method to the date picker.
Set up Auto Layout rules to govern the position of the date picker in your interface.
You use a date picker only for handling the selection of times and dates. If you want to handle the selection of arbitrary items from a list, use a UIPickerView object.
 
 ```
 DatePicker{ date in
     print("\(date)")
 }
 .width(300)
 .height(100)
 ```
 */
public struct DatePicker:View{
    public var body: View{
        ViewEmpty()
    }
    
    private let pNode:ArgoKitNode
    /// The node behind the control
    public var node: ArgoKitNode?{
        pNode
    }
    /// The type of the node
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    /// init DatePicker
    /// - Parameter onDateChange: dateChange callback
    public init(onDateChange:@escaping(_ onSelectedData:Date)->Void){
        pNode = ArgoKitNode(viewClass: UIDatePicker.self)
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let dataPicker = obj as? UIDatePicker {
                onDateChange(dataPicker.date)
            }
            return nil
        }, for: UIControl.Event.valueChanged)
    }
}
extension DatePicker{
    /// The current style of the date picker.
    /// - Returns: current style
    @available(iOS 13.4, *)
    public func datePickerStyle()->UIDatePickerStyle{
        if let view = self.node?.view as? UIDatePicker{
            return view.datePickerStyle
        }
        return .automatic
    }
}


extension DatePicker{
   @available(*, deprecated, message: "DatePicker does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "DatePicker does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
