//
//  Gesture.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation

@propertyWrapper
public class GestureValue<Value> {
    private var _value: Value? = nil
    
    public init() {}
    public init(wrappedValue value: Value?) {
        self._value = value
    }
    
    public var projectedValue: GestureValue<Value> {
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
    public typealias ObserverAction = (_ gesture:UIPanGestureRecognizer,_ location:CGPoint,_ velocity:CGPoint)->Void
//    private var onBeganAction:ObserverAction?
    @GestureValue private var onBeganAction:ObserverAction?
    private var onChangedAction:ObserverAction?
    private var onEndedAction:ObserverAction?
    private var onCancelledAction:ObserverAction?
    
    private var pAction: ((UIGestureRecognizer)->Void)?
    public var action: (UIGestureRecognizer) -> Void{
        pAction!
    }
    
    private var pPanGesture:UIPanGestureRecognizer
    public var gesture: UIGestureRecognizer{
        pPanGesture
    }
    public init(minimumNumberOfTouches:Int = 1,
                maximumNumberOfTouches:Int = Int(INT_MAX),
                onPanGesture:@escaping (_ gesture:UIGestureRecognizer)->Void,
                began:ObserverAction? = nil,
                moved:ObserverAction? = nil,
                ended: ObserverAction? = nil,
                cancelled:ObserverAction? = nil){
        pPanGesture = UIPanGestureRecognizer()
        pPanGesture.minimumNumberOfTouches = minimumNumberOfTouches
        pPanGesture.maximumNumberOfTouches = maximumNumberOfTouches
        pAction = onPanGesture
        
        pAction = {gesture in
            onPanGesture(gesture)
            if let gesture = gesture as? UIPanGestureRecognizer,let view = gesture.view {
                let location = gesture.translation(in: view)
                let velocity = gesture.velocity(in: view)
                switch gesture.state {
                case .began:
                    if let began = began {
                        began(gesture,location,velocity)
                    }
                    break
                case .changed:
                    if let moved = moved {
                        moved(gesture,location,velocity)
                    }
                    break
                case .ended:
                    if let ended = ended {
                        ended(gesture,location,velocity)
                    }
                    break
                case .cancelled:
                    if let cancelled = cancelled {
                        cancelled(gesture,location,velocity)
                    }
                    break
                default:
                    break
                }
            }
        }

    }
    
    private func action(gesture:UIGestureRecognizer){
        
    }
    
    @discardableResult
    public func onBegan(_ action:ObserverAction?) -> Self{
        self.onBeganAction = action
        return self
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
