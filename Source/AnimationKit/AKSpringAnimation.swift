//
//  AKSpringAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/19.
//

import Foundation

public class AKSpringAnimation: AKAnimation {
    
    private var velocity: Any?
    private var speed: CGFloat?
    private var bounciness: CGFloat?
    private var tension: CGFloat?
    private var friction: CGFloat?
    private var mass: CGFloat?
    
    // MARK: - Override
    @discardableResult
    public override func timingFunc(_ timing: AKAnimationTimingFunc) -> Self {
        // do nothing
        return self
    }
    
    override func createAnimation(type: String, view: UIView) -> MLAValueAnimation {
        let anim = MLASpringAnimation(valueName: type, tartget: view)!
        configAnimation(anim)
        return anim
    }
    
    // MARK: - Public
    @discardableResult
    public func springVelocity(_ velocity: CGFloat) -> Self {
        self.velocity = velocity
        return self
    }
    
    public func springVelocity(_ velocity: Array<CGFloat>) -> Self {
        self.velocity = velocity
        return self
    }
    
    @discardableResult
    public func springBounciness(_ bounce: CGFloat) -> Self {
        self.bounciness = bounce
        return self
    }
    
    @discardableResult
    public func springSpeed(_ speed: CGFloat) -> Self {
        self.speed = speed
        return self
    }
    
    @discardableResult
    public func springTension(_ tension: CGFloat) -> Self {
        self.tension = tension
        return self
    }
    
    @discardableResult
    public func springFriction(_ friction: CGFloat) -> Self {
        self.friction = friction
        return self
    }
    
    @discardableResult
    public func springMass(_ mass: CGFloat) -> Self {
        self.mass = mass
        return self
    }
    
    // MARK: - Private
    private func configAnimation(_ anim: MLASpringAnimation) {
        if let b = self.bounciness {
            anim.springBounciness = b
        }
        if let s = self.speed {
            anim.springSpeed = s
        }
        if let t = self.tension {
            anim.dynamicsTension = t
        }
        if let f = self.friction {
            anim.dynamicsFriction = f
        }
        if let m = self.mass {
            anim.dynamicsMass = m
        }
        if let v = self.velocity {
            guard v is Array<CGFloat> else {
                assertionFailure("The velocity value type of ArgoKit's springAnimation should be Array.")
                return
            }
            let array = (v as! Array<CGFloat>)
            switch array.count {
            case 1:
                anim.velocity = array[0]
            case 2:
                anim.velocity = CGPoint(x: array[0],
                                        y: array[1])
            default:
                break
            }
        }
    }
    
}
