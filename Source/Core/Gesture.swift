//
//  Gesture.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation

/// The base protocol for concrete gesture recognizers.
public protocol Gesture {
    var gesture: UIGestureRecognizer { get }
    var action: (UIGestureRecognizer) -> Void { get }
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
public struct PanGesture: Gesture {
    public typealias ObserverAction = ((_ gesture:UIPanGestureRecognizer,_ location:CGPoint,_ velocity:CGPoint)->Void)?
    private var pAction: (UIGestureRecognizer) -> Void
    private var pPanGesture: UIPanGestureRecognizer
    
    /// The action to handle the gesture recognized by the receiver.
    public var action: (UIGestureRecognizer) -> Void {
        pAction
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
    ///   - began: The action to handle the gesture recognized by the receiver when state is began.
    ///   - moved: The action to handle the gesture recognized by the receiver when state is changed.
    ///   - ended: The action to handle the gesture recognized by the receiver when state is ended.
    ///   - cancelled: The action to handle the gesture recognized by the receiver when state is cancelled.
    public init(minimumNumberOfTouches:Int = 1,
                maximumNumberOfTouches:Int = Int(INT_MAX),
                onPanGesture: @escaping (_ gesture:UIGestureRecognizer) -> Void,
                began:ObserverAction = nil,
                moved:ObserverAction = nil,
                ended: ObserverAction = nil,
                cancelled:ObserverAction = nil) {
    
        pAction = { gesture in
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
        pPanGesture = UIPanGestureRecognizer()
        pPanGesture.minimumNumberOfTouches = minimumNumberOfTouches
        pPanGesture.maximumNumberOfTouches = maximumNumberOfTouches
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
