//
//  Animation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation
import ArgoAnimation

public typealias StartCallback = (AnimationBasic) -> Void
public typealias PauseCallback = (AnimationBasic) -> Void
public typealias ResumeCallback = (AnimationBasic) -> Void
public typealias RepeatCallback = (AnimationBasic, Int) -> Void
public typealias FinishCallback = (AnimationBasic, Bool) -> Void

/// The abstract superclass for animations in Argo Animation.
/// You do not create instance of CAAnimation: to animate UIKit view or ArgoKit objects, create instances of the concrete subclasses Animation, SpringAnimation, or AnimationGroup.
public class AnimationBasic: NSObject {
    var serial = false
    var animPaused = false
    var resetOnStop: Bool = false
    
    weak var target: UIView?
    var delay: Float?
    var repeatCount: Int?
    var repeatForever: Bool?
    var autoReverse: Bool?
    
    var startCallback: StartCallback?
    var pauseCallback: PauseCallback?
    var resumeCallback: ResumeCallback?
    var repeatCallback: RepeatCallback?
    var finishCallback: FinishCallback?
    
    /// Attach this animation to the specific UIKit view.
    /// - Parameter view: The UIKit view that attachs this animation.
    /// - Returns: Self
    @discardableResult
    func attach(_ view: UIView) -> Self {
        return self
    }
    
    /// Updates this animation.
    /// - Parameters:
    ///   - progress: The progess of the animation. 0.0~1.0
    /// - Returns: Self
    @discardableResult
    func update(progress: Float) -> Self {
        return self
    }
    
    /// Sets a Boolean value that controls whether this animation is removed from the presentation when the animation is completed.
    /// - Parameter reset: A Boolean value that controls whether this animation is removed from the presentation when the animation is completed.
    /// - Returns: Self
    @discardableResult
    public func resetOnStop(_ reset: Bool) -> Self {
        resetOnStop = reset
        return self
    }
    
    /// Set the order of animations.
    /// - serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    /// - Returns: Self
    @discardableResult
    public func serial(_ serial: Bool) -> Self {
        self.serial = serial
        return self
    }
    
    /// Starts this animation.
    /// - Parameter serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    func start() {
        
    }
    
    /// Pauses this animation.
    func pause() {
        
    }
    
    /// Resumes this animation.
    func resume() {
        
    }
    
    /// Stops this animation.
    func stop() {
        
    }

    func prepareAnimation() {
        assertionFailure("Subclass should override this method.")
    }
    
    func rawAnimation() -> MLAAnimation? {
        assertionFailure("Subclass should override this method.")
        return nil
    }
}

/// An optional timing function defining the pacing of the animation.
public enum AnimationTimingFunc {
    
    /// The default timing function. Use this function to ensure that the timing of your animations matches that of most animations.
    case defaultValue
    
    /// Linear pacing, which causes an animation to occur evenly over its duration.
    case linear
    
    /// Ease-in pacing, which causes an animation to begin slowly and then speed up as it progresses.
    case easeIn
    
    /// Ease-out pacing, which causes an animation to begin quickly and then slow as it progresses.
    case easeOut
    
    /// Ease-in-ease-out pacing, which causes an animation to begin slowly, accelerate through the middle of its duration, and then slow again before completing.
    case easeInEaseOut
}

/// An optional type of the animation.
public enum AnimationType {
    
    /// Alpha animation.
    case alpha
    
    /// Color animation.
    case color, textColor
    
    /// Position animation.
    case position, positionX, positionY
    
    /// Scale animation.
    case scale, scaleX, scaleY
    
    /// Rotation animation.
    case rotation, rotationX, rotationY
    
    /// UIScrollView contentOffset animation.
    case contentOffset
}

/// The basic class for single-keyframe animations.
///
/// ```
///         Animation(type: .color)
///             .duration(duration)
///             .from(UIColor)
///             .to(UIColor)
///
///         Animation(type: .textColor)
///             .duration(duration)
///             .from(UIColor)
///             .to(UIColor)
///
///         Animation(type: .position)
///             .duration(duration)
///             .from(x, y)
///             .to(x, y)
///             .resetOnStop(true)
///
///         Animation(type: .rotation)
///             .duration(duration)
///             .from(fromValue)
///             .to(toValue)
///
///         Animation(type: .scale)
///             .duration(duration)
///             .from(xScale, yScale)
///             .to(xScale, yScale)
///
///         Animation(type: .contentOffset)
///             .duration(duration)
///             .from(x, y)
///             .to(x, y)
/// ```
///
public class Animation : AnimationBasic {

