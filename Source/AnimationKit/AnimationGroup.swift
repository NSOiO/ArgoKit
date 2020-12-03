//
//  AnimationGroup.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/24.
//

import Foundation
import ArgoAnimation

public class AnimationGroup {
    
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
    public init() { }
    
    @discardableResult
    public func delay(_ delay: Float) -> Self {
        self.delay = delay
        return self
    }
    
    @discardableResult
    public func repeatCount(_ count: Int) -> Self {
        self.repeatCount = count
        return self
    }
    
    @discardableResult
    public func repeatForever(_ forever: Bool) -> Self {
        self.repeatForever = forever
        return self
    }
    
    @discardableResult
    public func autoReverse(_ reverse: Bool) -> Self {
        self.autoReverse = reverse
        return self
    }
    
    @discardableResult
    public func attach(_ view: View) -> Self {
        if let actualView = view.node?.view {
            attach(actualView)
        }
        return self
    }
    
    @discardableResult
    public func attach(_ view: UIView) -> Self {
        guard target == nil else {
            assertionFailure("You cann't attach an animaionGroup to multiple views.")
            return self
        }
        target = view
        return self
    }
    
    @discardableResult
    public func animations(_ animations: Array<Animation>?) -> Self {
        guard let array = animations else {
            return self
        }
        self.animations = array
        return self
    }
    
    @discardableResult
    public func update(progress: Float) -> Self {
        if animation == nil {
            prepareAnimationGroup()
        }
        animation?.update(progress: CGFloat(progress))
        return self
    }
    
    public func startSerial() {
        prepareAnimationGroup()
        guard let group = animation else {
            assertionFailure("The animationGroup's raw animation is nil.")
            return
        }
        group.runSequentially(rawAnimations)
        group.start()
    }
    
    public func startConcurrent() {
        prepareAnimationGroup()
        guard let group = animation else {
            assertionFailure("The animationGroup's raw animation is nil.")
            return
        }
        group.runTogether(rawAnimations)
        group.start()
    }
    
    public func pause() {
        animPaused = true
        animation?.pause()
    }
    
    public func resume() {
        animPaused = false
        animation?.resume()
    }
    
    public func stop() {
        animation?.finish()
    }

    public func startCallback(_ callback: @escaping MLAAnimationStartBlock) {
        startCallback = callback
        if let anim = animation {
            anim.startBlock = callback
        }
    }
    
    public func pauseCallback(_ callback: @escaping MLAAnimationPauseBlock) {
        pauseCallback = callback
        if let anim = animation {
            anim.pauseBlock = callback
        }
    }
    
    public func resumeCallback(_ callback: @escaping MLAAnimationResumeBlock) {
        resumeCallback = callback
        if let anim = animation {
            anim.resumeBlock = callback
        }
    }
    
    public func repeatCallback(_ callback: @escaping MLAAnimationRepeatBlock) {
        repeatCallback = callback
        if let anim = animation {
            anim.repeatBlock = callback
        }
    }
    
    public func finishCallback(_ callback: @escaping MLAAnimationFinishBlock) {
        finishCallback = callback
        if let anim = animation {
            anim.finishBlock = callback
        }
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
