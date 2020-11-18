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

public class AKAnimation {

    // MARK: - Public
    public var timingFunc = AKAnimationTimingFunc.defaultValue
    public var duration = 0.0
    public var delay = 0.0
    public var repeatCount = 0
    public var repeatForever = false
    public var autoReverse = false
    public var springAnimConfig = [AKTimingConfigKey: AKTimingConfigValue]()
    
    public var startCallback: MLAAnimationStartBlock?
    public var pauseCallback: MLAAnimationPauseBlock?
    public var resumeCallback: MLAAnimationResumeBlock?
    public var repeatCallback: MLAAnimationRepeatBlock?
    public var finishCallback: MLAAnimationFinishBlock?
    
    // MARK: - Private
    private let type: AKAnimationType!
    private let target: UIView!
    private var from: Any?, to: Any?
    private var animation: MLAValueAnimation?
    private var animPaused = false

    init(type: AKAnimationType, view: UIView) {
        self.type = type
        target = view
    }
    
    // MARK: - Public
    public func from(_ values: Any ...) {
        if let fromValue = handleValues(values) {
            from = fromValue
        }
    }
    
    public func to(_ values: Any ...) {
        if let toValue = handleValues(values) {
            to = toValue
        }
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
            return UIColor(red: CastToCGFloat(values[0]) / 255.0, green: CastToCGFloat(values[1]) / 255.0, blue: CastToCGFloat(values[2]) / 255.0, alpha: CastToCGFloat(values[3]))
            
        case .position, .scale, .contentOffset:
            guard values.count == 2 else {
                assertionFailure("The from value of ArgoKit's animation is invalid.")
                return nil
            }
            return CGPoint(x: CastToCGFloat(values[0]), y: CastToCGFloat(values[1]))
            
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
            anim.springBounciness = bounce as! CGFloat
        }
        if let speed = springAnimConfig[AKTimingConfigSpeed] {
            anim.springSpeed = speed as! CGFloat
        }
        if let tension = springAnimConfig[AKTimingConfigTension] {
            anim.dynamicsTension = tension as! CGFloat
        }
        if let friction = springAnimConfig[AKTimingConfigFriction] {
            anim.dynamicsFriction = friction as! CGFloat
        }
        if let mass = springAnimConfig[AKTimingConfigMass] {
            anim.dynamicsMass = mass as! CGFloat
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
                anim.velocity = CGPoint(x: array[0] as! CGFloat, y: array[1] as! CGFloat)
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
