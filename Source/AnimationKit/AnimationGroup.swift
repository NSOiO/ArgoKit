//
//  AnimationGroup.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/24.
//

import Foundation
import ArgoAnimation

/// An object that allows multiple animations to be grouped and run concurrently.
///
/// ```
///         AnimationGroup()
///             .delay(delay)
///             .animations([Animation])
/// ```
///
public class AnimationGroup: AnimationBasic {
    
    private var delay: Float?
    private var repeatCount: Int?
    private var repeatForever: Bool?
    private var autoReverse: Bool?
    
    private var startCallback: MLAAnimationStartBlock?
    private var pauseCallback: MLAAnimationPauseBlock?
    private var resumeCallback: MLAAnimationResumeBlock?
    private var repeatCallback: MLAAnimationRepeatBlock?
    private var finishCallback: MLAAnimationFinishBlock?
    
    private weak var target: UIView?
    private var animation: MLAMultiAnimation?
    private var animPaused = false
    private var animations: [Animation]?
    private var rawAnimations = [MLAAnimation]()
    
    // MARK: - Public
    
    /// Specifies the amount of time (measured in seconds) to wait before beginning the animations.
    /// - Parameter delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    /// - Returns: Self
    @discardableResult
    public func delay(_ delay: Float) -> Self {
        self.delay = delay
        return self
    }
    
    /// Determines the number of times the animation group will repeat.
    /// - Parameter count: The number of times the animation group will repeat.
    /// - Returns: Self
    @discardableResult
    public func repeatCount(_ count: Int) -> Self {
        self.repeatCount = count
        return self
    }
    
    /// Sets a Boolean value that controls whether that repeats this animation group forever.
    /// - Parameter forever: A Boolean value that controls whether that repeats this animation group forever.
    /// - Returns: Self
    @discardableResult
    public func repeatForever(_ forever: Bool) -> Self {
        self.repeatForever = forever
        return self
    }
    
    /// Determines if the animation group plays in the reverse upon completion.
    /// - Parameter reverse: true if you want to this animaiton  group plays in the reverse upon completion.
    /// - Returns: Self
    @discardableResult
    public func autoReverse(_ reverse: Bool) -> Self {
        self.autoReverse = reverse
        return self
    }
    
    /// Attach this animation group to the specific UIKit view.
    /// - Parameter view: The UIKit view that attachs this animation.
    /// - Returns: Self
    @discardableResult
    public override func attach(_ view: UIView) -> Self {
        guard target == nil else {
            assertionFailure("You cann't attach an animaionGroup to multiple views.")
            return self
        }
        target = view
        return self
    }
    
    /// Sets multiple animations to be grouped.
    /// - Parameter animations: The multiple animations that to be grouped.
    /// - Returns: Self
    @discardableResult
    public func animations(_ animations: Array<Animation>?) -> Self {
        guard let array = animations else {
            return self
        }
        self.animations = array
        return self
    }
    
    /// Updates this animation group.
    /// - Parameters:
    ///   - serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    ///   - progress: The progess of the animation. 0.0~1.0
    /// - Returns: Self
    @discardableResult
    public override func update(serial: Bool = false, progress: Float) -> Self {
        if serial {
            updateSerial(progress: progress)
        } else {
            updateConcurrent(progress: progress)
        }
        return self
    }
    
    /// Updates this animation group serially.
    /// - Parameter progress: The progess of the animation group. 0.0~1.0
    /// - Returns: Self
    @discardableResult
    public func updateSerial(progress: Float) -> Self {
        if animation == nil {
            prepareAnimationGroup()
            animation?.runSequentially(rawAnimations)
        }
        animation?.update(progress: CGFloat(progress))
        return self
    }
    
