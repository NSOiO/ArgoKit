//
//  Gesture.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation

@propertyWrapper
public class GestureAction<Value>{
    private var _value: Value?
   
    public init() {}
    public init(wrappedValue value: Value?){
        self._value = value
    }
    public var projectedValue: GestureAction<Value> {
        return self
    }
    public var wrappedValue: Value? {
        get {
            return _value
        }
        set {
            _value = newValue
        }
    }
}
    

public protocol Gesture{
    var gesture:UIGestureRecognizer{get}
    var action:(UIGestureRecognizer)->Void{get}
}
public extension Gesture{
    var action:(UIGestureRecognizer)->Void{ {value in}}
}

public struct TapGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private let pTapGesture:UITapGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pTapGesture
    }
    public init(numberOfTaps:Int = 1,numberOfTouches: Int = 1,onTapGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onTapGesture
        pTapGesture = UITapGestureRecognizer()
        pTapGesture.numberOfTapsRequired = numberOfTaps
        pTapGesture.numberOfTouchesRequired = numberOfTouches
    }
}

public struct LongPressGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private var pLongPressGesture:UILongPressGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pLongPressGesture
    }
    public init(numberOfTaps:Int = 0, numberOfTouches:Int = 1,minimumPressDuration:TimeInterval = 0.5,allowableMovement:CGFloat = 10,onLongPressGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onLongPressGesture
        pLongPressGesture = UILongPressGestureRecognizer()
        pLongPressGesture.numberOfTapsRequired = numberOfTaps
        pLongPressGesture.numberOfTouchesRequired = numberOfTouches
        pLongPressGesture.minimumPressDuration = minimumPressDuration
        pLongPressGesture.allowableMovement = allowableMovement
    }
}


public struct PanGesture:Gesture {
    public enum PanGestureDirection {
        case left
        case right
        case top
        case bottom
    }
    
    public typealias ObserverBeganAction = (_ gesture:UIPanGestureRecognizer,_ location:CGPoint,_ velocity:CGPoint,_ direction:PanGestureDirection?)->Void
    
    public typealias ObserverAction = (_ gesture:UIPanGestureRecognizer,_ location:CGPoint,_ velocity:CGPoint)->Void
    
