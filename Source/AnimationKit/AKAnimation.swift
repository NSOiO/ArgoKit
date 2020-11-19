//
//  AKAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

public enum AKAnimationTimingFunc {
    case defaultValue
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
    case spring
}

public enum AKAnimationType {
    case alpha
    case color, textColor
    case position, positionX, positionY
    case scale, scaleX, scaleY
    case rotation, rotationX, rotationY
    case contentOffset
}

public typealias AKTimingConfigKey = String
public typealias AKTimingConfigValue = AnyObject

public let AKTimingConfigDuration: AKTimingConfigKey = "Duration"
public let AKTimingConfigVelocity: AKTimingConfigKey = "Velocity"
public let AKTimingConfigBounciness: AKTimingConfigKey = "Bounciness"
public let AKTimingConfigSpeed: AKTimingConfigKey = "Speed"
public let AKTimingConfigTension: AKTimingConfigKey = "Tension"
public let AKTimingConfigFriction: AKTimingConfigKey = "Friction"
public let AKTimingConfigMass: AKTimingConfigKey = "Mass"

extension UIView {
    
    public func addAnimation(_ animation: AKAnimation) {
        animation.attach(self)
    }
}

public class AKAnimation {

    // MARK: - Public
    public var springAnimConfig = [AKTimingConfigKey: AKTimingConfigValue]()
    public var startCallback: MLAAnimationStartBlock?
    public var pauseCallback: MLAAnimationPauseBlock?
    public var resumeCallback: MLAAnimationResumeBlock?
    public var repeatCallback: MLAAnimationRepeatBlock?
    public var finishCallback: MLAAnimationFinishBlock?
    
    // MARK: - Private
    private var duration: Double = 0.0
    private var delay: Double = 0.0
    private var repeatCount: Int = 0
    private var repeatForever: Bool = false
    private var autoReverse: Bool = false
    private var timingFunc = AKAnimationTimingFunc.defaultValue
    private let type: AKAnimationType!
    private weak var target: UIView!
    private var from: Any?, to: Any?
    private var animation: MLAValueAnimation?
    private var animPaused = false

    init(type: AKAnimationType) {
        self.type = type
    }
    
    // MARK: - Public
    @discardableResult
    public func duration(_ duration: Double) -> Self {
        self.duration = duration
        return self
    }
    
    @discardableResult
    public func delay(_ delay: Double) -> Self {
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
    public func timingFunc(_ timing: AKAnimationTimingFunc) -> Self {
        self.timingFunc = timing
        return self
    }
    
    @discardableResult
    public func from(_ values: Any ...) -> Self {
        if let fromValue = handleValues(values) {
            from = fromValue
        }
        return self
    }
    
    @discardableResult
    public func to(_ values: Any ...) -> Self {
        if let toValue = handleValues(values) {
            to = toValue
        }
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
            assertionFailure("You cann't attach an animaion to multiple views.")
            return self
        }
        target = view
        return self
    }
    
    public func start() {
        prepareAnimation()
        animation!.start()
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
    
    // MARK: - Private
    private func handleValues(_ values: [Any]) -> Any? {
        guard values.count > 0 else {
            return nil
        }
        
        switch type {
        case .alpha, .positionX, .positionY, .scaleX, .scaleY:
            return values[0]
            
        case .rotation, .rotationX, .rotationY:
            return values[0]
            
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
            return CGPoint(x: CastToCGFloat(values[0]),
                           y: CastToCGFloat(values[1]))
            
        default:
            break
        }
        
        return nil
    }
    
    private func CastToCGFloat(_ value: Any) -> CGFloat {
        switch value {
        case let x as Double:
            return CGFloat(x)
        case let x as Float:
            return CGFloat(x)
        case let x as Int:
            return CGFloat(x)
        default:
            break
        }
        return 0
    }
    
    private func prepareAnimation() {
        guard target != nil else {
            assertionFailure("The animation has not yet been added to the view.")
            return
        }
        
        if animation == nil {
            if timingFunc == AKAnimationTimingFunc.spring {
                animation = MLASpringAnimation(valueName: animationTypeValue(type), tartget: target)
            } else {
                animation = MLAObjectAnimation(valueName: animationTypeValue(type), tartget: target)
            }
        }
        
        let anim = animation!
        anim.fromValue = from
        anim.toValue = to
        anim.beginTime = NSNumber(value: delay)
        anim.repeatCount = NSNumber(value: repeatCount)
        anim.repeatForever = repeatForever as NSNumber
        anim.autoReverses = autoReverse as NSNumber
        anim.startBlock = startCallback
        anim.pauseBlock = pauseCallback
        anim.resumeBlock = resumeCallback
        anim.repeatBlock = repeatCallback
        anim.finishBlock = finishCallback
        
        switch anim {
        case let objectAnim as MLAObjectAnimation:
            configObjectAnimation(objectAnim)
        case let springAnim as MLASpringAnimation:
            configSpringAnimation(springAnim)
        default:
            break
        }
    }
    
    private func configObjectAnimation(_ anim: MLAObjectAnimation) {
        anim.duration = CGFloat(duration)
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
        default:
            break
        }
    }
    
    private func configSpringAnimation(_ anim: MLASpringAnimation) {
        if let bounce = springAnimConfig[AKTimingConfigBounciness] {
            anim.springBounciness = CastToCGFloat(bounce)
        }
        if let speed = springAnimConfig[AKTimingConfigSpeed] {
            anim.springSpeed = CastToCGFloat(speed)
        }
        if let tension = springAnimConfig[AKTimingConfigTension] {
            anim.dynamicsTension = CastToCGFloat(tension)
        }
        if let friction = springAnimConfig[AKTimingConfigFriction] {
            anim.dynamicsFriction = CastToCGFloat(friction)
        }
        if let mass = springAnimConfig[AKTimingConfigMass] {
            anim.dynamicsMass = CastToCGFloat(mass)
        }
        if let velocity = springAnimConfig[AKTimingConfigVelocity] {
            guard velocity is Array<AnyObject> else {
                assertionFailure("The velocity value type of ArgoKit's springAnimation should be Array.")
                return
            }
            let array = (velocity as! Array<AnyObject>)
            switch array.count {
            case 1:
                anim.velocity = array[0]
            case 2:
                anim.velocity = CGPoint(x: CastToCGFloat(array[0]),
                                        y: CastToCGFloat(array[1]))
            default:
                break
            }
        }
    }
    
    private func animationTypeValue(_ type: AKAnimationType) -> String {
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
        default:
            break
        }
    }
    
}
