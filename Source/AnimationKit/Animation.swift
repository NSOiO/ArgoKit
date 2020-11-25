//
//  Animation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

public enum AnimationTimingFunc {
    case defaultValue
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
}

public enum AnimationType {
    case alpha
    case color, textColor
    case position, positionX, positionY
    case scale, scaleX, scaleY
    case rotation, rotationX, rotationY
    case contentOffset
}

extension UIView {
    
    public func addAnimation(_ animation: Animation) {
        animation.attach(self)
    }
}

public class Animation {

    // MARK: - Private
    private var duration: Float?
    private var delay: Float?
    private var repeatCount: Int?
    private var repeatForever: Bool?
    private var autoReverse: Bool?
    private var timingFunc = AnimationTimingFunc.defaultValue
    private let type: AnimationType!
    private weak var target: UIView?
    private var from: Any?, to: Any?
    private var animation: MLAValueAnimation?
    private var animPaused = false
    
    private var startCallback: MLAAnimationStartBlock?
    private var pauseCallback: MLAAnimationPauseBlock?
    private var resumeCallback: MLAAnimationResumeBlock?
    private var repeatCallback: MLAAnimationRepeatBlock?
    private var finishCallback: MLAAnimationFinishBlock?

    public init(type: AnimationType) {
        self.type = type
    }
    
    // MARK: - Public
    @discardableResult
    public func duration(_ duration: Float) -> Self {
        self.duration = duration
        return self
    }
    
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
    public func timingFunc(_ timing: AnimationTimingFunc) -> Self {
        self.timingFunc = timing
        return self
    }
    
    @discardableResult
    func from(_ values: [Any]) -> Self {
        if let fromValue = handleValues(values) {
            from = fromValue
        }
        return self
    }
    
    
    @discardableResult
    public func from(_ v1: Float) -> Self {
        return from([v1])
    }
    
    @discardableResult
    public func from(_ v1: Float, _ v2: Float) -> Self {
        return from([v1, v2])
    }
    
    @discardableResult
    public func from(_ tuple:(Float, Float)) -> Self {
        return from([tuple.0, tuple.1])
    }

    @discardableResult
    public func from(_ tuple:(Float, Float, Float, Float)) -> Self {
        return from([tuple.0, tuple.1, tuple.2, tuple.3])
    }
    
    @discardableResult
    public func from(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return from([v1, v2, v3, v4])
    }
    
    @discardableResult
    public func from(_ color: UIColor) -> Self {
        return from([color])
    }
    
    
    @discardableResult
    func to(_ values: [Any]) -> Self {
        if let toValue = handleValues(values) {
            to = toValue
        }
        return self
    }
    
    @discardableResult
    public func to(_ v1: Float) -> Self {
        return to([v1])
    }
    
    @discardableResult
    public func to(_ v1: Float, _ v2: Float) -> Self {
        return to([v1, v2])
    }
    
    @discardableResult
    public func to(_ tuple:(Float, Float)) -> Self {
        return to([tuple.0, tuple.1])
    }
    
    @discardableResult
    public func to(_ tuple:(Float, Float, Float, Float)) -> Self {
        return to([tuple.0, tuple.1, tuple.2, tuple.3])
    }
    
    @discardableResult
    public func to(_ v1: Float, _ v2: Float, _ v3: Float, _ v4: Float) -> Self {
        return to([v1, v2, v3, v4])
    }
    
    @discardableResult
    public func to(_ color: UIColor) -> Self {
        return to([color])
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
            return self
        }
        target = view
        return self
    }
    
    public func start() {
        prepareAnimation()
        animation?.start()
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
    internal func rawAnimation() -> MLAAnimation? {
        return animation
    }
    
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
    
    internal func prepareAnimation() {
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
