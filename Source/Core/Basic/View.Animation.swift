//
//  AnimationBasic.Extra.swift
//  ArgoKit
//
//  Created by Dongpeng Dai on 2020/12/23.
//

import Foundation

extension AnimationBasic {
    @discardableResult
    public func attach(_ view: View) -> Self {
        if let actualView = view.node?.view {
            attach(actualView)
        }
        return self
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
