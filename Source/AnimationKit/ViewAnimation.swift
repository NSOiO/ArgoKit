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
            newValue?.attach(self)
            objc_setAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey) as? AnimationBasic
        }
    }
    
    @objc public func argokit_updateAnimation(serial: Bool = false, progress: Float) {
        self.argokit_animation?.update(serial: serial, progress: progress)
    }
    
    @objc public func argokit_startAnimation(serial: Bool = false) {
        self.argokit_animation?.start(serial: serial)
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

extension View {
    
    @discardableResult
    public func addAnimation(animation: AnimationBasic) -> Self {
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    @discardableResult
    public func addAnimation(@ArgoKitAnimationBuilder _ builder: () -> AnimationBasic) -> Self {
        let animation = builder()
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    @discardableResult
    public func updateAnimation(serial: Bool = false, progress: Float) -> Self {
        addAttribute(#selector(UIView.argokit_updateAnimation(serial:progress:)), serial, progress)
        return self
    }
    
    @discardableResult
    public func startAnimation(serial: Bool = false) -> Self {
        addAttribute(#selector(UIView.argokit_startAnimation), serial)
        return self
    }
    
    @discardableResult
    public func pauseAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_pauseAnimation))
        return self
    }
    
    @discardableResult
    public func resumeAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_resumeAnimation))
        return self
    }
    
    @discardableResult
    public func stopAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_stopAnimation))
        return self
    }
}
