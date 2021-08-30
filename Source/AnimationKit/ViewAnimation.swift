//
//  ViewAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/12/18.
//

import Foundation

private struct ArgoKitNodeAnimationKey {
    static var animationKey: Void?
}

extension UIView {
    
    @objc public var argokit_animation: AnimationBasic? {
        set {
            if let lastAnimation = self.argokit_animation {
                lastAnimation.stop()
            }
            newValue?.attach(self)
            objc_setAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey) as? AnimationBasic
        }
    }
    
    @objc public func argokit_updateAnimation(serial: Bool = false, progress: Float) {
        self.argokit_animation?.serial(serial).update(progress: progress)
    }
    
    @objc public func argokit_startAnimation(serial: Bool = false) {
        self.argokit_animation?.serial(serial).start()
    }
    
    @objc public func argokit_pauseAnimation() {
        self.argokit_animation?.pause()
    }
    
    @objc public func argokit_resumeAnimation() {
        self.argokit_animation?.resume()
    }
    
    @objc public func argokit_stopAnimation() {
        self.argokit_animation?.stop()
    }
}

