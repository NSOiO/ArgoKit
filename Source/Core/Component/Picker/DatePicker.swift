//
//  DatePicker.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public struct DatePicker:View{
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
    // default is UIDatePickerModeDateAndTime
    @discardableResult
    public func datePickerMode(_ value:UIDatePicker.Mode)->Self{
        addAttribute(#selector(setter:UIDatePicker.datePickerMode),value.rawValue)
        return self
    }
    // default is [NSLocale currentLocale]. setting nil returns to default
    @discardableResult
    public func locale(_ value:Locale?)->Self{
        addAttribute(#selector(setter:UIDatePicker.locale),value)
        return self
    }
    // default is [NSCalendar currentCalendar]. setting nil returns to default
    @discardableResult
    public func calendar(_ value:Calendar!)->Self{
        addAttribute(#selector(setter:UIDatePicker.calendar),value)
        return self
    }
    // default is nil. use current time zone or time zone from calendar
    @discardableResult
    public func timeZone(_ value:TimeZone?)->Self{
        addAttribute(#selector(setter:UIDatePicker.timeZone),value)
        return self
    }
    // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
    @discardableResult
    public func date(_ value:Date)->Self{
        addAttribute(#selector(setter:UIDatePicker.date),value)
        return self
    }
    // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    @discardableResult
    public func minimumDate(_ value:Date?)->Self{
        addAttribute(#selector(setter:UIDatePicker.minimumDate),value)
        return self
    }
    // default is nil
    @discardableResult
    public func maximumDate(_ value:Date?)->Self{
        addAttribute(#selector(setter:UIDatePicker.maximumDate),value)
        return self
    }
    // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
    @discardableResult
    public func countDownDuration(_ value:TimeInterval)->Self{
        addAttribute(#selector(setter:UIDatePicker.countDownDuration),value)
        return self
    }
    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
    @discardableResult
    public func minuteInterval(_ value:Int)->Self{
        addAttribute(#selector(setter:UIDatePicker.minuteInterval),value)
        return self
    }
    // if animated is YES, animate the wheels of time to display the new date
    @discardableResult
    public func setDate(_ date: Date, animated: Bool)->Self{
        addAttribute(#selector(UIDatePicker.setDate),date,animated)
        return self
    }
    /// Request a style for the date picker. If the style changed, then the date picker may need to be resized and will generate a layout pass to display correctly.
    @available(iOS 13.4, *)
    @discardableResult
    public func preferredDatePickerStyle(_ value:UIDatePickerStyle)->Self{
        addAttribute(#selector(setter:UIDatePicker.preferredDatePickerStyle),value)
        return self
    }

    /// The style that the date picker is using for its layout. This property always returns a concrete style (never automatic).
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