    // MARK: - Private
    private var duration: Float?
    private var timingFunc = AnimationTimingFunc.defaultValue
    private let type: AnimationType!
    private var from: Any?, to: Any?
    private var animation: MLAValueAnimation?
    
    /// Initializer
    /// - Parameter type: The type of the animation.
    required public init(type: AnimationType) {
        self.type = type
    }
    
    // MARK: - Public
    
    /// Specifies the basic duration of the animation, in seconds.
    /// - Parameter duration: The basic duration of the animation, in seconds.
    /// - Returns: Self
    @discardableResult
    public func duration(_ duration: Float) -> Self {
        self.duration = duration
        return self
    }
    
    /// Specifies the amount of time (measured in seconds) to wait before beginning the animations.
    /// - Parameter delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    /// - Returns: Self
    @discardableResult
    public func delay(_ delay: Float) -> Self {
        self.delay = delay
        return self
    }
    
    /// Determines the number of times the animation will repeat.
    /// - Parameter count: The number of times the animation will repeat.
    /// - Returns: Self
    @discardableResult
    public func repeatCount(_ count: Int) -> Self {
        self.repeatCount = count
        return self
    }
    
    /// Sets a Boolean value that controls whether that repeats this animation forever.
    /// - Parameter forever: A Boolean value that controls whether that repeats this animation forever.
    /// - Returns: Self
    @discardableResult
    public func repeatForever(_ forever: Bool) -> Self {
        self.repeatForever = forever
        return self
    }
    
    /// Determines if the animation plays in the reverse upon completion.
    /// - Parameter reverse: true if you want to this animaiton plays in the reverse upon completion.
    /// - Returns: Self
    @discardableResult
    public func autoReverse(_ reverse: Bool) -> Self {
        self.autoReverse = reverse
        return self
    }
    
    /// Sets an optional timing function defining the pacing of the animation.
    /// - Parameter timing: An optional timing function defining the pacing of the animation.
    /// - Returns: Self
    @discardableResult
    public func timingFunc(_ timing: AnimationTimingFunc) -> Self {
        self.timingFunc = timing
        return self
    }
    
    /// Defines the value the animation uses to start interpolation.
    /// - Parameter values: The value the animation uses to start interpolation.
    /// - Returns: Self
    @discardableResult
    func from(_ values: [Any]) -> Self {
        if let fromValue = handleValues(values) {
            from = fromValue
            animation?.fromValue = fromValue
        }
        return self
    }
    
    /// Defines the float value the animation uses to start interpolation.
    /// - Parameter v1: The float value the animation uses to start interpolation.
    /// - Returns: Self
    @discardableResult
    public func from(_ v1: Float) -> Self {
        return from([v1])
    }
    
    /// Defines the point value the animation uses to start interpolation.
    /// - Parameters:
    ///   - v1: The x of the point.
    ///   - v2: The y of the point.
    /// - Returns: Self
    @discardableResult
    public func from(_ v1: Float, _ v2: Float) -> Self {
        return from([v1, v2])
    }
    
    /// Defines the point value the animation uses to start interpolation.
    /// - Parameter tuple: The tuple value that describes the point. (x, y)
    /// - Returns: self
    @discardableResult
    public func from(_ tuple:(Float, Float)) -> Self {
        return from([tuple.0, tuple.1])
    }
    
    /// Defines the color value the animation uses to start interpolation.
    /// - Parameter tuple: The tuple value that describes the color. (red, green, blue, alpha) 0~ 255
    /// - Returns: Self
    @discardableResult
    public func from(_ tuple:(Float, Float, Float, Float)) -> Self {
        return from([tuple.0, tuple.1, tuple.2, tuple.3])
    }
    
