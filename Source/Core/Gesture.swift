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
    
/// The base protocol for concrete gesture recognizers.
public protocol Gesture{
    var gesture:UIGestureRecognizer {get}
    var action:(UIGestureRecognizer) ->Void {get}
}

public extension Gesture {
    var action: (UIGestureRecognizer) -> Void { {value in} }
}

/// Wrapper of UITapGestureRecognizer
/// A discrete gesture recognizer that interprets single or multiple taps.
public struct TapGesture: Gesture {
    
    private var pAction: (UIGestureRecognizer) -> Void
    private let pTapGesture: UITapGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the TapGesture.
    public var gesture: UIGestureRecognizer {
        pTapGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - numberOfTaps: The number of taps necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that the user must tap for gesture recognition.
    ///   - onTapGesture: The action to handle the gesture recognized by the receiver.
    public init(numberOfTaps: Int = 1, numberOfTouches: Int = 1, onTapGesture: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
        pAction = onTapGesture
        pTapGesture = UITapGestureRecognizer()
        pTapGesture.numberOfTapsRequired = numberOfTaps
        pTapGesture.numberOfTouchesRequired = numberOfTouches
    }
}

/// Wrapper of UILongPressGestureRecognizer
/// A discrete gesture recognizer that interprets long-press gestures.
public struct LongPressGesture: Gesture {
    private var pAction: (UIGestureRecognizer) -> Void
    private var pLongPressGesture: UILongPressGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the LongPressGesture.
    public var gesture: UIGestureRecognizer {
        pLongPressGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - numberOfTaps: The number of taps on the view necessary for gesture recognition.
    ///   - numberOfTouches: The number of fingers that must touch the view for gesture recognition.
    ///   - minimumPressDuration: The minimum time that the user must press on the view for the gesture to be recognized.
    ///   - allowableMovement: The maximum movement of the fingers on the view before the gesture fails.
    ///   - onLongPressGesture: The action to handle the gesture recognized by the receiver.
    public init(numberOfTaps: Int = 0, numberOfTouches: Int = 1, minimumPressDuration: TimeInterval = 0.5, allowableMovement: CGFloat = 10, onLongPressGesture: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
        pAction = onLongPressGesture
        pLongPressGesture = UILongPressGestureRecognizer()
        pLongPressGesture.numberOfTapsRequired = numberOfTaps
        pLongPressGesture.numberOfTouchesRequired = numberOfTouches
        pLongPressGesture.minimumPressDuration = minimumPressDuration
        pLongPressGesture.allowableMovement = allowableMovement
    }
}

/// Wrapper of UIPanGestureRecognizer
/// A discrete gesture recognizer that interprets panning gestures.
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
    private var pPanGesture: UIPanGestureRecognizer
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction!
    }
    
    /// The gesture behind the PanGesture.
    public var gesture: UIGestureRecognizer {
        pPanGesture
    }
    
        /// Initializer
        /// - Parameters:
        ///   - minimumNumberOfTouches: The minimum number of fingers that can touch the view for gesture recognition.
        ///   - maximumNumberOfTouches: The maximum number of fingers that can touch the view for gesture recognition.
        ///   - onPanGesture: The action to handle the gesture recognized by the receiver.
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

/// Wrapper of UIPinchGestureRecognizer
/// A discrete gesture recognizer that interprets pinching gestures involving two touches.
public struct PinchGesture: Gesture {
    private var pAction: (UIGestureRecognizer) -> Void
    private var pPinchGesture: UIPinchGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the PinchGesture.
    public var gesture: UIGestureRecognizer {
        pPinchGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - scale: The scale factor relative to the points of the two touches in screen coordinates.
    ///   - onPinchGesture: The action to handle the gesture recognized by the receiver.
    public init(scale:CGFloat,onPinchGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onPinchGesture
        pPinchGesture = UIPinchGestureRecognizer()
        pPinchGesture.scale = scale
    }
}

/// Wrapper of UIRotationGestureRecognizer
/// A discrete gesture recognizer that interprets rotation gestures involving two touches.
public struct RotationGesture: Gesture {
    private var pAction: (UIGestureRecognizer) -> Void
    private var pRotationGesture: UIRotationGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the RotationGesture.
    public var gesture: UIGestureRecognizer {
        pRotationGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - rotation: The rotation of the gesture in radians.
    ///   - onRotationGesture: The action to handle the gesture recognized by the receiver.
    public init(rotation: CGFloat, onRotationGesture: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
        pAction = onRotationGesture
        pRotationGesture = UIRotationGestureRecognizer()
        pRotationGesture.rotation = rotation
    }
}

/// Wrapper of UISwipeGestureRecognizer
/// A discrete gesture recognizer that interprets swiping gestures in one or more directions.
public struct SwipeGesture: Gesture {
    private var pAction: (UIGestureRecognizer) -> Void
    private var pSwipeGesture: UISwipeGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the SwipeGesture.
    public var gesture: UIGestureRecognizer {
        pSwipeGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - numberOfTouchesRequired: The number of touches necessary for swipe recognition.
    ///   - direction: The permitted direction of the swipe for this gesture recognizer.
    ///   - onSwipeGesture: The action to handle the gesture recognized by the receiver.
    public init(numberOfTouchesRequired: Int, direction: UISwipeGestureRecognizer.Direction, onSwipeGesture: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
        pAction = onSwipeGesture
        pSwipeGesture = UISwipeGestureRecognizer()
        pSwipeGesture.numberOfTouchesRequired = numberOfTouchesRequired
        pSwipeGesture.direction = direction
    }
}

/// Wrapper of UIScreenEdgePanGestureRecognizer
/// A discrete gesture recognizer that interprets panning gestures that start near an edge of the screen.
public struct ScreenEdgePanGesture: Gesture {
    private var pAction: (UIGestureRecognizer) -> Void
    private var pScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
    }
    
    /// The gesture behind the ScreenEdgePanGesture.
    public var gesture: UIGestureRecognizer {
        pScreenEdgePanGesture
    }
    
    /// Initializer
    /// - Parameters:
    ///   - edges: The acceptable starting edges for the gesture.
    ///   - onSwipeGesture: The action to handle the gesture recognized by the receiver.
    public init(edges:UIRectEdge,onSwipeGesture:@escaping (_ gesture:UIGestureRecognizer)->Void){
        pAction = onSwipeGesture
        pScreenEdgePanGesture = UIScreenEdgePanGestureRecognizer()
        pScreenEdgePanGesture.edges = edges
    }
}
