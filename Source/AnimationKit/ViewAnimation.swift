//
//  ViewAnimation.swift
//  ArgoKit
//
//  Created by MOMO on 2020/12/18.
//

import Foundation

private struct ArgoKitNodeAnimationKey {
    static var animationKey: Void?
    static var animationGroupKey: Void?
}

extension UIView {
    
    @objc public var argokit_animation: Animation? {
        set {
            if let animationGroup = self.argokit_animationGroup {
                animationGroup.stop()
                self.argokit_animationGroup = nil
            }
            newValue?.attach(self)
            objc_setAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &ArgoKitNodeAnimationKey.animationKey) as? Animation
        }
    }
    
    @objc public var argokit_animationGroup: AnimationGroup? {
        set {
            if let animation = self.argokit_animation {
                animation.stop()
                self.argokit_animation = nil
            }
            newValue?.attach(self)
            objc_setAssociatedObject(self, &ArgoKitNodeAnimationKey.animationGroupKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &ArgoKitNodeAnimationKey.animationGroupKey) as? AnimationGroup
        }
    }
        
    @objc public func startAnimation(serial: Bool = false) {
        if let animationGroup = self.argokit_animationGroup {
            if serial {
                animationGroup.startSerial()
            } else {
                animationGroup.startConcurrent()
            }
            return
        }
        self.argokit_animation?.start()
    }
    
    @objc public func pauseAnimation() {
        if let animationGroup = self.argokit_animationGroup {
            animationGroup.pause()
            return
        }
        self.argokit_animation?.pause()
    }
    
    @objc public func resumeAnimation() {
        if let animationGroup = self.argokit_animationGroup {
            animationGroup.resume()
            return
        }
        self.argokit_animation?.resume()
    }
    
    @objc public func stopAnimation() {
        if let animationGroup = self.argokit_animationGroup {
            animationGroup.stop()
            return
        }
        self.argokit_animation?.stop()
    }
}

extension View {
    
    @discardableResult
    public func addAnimation(animation: Animation) -> Self {
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    @discardableResult
    public func addAnimation(_ builder: () -> Animation) -> Self {
        let animation = builder()
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    @discardableResult
    public func addAnimationGroup(group: AnimationGroup) -> Self {
        addAttribute(#selector(setter: UIView.argokit_animationGroup), group)
        return self
    }
    
    @discardableResult
    public func addAnimationGroup(@ArgoKitAnimationGroupBuilder _ builder: () -> AnimationGroup) -> Self {
        let animation = builder()
        addAttribute(#selector(setter: UIView.argokit_animationGroup), animation)
        return self
    }
    
    @discardableResult
    public func startAnimation(serial: Bool = false) -> Self {
        addAttribute(#selector(UIView.startAnimation), serial)
        return self
    }
    
    @discardableResult
    public func pauseAnimation() -> Self {
        addAttribute(#selector(UIView.pauseAnimation))
        return self
    }
    
    @discardableResult
    public func resumeAnimation() -> Self {
        addAttribute(#selector(UIView.resumeAnimation))
        return self
    }
    
    @discardableResult
    public func stopAnimation() -> Self {
        addAttribute(#selector(UIView.stopAnimation))
        return self
    }
}