    /// Defines the color value the animation uses to start interpolation.
    /// - Parameters:
    ///   - v1: The red value of the color object. 0~ 255
    ///   - v2: The green value of the color object. 0~ 255
    ///   - v3: The blue value of the color object. 0~ 255
    ///   - v4: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func from(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return from([v1, v2, v3, v4])
    }
    
    /// Defines the color value the animation uses to start interpolation.
    /// - Parameter color: The color value the animation uses to start interpolation.
    /// - Returns: Self.
    @discardableResult
    public func from(_ color: UIColor) -> Self {
        return from([color])
    }
    
    /// Defines the value the animation uses to end interpolation.
    /// - Parameter values: The value the animation uses to end interpolation.
    /// - Returns: Self
    @discardableResult
    func to(_ values: [Any]) -> Self {
        if let toValue = handleValues(values) {
            to = toValue
            animation?.toValue = toValue
        }
        return self
    }
    
    /// Defines the float value the animation uses to end interpolation.
    /// - Parameter v1: The float value the animation uses to end interpolation.
    /// - Returns: Self
    @discardableResult
    public func to(_ v1: Float) -> Self {
        return to([v1])
    }
    
    /// Defines the point value the animation uses to end interpolation.
    /// - Parameters:
    ///   - v1: The x of the point.
    ///   - v2: The y of the point.
    /// - Returns: Self
    @discardableResult
    public func to(_ v1: Float, _ v2: Float) -> Self {
        return to([v1, v2])
    }
    
    /// Defines the point value the animation uses to end interpolation.
    /// - Parameter tuple: The tuple value that describes the point. (x, y)
    /// - Returns: Self
    @discardableResult
    public func to(_ tuple:(Float, Float)) -> Self {
        return to([tuple.0, tuple.1])
    }
    
    /// Defines the color value the animation uses to end interpolation.
    /// - Parameter tuple: The tuple value that describes the color. (red, green, blue, alpha) 0~ 255
    /// - Returns: Self
    @discardableResult
    public func to(_ tuple:(Float, Float, Float, Float)) -> Self {
        return to([tuple.0, tuple.1, tuple.2, tuple.3])
    }
    
    /// Defines the color value the animation uses to end interpolation.
    /// - Parameters:
    ///   - v1: The red value of the color object. 0~ 255
    ///   - v2: The green value of the color object. 0~ 255
    ///   - v3: The blue value of the color object. 0~ 255
    ///   - v4: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func to(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return to([v1, v2, v3, v4])
    }
    
    /// Defines the color value the animation uses to end interpolation.
    /// - Parameter color: The color value the animation uses to end interpolation.
    /// - Returns: Self
    @discardableResult
    public func to(_ color: UIColor) -> Self {
        return to([color])
    }
    
    /// Updates this animation.
    /// - Parameters:
    ///   - progress: The progess of the animation. 0.0~1.0
    /// - Returns: Self
    @discardableResult
    public override func update(progress: Float) -> Self {
        if animation == nil {
            prepareAnimation()
        }
        animation?.update(progress: CGFloat(progress))
        return self
    }
    
    /// Attach this animation to the specific UIKit view.
    /// - Parameter view: The UIKit view that attachs this animation.
    /// - Returns: Self
    @discardableResult
    public override func attach(_ view: UIView) -> Self {
        guard target == nil else {
            return self
        }
        target = view
        return self
    }
    
    /// Starts this animation.
    /// - Parameter serial: Not working in this class.
    public override func start() {
        prepareAnimation()
        animation?.start()
    }
    
    /// Pause this animation.
    public override func pause() {
        animPaused = true
        animation?.pause()
    }
    
    /// Resume this animation.
    public override func resume() {
        animPaused = false
        animation?.resume()
    }
    
    /// Stop this animation.
    public override func stop() {
        animation?.finish()
    }

    /// Sets the call back of start animation.
    /// - Parameter callback: The call back of start animation.
    /// - Returns: Self
    public func startCallback(_ callback: @escaping StartCallback) -> Self {
        startCallback = callback
        if let anim = animation {
            anim.startBlock = {_ in callback(self) }
        }
        return self
    }
    
    /// Sets the call back of pause animation.
    /// - Parameter callback: The call back of pause animation.
    /// - Returns: Self
    public func pauseCallback(_ callback: @escaping PauseCallback) -> Self {
        pauseCallback = callback
        if let anim = animation {
            anim.pauseBlock = {_ in callback(self) }
        }
        return self
    }
    
    /// Sets the call back of resume animation.
    /// - Parameter callback: The call back of resume animation.
    /// - Returns: Self
    public func resumeCallback(_ callback: @escaping ResumeCallback) -> Self {
        resumeCallback = callback
        if let anim = animation {
            anim.resumeBlock = {_ in callback(self) }
        }
        return self
    }
    
    /// Sets the call back of repeat animation.
    /// - Parameter callback: The call back of repeat animation.
    /// - Returns: Self
    public func repeatCallback(_ callback: @escaping RepeatCallback) -> Self {
        repeatCallback = callback
        if let anim = animation {
            anim.repeatBlock = { callback(self, Int($1)) }
        }
        return self
    }
    
    /// Sets the call back of finish animation.
    /// - Parameter callback: The call back of finish animation.
    /// - Returns: Self
    public func finishCallback(_ callback: @escaping FinishCallback) -> Self {
        finishCallback = callback
        if let anim = animation {
            anim.finishBlock = { callback(self, $1) }
        }
        return self
    }
    
    // MARK: - Override
    override func prepareAnimation() {
        guard let view = target else {
            assertionFailure("The animation has not yet been added to the view.")
            return
        }
        if animation == nil {
            animation = createAnimation(type: animationTypeValue(type), view: view)
            if animPaused { // 在调用start前，先调用了pause的情况
                animation!.pause()
            }
        }
        let anim = animation!
        anim.fromValue = from
        anim.toValue = to
        anim.resetOnFinish = resetOnStop
        
        if let d = delay {
            anim.beginTime = NSNumber(value: d)
        }
        if let r = repeatCount {
            anim.repeatCount = NSNumber(value: r)
        }
        if let r = repeatForever {
            anim.repeatForever = NSNumber(value: r)
        }
        if let a = autoReverse {
            anim.autoReverses = NSNumber(value: a)
        }
        if let sc = startCallback {
            anim.startBlock = {_ in sc(self)}
        }
        if let pc = pauseCallback {
            anim.pauseBlock = {_ in pc(self)}
        }
        if let rc = resumeCallback {
            anim.resumeBlock = {_ in rc(self)}
        }
        if let rc = repeatCallback {
            anim.repeatBlock = {rc(self, Int($1))}
        }
        if let fb = finishCallback {
            anim.finishBlock = {fb(self, $1)}
        }
    }
   
    override func rawAnimation() -> MLAAnimation? {
        return animation
    }
    
    // MARK: - Private
    private func handleValues(_ values: [Any]) -> Any? {
        guard values.count > 0 else {
            return nil
        }
        switch type {
        case .alpha, .positionX, .positionY, .scaleX, .scaleY:
            return values[0]
            
        case .rotation, .rotationX, .rotationY:
            let angle = values[0]
            if angle is Float {
                return (angle as! Float) * Float.pi / 180
            }
    
        case .textColor, .color:
            let first = values[0]
            if first is UIColor {
                return first
            }
            guard values.count == 4 else {
                assertionFailure("The from value of ArgoKit's animation is invalid.")
                return nil
            }
            return UIColor(red: CastToCGFloat(values[0]) / 255.0,
                           green: CastToCGFloat(values[1]) / 255.0,
                           blue: CastToCGFloat(values[2]) / 255.0,
                           alpha: CastToCGFloat(values[3]))
            
        case .position, .scale, .contentOffset:
            guard values.count == 2 else {
                assertionFailure("The from value of ArgoKit's animation is invalid.")
                return nil
            }
            return CGPoint(x: CastToCGFloat(values[0]), y: CastToCGFloat(values[1]))
        default: break
        }
        return nil
    }
    
    private func CastToCGFloat(_ value: Any) -> CGFloat {
        switch value {
        case let x as Float:
            return CGFloat(x)
        case let x as Double:
            return CGFloat(x)
        case let x as Int:
            return CGFloat(x)
        default: break
        }
        return 0
    }
    
    internal func createAnimation(type: String, view: UIView) -> MLAValueAnimation {
        let anim = MLAObjectAnimation(valueName: type, tartget: view)!
        if let d = duration {
            anim.duration = CGFloat(d)
        }
        switch timingFunc {
        case .defaultValue:
            anim.timingFunction = MLATimingFunction.default
        case .linear:
            anim.timingFunction = MLATimingFunction.linear
        case .easeIn:
            anim.timingFunction = MLATimingFunction.easeIn
        case .easeOut:
            anim.timingFunction = MLATimingFunction.easeOut
        case .easeInEaseOut:
            anim.timingFunction = MLATimingFunction.easeInEaseOut
        }
        return anim
    }
    
    private func animationTypeValue(_ type: AnimationType) -> String {
        switch type {
        case .alpha:
            return kMLAViewAlpha
        case .color:
            return kMLAViewColor
        case .textColor:
            return kMLAViewTextColor
        case .position:
            return kMLAViewPosition
        case .positionX:
            return kMLAViewPositionX
        case .positionY:
            return kMLAViewPositionY
        case .scale:
            return kMLAViewScale
        case .scaleX:
            return kMLAViewScaleX
        case .scaleY:
            return kMLAViewScaleY
        case .rotation:
            return kMLAViewRotation
        case .rotationX:
            return kMLAViewRotationX
        case .rotationY:
            return kMLAViewRotationY
        case .contentOffset:
            return kMLAViewContentOffset
        }
    }
    
}
