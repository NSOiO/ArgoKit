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
    /// Set the mode of the date picker.
    ///
    ///Use this property to change the type of information displayed by the date picker. It determines whether the date picker allows selection of a date, a time, both date and time, or a countdown time. The default mode is UIDatePicker.Mode.dateAndTime. See UIDatePicker.Mode for a list of mode constants.
    /// - Parameter value: the mode, default is UIDatePickerModeDateAndTime
    /// - Returns: Self
    @discardableResult
    public func datePickerMode(_ value:UIDatePicker.Mode)->Self{
        addAttribute(#selector(setter:UIDatePicker.datePickerMode),value.rawValue)
        return self
    }

    /// Set the  locale used by the date picker.
    ///
    /// The default value is the current locale as returned by the current property of NSLocale, or the locale used by the date picker’s calendar. Locales encapsulate information about facets of a language or culture, such as the way dates are formatted
    /// - Parameter value: the local value.
    /// - Returns: Self
    @discardableResult
    public func locale(_ value:Locale?)->Self{
        addAttribute(#selector(setter:UIDatePicker.locale),value)
        return self
    }
    
    /// Set the calendar used for the date picker.
    ///
    /// The default value of this property corresponds to the user’s current calendar as configured in Settings. This is equivalent to the value returned by calling the NSCalendar class method current. Setting this property to nil is equivalent to setting it to its default value.
    /// - Parameter value: the calendar
    /// - Returns: Self
    @discardableResult
    public func calendar(_ value:Calendar!)->Self{
        addAttribute(#selector(setter:UIDatePicker.calendar),value)
        return self
    }
    
    /// Set  time zone reflected in the date displayed by the date picker.
    ///
    /// The default value is nil, which tells the date picker to use the current time zone as returned by local (NSTimeZone) or the time zone used by the date picker’s calendar.
    /// - Parameter value: the timezone
    /// - Returns: Self
    @discardableResult
    public func timeZone(_ value:TimeZone?)->Self{
        addAttribute(#selector(setter:UIDatePicker.timeZone),value)
        return self
    }
    
    /// Set the date displayed by the date picker.
    ///
    /// Use this property to get and set the currently selected date. The default value of this property is the date when the UIDatePicker object is created. Setting this property animates the date picker by spinning the wheels to the new date and time; if you don't want any animation to occur when you set the date, use the setDate(_:animated:) method, passing false for the animated parameter. This behavior of this property is undefined when the mode is set to UIDatePicker.Mode.countDownTimer; refer instead to the countDownDuration property.
    /// - Parameter value: the date
    /// - Returns: Self
    @discardableResult
    public func date(_ value:Date)->Self{
        addAttribute(#selector(setter:UIDatePicker.date),value)
        return self
    }
    
    /// Set minimum date that a date picker can show.
    ///
    /// Use this property to configure the minimum date that is selected in the date picker interface. The property contains an NSDate object or nil (the default), which means no minimum date. This property, along with the maximumDate property, lets you specify a valid date range. If the minimum date value is greater than the maximum date value, both properties are ignored. The minimum and maximum dates are also ignored in the countdown-timer mode (UIDatePicker.Mode.countDownTimer).
    /// - Parameter value: the min date
    /// - Returns: Self
    @discardableResult
    public func minimumDate(_ value:Date?)->Self{
        addAttribute(#selector(setter:UIDatePicker.minimumDate),value)
        return self
    }
    
    /// Set maximum date that a date picker can show.
    ///
    ///Use this property to configure the maximum date that is selected in the date picker interface. The property contains an NSDate object or nil (the default), which means no maximum date. This property, along with the minimumDate property, lets you specify a valid date range. If the minimum date value is greater than the maximum date value, both properties are ignored. The minimum and maximum dates are also ignored in the countdown-timer mode (UIDatePicker.Mode.countDownTimer).
    /// - Parameter value: the max date
    /// - Returns: Self
    @discardableResult
    public func maximumDate(_ value:Date?)->Self{
        addAttribute(#selector(setter:UIDatePicker.maximumDate),value)
        return self
    }
    
    /// Set value displayed by the date picker when the mode property is set to show a countdown time.
    ///
    ///Use this property to get and set the currently selected value when the date picker’s mode property is set to UIDatePicker.Mode.countDownTimer. This property is of type TimeInterval and therefore is measured in seconds, although the date picker displays only hours and minutes. If the mode of the date picker is not UIDatePicker.Mode.countDownTimer, this value is undefined; refer instead to the date property. The default value is 0.0 and the maximum value is 23:59 (86,340 seconds).
    /// - Parameter value: currently selected value
    /// - Returns: Self
    @discardableResult
    public func countDownDuration(_ value:TimeInterval)->Self{
        addAttribute(#selector(setter:UIDatePicker.countDownDuration),value)
        return self
    }

    /// Set the interval at which the date picker should display minutes.
    ///
    /// Use this property to set the interval displayed by the minutes wheel (for example, 15 minutes). The interval value must be evenly divided into 60; if it is not, the default value is used. The default and minimum values are 1; the maximum value is 30.
    /// - Parameter value: interval displayed by the minutes wheel
    /// - Returns: Self
    @discardableResult
    public func minuteInterval(_ value:Int)->Self{
        addAttribute(#selector(setter:UIDatePicker.minuteInterval),value)
        return self
    }
    
    /// Sets the date to display in the date picker, with an option to animate the setting.
    ///
    ///
    /// - Parameters:
    ///   - date: An NSDate object representing the new date to display in the date picker.
    ///   - animated: true to animate the setting of the new date, otherwise false. The animation rotates the wheels until the new date and time is shown under the highlight rectangle.
    /// - Returns: Self
    @discardableResult
    public func setDate(_ date: Date, animated: Bool)->Self{
        addAttribute(#selector(UIDatePicker.setDate),date,animated)
        return self
    }
    
    /// Sets preferred style of the date picker.
    ///
    /// Use this property to specify the display style that you prefer. If the style changes, the date picker may generate a layout pass to update the display.
    /// - Parameter value:preferred style
    /// - Returns: Self
    @available(iOS 13.4, *)
    @discardableResult
    public func preferredDatePickerStyle(_ value:UIDatePickerStyle)->Self{
        addAttribute(#selector(setter:UIDatePicker.preferredDatePickerStyle),value)
        return self
    }

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
   @available(*, unavailable, message: "DatePicker does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, unavailable, message: "DatePicker does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
