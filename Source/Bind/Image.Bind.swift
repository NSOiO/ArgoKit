//
//  Image.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Image {
    /// Sets the highlighted image displayed in the image view.
    /// - Parameter value: The highlighted image displayed in the image view.
    /// - Returns: self
    @discardableResult
    public func highlightedImage(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.highlightedImage),value)
        return self
    }
    
    /// Sets the configuration values to use when rendering the image.
    /// - Parameter value: The configuration values to use when rendering the image.
    /// - Returns: self
    @available(iOS 13.0, *)
    @discardableResult
    public func preferredSymbolConfiguration(_ value: UIImage.SymbolConfiguration?) -> Self {
        addAttribute(#selector(setter:UIImageView.preferredSymbolConfiguration),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Parameter value: A Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Returns: self
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isUserInteractionEnabled),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether the image is highlighted.
    /// - Parameter value: A Boolean value that determines whether the image is highlighted.
    /// - Returns: self
    @discardableResult
    public func isHighlighted(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isHighlighted),value)
        return self
    }
    
    /// Sets an array of UIImage objects to use for an animation.
    /// - Parameter value: An array of UIImage objects to use for an animation.
    /// - Returns: self
    @discardableResult
    public func animationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.animationImages),value)
        return self
    }
    
    /// Sets an array of UIImage objects to use for an animation when the view is highlighted.
    /// - Parameter value: An array of UIImage objects to use for an animation when the view is highlighted.
    /// - Returns: self
    @discardableResult
    public func highlightedAnimationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.highlightedAnimationImages),value)
        return self
    }
    
    /// Sets the amount of time it takes to go through one cycle of the images.
    /// - Parameter value: The amount of time it takes to go through one cycle of the images.
    /// - Returns: self
    @discardableResult
    public func animationDuration(_ value: TimeInterval) -> Self {
        addAttribute(#selector(setter:UIImageView.animationDuration),value)
        return self
    }
    
    
    /// Specifies the number of times to repeat the animation.
    /// - Parameter value: the number of times to repeat the animation.
    /// - Returns: self
    @discardableResult
    public func animationRepeatCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UIImageView.animationRepeatCount),value)
        return self
    }
    
    /// Sets a color used to tint template images in the view hierarchy.
    /// - Parameter value: A color used to tint template images in the view hierarchy.
    /// - Returns: self
    @discardableResult
    public func tintColor(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIImageView.tintColor),value)
        return self
    }
    
    /// Sets the displayed image.
    /// - Parameter value: The image displayed in the image view.
    /// - Returns: self
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.image),value)
        return self
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - value: The image displayed in the image view.
    ///   - placeholder: The placeholder image displayed in the image view if the value invalid
    /// - Returns: self
    @discardableResult
    public func image(_ value: UIImage?, placeholder: UIImage?) -> Self {
        return self.image(value ?? placeholder)
    }
}
