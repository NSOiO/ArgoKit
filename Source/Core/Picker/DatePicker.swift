//
//  DatePicker.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation
public class DatePicker:View{
    public var body: View{
        ViewEmpty()
    }
    private let pDatePicker:UIDatePicker
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public init(onDateChange:@escaping(_ onSelectedData:Date)->Void){
        pDatePicker = UIDatePicker()
        pNode = ArgoKitNode(view: pDatePicker)
        
        pNode.addTarget(pDatePicker, for: UIControl.Event.valueChanged) { (obj, paramter) in
            if let dataPicker = obj as? UIDatePicker {
                onDateChange(dataPicker.date)
            }
            return nil
        }
    }
}
extension DatePicker{
    // default is UIDatePickerModeDateAndTime
    public func datePickerMode(_ value:UIDatePicker.Mode)->Self{
        pDatePicker.datePickerMode = value
        return self
    }
    // default is [NSLocale currentLocale]. setting nil returns to default
    public func locale(_ value:Locale?)->Self{
        pDatePicker.locale = value
        return self
    }
    // default is [NSCalendar currentCalendar]. setting nil returns to default
    public func calendar(_ value:Calendar!)->Self{
        pDatePicker.calendar = value
        return self
    }
    // default is nil. use current time zone or time zone from calendar
    public func timeZone(_ value:TimeZone?)->Self{
        pDatePicker.timeZone = value
        return self
    }
    // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
    public func date(_ value:Date)->Self{
        pDatePicker.date = value
        return self
    }
    // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    public func minimumDate(_ value:Date?)->Self{
        pDatePicker.minimumDate = value
        return self
    }
    // default is nil
    public func maximumDate(_ value:Date?)->Self{
        pDatePicker.maximumDate = value
        return self
    }
    // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
    public func countDownDuration(_ value:TimeInterval)->Self{
        pDatePicker.countDownDuration = value
        return self
    }
    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
    public func minuteInterval(_ value:Int)->Self{
        pDatePicker.minuteInterval = value
        return self
    }
    // if animated is YES, animate the wheels of time to display the new date
    public func setDate(_ date: Date, animated: Bool)->Self{
        pDatePicker.setDate(date,animated: animated)
        return self
    }
    /// Request a style for the date picker. If the style changed, then the date picker may need to be resized and will generate a layout pass to display correctly.
    @available(iOS 13.4, *)
    public func preferredDatePickerStyle(_ value:UIDatePickerStyle)->Self{
        pDatePicker.preferredDatePickerStyle = value
        return self
    }

    /// The style that the date picker is using for its layout. This property always returns a concrete style (never automatic).
    @available(iOS 13.4, *)
    public func datePickerStyle()->UIDatePickerStyle{
        return pDatePicker.datePickerStyle
    }
}
