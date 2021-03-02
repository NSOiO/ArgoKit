//
//  ViewGesture.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/22.
//

import Foundation

extension View {
    
    /// Adds the gesture to this View
    /// - Parameter gesture: The gesture that is added to this view.
    /// - Parameter enabled: The gesture is enabled.
    /// - Returns: Self
    @discardableResult
    public func gesture(_ gesture: @escaping @autoclosure () -> Gesture,enabled: @escaping @autoclosure () -> Bool = true) -> Self {
        return self.bindCallback({ [self] in
            let gesture_ = gesture()
            let isEnabled_ = enabled()
            gesture_.gesture.isEnabled = isEnabled_
            if isEnabled_ == false{
                removeGesture(gesture: gesture_)
                return;
            }
            addAttribute(#selector(setter: UIView.isUserInteractionEnabled),true)
            addAttribute(#selector(UIView.addGestureRecognizer(_:)),gesture_.gesture)
            self.node?.addTarget(gesture_.gesture, for: UIControl.Event.valueChanged) { (obj, paramter) in
                if let gestureRecognizer = obj as? UIGestureRecognizer {
                    gesture_.action(gestureRecognizer)
                }
                return nil
            }
        }, forKey: #function)
    }
    
    /// Removes the gesture from this view.
    /// - Parameter gesture: The gesture that is removed from this view.
    /// - Returns: Self
    @discardableResult
    public func removeGesture(gesture: Gesture) -> Self {
        self.node?.view?.removeGestureRecognizer(gesture.gesture)
        return self
    }
}

extension View{
    
    /// Adds tap gesture to this View
    /// - Parameters:
    ///   - numberOfTaps: The number of taps necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that the user must tap for gesture recognition.
    ///   -  enabled: The gesture is enabled,default is true
    ///   - action: The action to handle the gesture recognized by the receiver.
    /// - Returns: Self
    @discardableResult
    public func onTapGesture(numberOfTaps: Int = 1, numberOfTouches: Int = 1, enabled: @escaping @autoclosure () -> Bool = true,action: @escaping () -> Void) -> Self {
        let gesture = TapGesture(numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches) { gesture in
            action()
        }
        return self.gesture(gesture,enabled: enabled())
    }
    
    /// Adds long press gesture to this View
    /// - Parameters:
    ///   - numberOfTaps: The number of taps on the view necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that must touch the view for gesture recognition.
    ///   - minimumPressDuration: The minimum time that the user must press on the view for the gesture to be recognized.
    ///   - allowableMovement: The maximum movement of the fingers on the view before the gesture fails.
    ///   -  enabled: The gesture is enabled,default is true
    ///   - action: The action to handle the gesture recognized by the receiver.
    /// - Returns: Self
    @discardableResult
    public func onLongPressGesture(numberOfTaps: Int = 0, numberOfTouches: Int = 1, minimumPressDuration: TimeInterval = 0.5, allowableMovement: CGFloat = 10,enabled: @escaping @autoclosure () -> Bool = true ,action:@escaping () -> Void ) -> Self {
        let gesture = LongPressGesture(numberOfTaps:numberOfTaps,numberOfTouches:numberOfTouches,minimumPressDuration:minimumPressDuration,allowableMovement:allowableMovement) { gesture in
            action()
        }
        return self.gesture(gesture,enabled: enabled())
    }
}
