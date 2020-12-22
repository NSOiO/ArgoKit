//
//  ViewGesture.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/22.
//

import Foundation
extension View{
    @discardableResult
    public func gesture(gesture:Gesture)->Self{
        gesture.gesture.isEnabled = true
        addAttribute(#selector(setter: UIView.isUserInteractionEnabled),true)
        addAttribute(#selector(UIView.addGestureRecognizer(_:)),gesture.gesture)
        self.node?.addTarget(gesture.gesture, for: UIControl.Event.valueChanged) { (obj, paramter) in
            if let gestureRecognizer = obj as? UIGestureRecognizer {
                gesture.action(gestureRecognizer)
            }
            return nil
        }
        return self
    }
    @discardableResult
    public func removeGesture(gesture:Gesture)->Self{
        self.node?.view?.removeGestureRecognizer(gesture.gesture)
        return self
    }
}

extension View{
    @discardableResult
    public func onTapGesture(numberOfTaps: Int = 1, numberOfTouches: Int = 1,action:@escaping ()->Void)->Self{
        let gesture = TapGesture(numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
    @discardableResult
    public func onLongPressGesture(numberOfTaps:Int = 0, numberOfTouches:Int = 1,minimumPressDuration:TimeInterval = 0.5,allowableMovement:CGFloat = 10,action:@escaping ()->Void)->Self{
        let gesture = LongPressGesture(numberOfTaps:numberOfTaps,numberOfTouches:numberOfTouches,minimumPressDuration:minimumPressDuration,allowableMovement:allowableMovement) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
}
