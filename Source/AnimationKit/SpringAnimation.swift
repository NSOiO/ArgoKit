//
//  SpringAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/19.
//

import Foundation
import ArgoAnimation

/// An animation that applies a spring-like force to a layer's properties.
///
/// ```
///         SpringAnimation(type: .position)
///             .duration(duration)
///             .from(x, y)
///             .to(x, y)
///             .resetOnStop(true)
///             .springVelocity(Velocity)
///             .springBounciness(Bounciness)
///             .springSpeed(Speed)
///             .springTension(Tension)
/// ```
///
public class SpringAnimation: Animation {
    
    private var velocity: Any?
    private var speed: Float?
    private var bounciness: Float?
    private var tension: Float?
    private var friction: Float?
    private var mass: Float?
    
    // MARK: - Override
    override func createAnimation(type: String, view: UIView) -> MLAValueAnimation {
        let anim = MLASpringAnimation(valueName: type, tartget: view)!
        configAnimation(anim)
        return anim
    }
    
    // MARK: - Public
    
    /// Sets the initial velocity of the object attached to the spring.
    /// - Parameter velocity: The initial velocity of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springVelocity(_ velocity: Float) -> Self {
        self.velocity = velocity
        return self
    }
    
    /// Sets the velocitys of the object attached to the spring.
    /// - Parameter velocity: The velocitys of the object attached to the spring.
    /// - Returns: Self
    public func springVelocity(_ velocity: Array<Float>) -> Self {
        self.velocity = velocity
        return self
    }
    
    /// Sets the bounce of the object attached to the spring.
    /// Together with the springSpeed ​​value, can change the animation effect. The larger the value, the larger the spring motion range, and the greater the vibration and elasticity.
    /// Defined as a value in the range of [0,20].  Default is 4.
    /// - Parameter bounce: The bounce of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springBounciness(_ bounce: Float) -> Self {
        self.bounciness = bounce
        return self
    }
    
    /// Sets the speed of the object attached to the spring.
    /// Together with the springBounciness value, can change the animation effect. A higher value increases the damping capacity of the spring, resulting in a faster initial speed and faster rebound deceleration.
    /// Defined as a value in the range of [0,20] . Default is 12.
    /// - Parameter speed: The speed of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springSpeed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }
    
    /// Set the tension of the object attached to the spring.
    /// Dynamic tension can be used on elasticity and speed to fine-tune the animation effect.
    /// - Parameter tension: The tension of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springTension(_ tension: Float) -> Self {
        self.tension = tension
        return self
    }
    
    /// Set the friction of the object attached to the spring.
    /// Dynamic friction can be used on elasticity and speed to fine-tune animation effects.
    /// - Parameter friction: The friction of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springFriction(_ friction: Float) -> Self {
        self.friction = friction
        return self
    }
    
    /// Set the mass of the object attached to the spring.
    /// Dynamic mass can be used on elasticity and speed to fine-tune animation effects.
    /// - Parameter mass: The mass of the object attached to the spring.
    /// - Returns: Self
    @discardableResult
    public func springMass(_ mass: Float) -> Self {
        self.mass = mass
        return self
    }
    
    // MARK: - Private
    private func configAnimation(_ anim: MLASpringAnimation) {
        if let b = self.bounciness {
            anim.springBounciness = CGFloat(b)
        }
        if let s = self.speed {
            anim.springSpeed = CGFloat(s)
        }
        if let t = self.tension {
            anim.dynamicsTension = CGFloat(t)
        }
        if let f = self.friction {
            anim.dynamicsFriction = CGFloat(f)
        }
        if let m = self.mass {
            anim.dynamicsMass = CGFloat(m)
        }
        if let v = self.velocity {
            switch v {
            case let v1 as Float:
                anim.velocity = v1
            case let v2 as Array<Float>:
                switch v2.count {
                case 1:
                    anim.velocity = v2[0]
                case 2:
                    anim.velocity = CGPoint(x: CGFloat(v2[0]), y: CGFloat(v2[1]))
                default: break
                }
            default:
                assertionFailure("The velocity value type of ArgoKit's springAnimation is invalid.")
                break
            }
        }
    }
    
}
