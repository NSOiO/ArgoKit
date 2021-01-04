//
//  AnimationBasic.Extra.swift
//  ArgoKit
//
//  Created by Dongpeng Dai on 2020/12/23.
//

import Foundation

extension AnimationBasic {
    
    /// Attachs this animation to specified view.
    /// - Parameter view: The view that attachs this animation.
    /// - Returns: self
    @discardableResult
    public func attach(_ view: View) -> Self {
        view.addAttribute(#selector(setter: UIView.argokit_animation), self)
        return self
    }
}

extension View {
    
    /// Add the specified animation object to this view
    /// - Parameter animation: The animation to be added to this view
    /// - Returns: self
    @discardableResult
    public func addAnimation(animation: AnimationBasic) -> Self {
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    /// Add the specified animation object to the view
    /// - Parameter builder: An animation builder that creates the animation added to this view.
    /// - Returns: self
    @discardableResult
    public func addAnimation(@ArgoKitAnimationBuilder _ builder: () -> AnimationBasic) -> Self {
        let animation = builder()
        addAttribute(#selector(setter: UIView.argokit_animation), animation)
        return self
    }
    
    /// Updates the animation in the receiver.
    /// - Parameters:
    ///   - serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    ///   - progress: The progess of the animation. 0.0~1.0
    /// - Returns: self
    @discardableResult
    public func updateAnimation(serial: Bool = false, progress: Float) -> Self {
        addAttribute(#selector(UIView.argokit_updateAnimation(serial:progress:)), serial, progress)
        return self
    }
    
    /// Starts the animation in the receiver.
    /// - Parameter serial: A Boolean value that controls whether the animation is serial executed. Only works when there are multiple animations.
    /// - Returns: self
    @discardableResult
    public func startAnimation(serial: Bool = false) -> Self {
        addAttribute(#selector(UIView.argokit_startAnimation), serial)
        return self
    }
    
    /// Pauses the animation in the receiver.
    /// - Returns: self
    @discardableResult
    public func pauseAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_pauseAnimation))
        return self
    }
    
    /// Resumes the animation in the receiver.
    /// - Returns: self
    @discardableResult
    public func resumeAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_resumeAnimation))
        return self
    }
    
    /// Stops the animation in the receiver.
    /// - Returns: self
    @discardableResult
    public func stopAnimation() -> Self {
        addAttribute(#selector(UIView.argokit_stopAnimation))
        return self
    }
}