    /// Updates this animation group concurrently.
    /// - Parameter progress: The progess of the animation group. 0.0~1.0
    /// - Returns: Self
    @discardableResult
    public func updateConcurrent(progress: Float) -> Self {
        if animation == nil {
            prepareAnimationGroup()
            animation?.runTogether(rawAnimations)
        }
        animation?.update(progress: CGFloat(progress))
        return self
    }
    
    /// Starts this animation group.
    /// - Parameter serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    public override func start(serial: Bool) {
        if serial {
            startSerial()
        } else {
            startConcurrent()
        }
    }
    
    /// Starts this animation group serially.
    public func startSerial() {
        prepareAnimationGroup()
        guard let group = animation else {
            assertionFailure("The animationGroup's raw animation is nil.")
            return
        }
        group.runSequentially(rawAnimations)
        group.start()
    }
    
    /// Starts this animation group concurrently.
    public func startConcurrent() {
        prepareAnimationGroup()
        guard let group = animation else {
            assertionFailure("The animationGroup's raw animation is nil.")
            return
        }
        group.runTogether(rawAnimations)
        group.start()
    }
    
    /// Pauses this animation group.
    public override func pause() {
        animPaused = true
        animation?.pause()
    }
    
    /// Resumes this animation group.
    public override func resume() {
        animPaused = false
        animation?.resume()
    }
    
    /// Stops this animation group.
    public override func stop() {
        animation?.finish()
    }
    
    /// Sets the call back of start animation.
    /// - Parameter callback: The call back of start animation.
    /// - Returns: Self
    public func startCallback(_ callback: @escaping MLAAnimationStartBlock) -> Self {
        startCallback = callback
        if let anim = animation {
            anim.startBlock = callback
        }
        return self
    }
    
    /// Sets the call back of pause animation.
    /// - Parameter callback: The call back of pause animation.
    /// - Returns: Self
    public func pauseCallback(_ callback: @escaping MLAAnimationPauseBlock) -> Self {
        pauseCallback = callback
        if let anim = animation {
            anim.pauseBlock = callback
        }
        return self
    }
    
    /// Sets the call back of resume animation.
    /// - Parameter callback: The call back of resume animation.
    /// - Returns: Self
    public func resumeCallback(_ callback: @escaping MLAAnimationResumeBlock) -> Self {
        resumeCallback = callback
        if let anim = animation {
            anim.resumeBlock = callback
        }
        return self
    }
    
    /// Sets the call back of repeat animation.
    /// - Parameter callback: The call back of repeat animation.
    /// - Returns: Self
    public func repeatCallback(_ callback: @escaping MLAAnimationRepeatBlock) -> Self {
        repeatCallback = callback
        if let anim = animation {
            anim.repeatBlock = callback
        }
        return self
    }
    
    /// Sets the call back of finish animation.
    /// - Parameter callback: The call back of finish animation.
    /// - Returns: Self
    public func finishCallback(_ callback: @escaping MLAAnimationFinishBlock) -> Self {
        finishCallback = callback
        if let anim = animation {
            anim.finishBlock = callback
        }
        return self
    }
    
    // MARK: - Private
    private func prepareAnimationGroup() {
        guard let array = animations else {
            assertionFailure("The animationGroup has no animation, please call `animations` method firstly.")
            return
        }
    
        if animation == nil {
            animation = MLAMultiAnimation()
            if animPaused { // 在调用start前，先调用了pause的情况
                animation!.pause()
            }
        }
        let anim = animation!
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
            anim.startBlock = sc
        }
        if let pc = pauseCallback {
            anim.pauseBlock = pc
        }
        if let rc = resumeCallback {
            anim.resumeBlock = rc
        }
        if let rc = repeatCallback {
            anim.repeatBlock = rc
        }
        if let fb = finishCallback {
            anim.finishBlock = fb
        }
        
        rawAnimations.removeAll()
        for anim in array {
            if let view = target {
                anim.attach(view)
            }
            anim.prepareAnimation()
            if let raw = anim.rawAnimation() {
                rawAnimations.append(raw)
            }
        }
    }

}
