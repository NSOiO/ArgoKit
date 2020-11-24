//
//  SpringAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/19.
//

import Foundation

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
    @discardableResult
    public func springVelocity(_ velocity: Float) -> Self {
        self.velocity = velocity
        return self
    }
    
    public func springVelocity(_ velocity: Array<Float>) -> Self {
        self.velocity = velocity
        return self
    }
    
    @discardableResult
    public func springBounciness(_ bounce: Float) -> Self {
        self.bounciness = bounce
        return self
    }
    
    @discardableResult
    public func springSpeed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }
    
    @discardableResult
    public func springTension(_ tension: Float) -> Self {
        self.tension = tension
        return self
    }
    
    @discardableResult
    public func springFriction(_ friction: Float) -> Self {
        self.friction = friction
        return self
    }
    
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
            case let v1 as CGFloat:
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