    private var pAction:((UIGestureRecognizer)->Void)?
    public var action: (UIGestureRecognizer) -> Void{
        pAction!
    }
    private var pPanGesture:UIPanGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pPanGesture
    }
    var onGestureAction:GestureAction<((_ gesture:UIPanGestureRecognizer)->Void)> = GestureAction<((_ gesture:UIPanGestureRecognizer)->Void)>()
    var beganAction:GestureAction<ObserverBeganAction> = GestureAction<ObserverBeganAction>()
    var movedAction:GestureAction<ObserverAction> = GestureAction<ObserverAction>()
    var endedAction:GestureAction<ObserverAction> = GestureAction<ObserverAction>()
    var cancelledAction:GestureAction<ObserverAction> = GestureAction<ObserverAction>()
    var moveView:GestureAction<Bool> = GestureAction<Bool>()
    public init(minimumNumberOfTouches:Int = 1,
                maximumNumberOfTouches:Int = Int(INT_MAX),
                onPanGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pPanGesture = UIPanGestureRecognizer()
        pPanGesture.minimumNumberOfTouches = minimumNumberOfTouches
        pPanGesture.maximumNumberOfTouches = maximumNumberOfTouches
        moveView.wrappedValue = false
        onGestureAction.wrappedValue = onPanGesture
        pAction = onAction()
       
    }
    func onAction()->((UIGestureRecognizer)->Void){
        return {gesture in
            if let gesture = gesture as? UIPanGestureRecognizer,let view = gesture.view {
               
                if let onPanGesture = onGestureAction.wrappedValue  {
                    onPanGesture(gesture)
                }
                let location = gesture.translation(in: view)
                let velocity = gesture.velocity(in: view)
                switch gesture.state {
                case .began:
                    let direction = moveDeriction(gesture)
                    if let beganAction = beganAction.wrappedValue {
                        beganAction(gesture,location,velocity,direction)
                    }
                    break
                case .changed:
                    if let movedAction = movedAction.wrappedValue {
                        movedAction(gesture,location,velocity)
                    }
                    if moveView.wrappedValue == true {
                        gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + location.x, y: (gesture.view?.center.y)! + location.y)
                        gesture.setTranslation(CGPoint.zero, in: gesture.view?.superview)
                    }
                    break
                case .ended:
                    if let endedAction = endedAction.wrappedValue {
                        endedAction(gesture,location,velocity)
                    }
                    break
                case .cancelled:
                    if let cancelledAction = cancelledAction.wrappedValue {
                        cancelledAction(gesture,location,velocity)
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    @discardableResult
    public func onBegan(_ action:@escaping ObserverBeganAction)->Self{
        beganAction.wrappedValue = action
        return self
    }
    @discardableResult
    public func onMoved(_ action:@escaping ObserverAction)->Self{
        movedAction.wrappedValue = action
        return self
    }
    @discardableResult
    public func onEnded(_ action:@escaping ObserverAction)->Self{
        endedAction.wrappedValue = action
        return self
    }
    @discardableResult
    public func onCancelled(_ action:@escaping ObserverAction)->Self{
        cancelledAction.wrappedValue = action
        return self
    }
    @discardableResult
    public func enabelGragView(_ value:Bool)->Self{
        moveView.wrappedValue = value
        return self
    }
    
    @discardableResult
    private func moveDeriction(_ gesture:UIPanGestureRecognizer)->PanGestureDirection?{
        if let view = gesture.view {
            let transP = gesture.translation(in: view)
            let velocityP  = gesture.velocity(in: view)
                switch gesture.state {
                case .began:
                    if transP.y >= 0 && velocityP.y > 0{
                        if abs(transP.x) <= abs(transP.y) {
                            return .bottom
                        }else if transP.x <= 0 && velocityP.x < 0{
                            return .left
                        }else{
                            return .right
                        }
                    }else{
                        if abs(transP.x) <= abs(transP.y){
                            return .top
                        }else if transP.x < 0 && velocityP.x < 0{
                            return .left
                        }else{
                            return .right
                        }
                    }
                default:
                    break
                }
        }
        return nil
    }
    
}

public struct PinchGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private var pPinchGesture:UIPinchGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pPinchGesture
    }
    public init(scale:CGFloat,onPinchGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onPinchGesture
        pPinchGesture = UIPinchGestureRecognizer()
        pPinchGesture.scale = scale
    }
}

public struct RotationGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private var pRotationGesture:UIRotationGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pRotationGesture
    }
    public init(rotation:CGFloat,onRotationGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onRotationGesture
        pRotationGesture = UIRotationGestureRecognizer()
        pRotationGesture.rotation = rotation
    }
}


public struct SwipeGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private var pSwipeGesture:UISwipeGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pSwipeGesture
    }
    public init(numberOfTouchesRequired:Int,direction:UISwipeGestureRecognizer.Direction,onSwipeGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onSwipeGesture
        pSwipeGesture = UISwipeGestureRecognizer()
        pSwipeGesture.direction = direction
    }
}

public struct ScreenEdgePanGesture:Gesture {
    private var pAction:(UIGestureRecognizer)->Void
    public var action: (UIGestureRecognizer) -> Void{
        pAction
    }
    private var pScreenEdgePanGesture:UIScreenEdgePanGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pScreenEdgePanGesture
    }
    public init(edges:UIRectEdge,onSwipeGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onSwipeGesture
        pScreenEdgePanGesture = UIScreenEdgePanGestureRecognizer()
        pScreenEdgePanGesture.edges = edges
    }
}
