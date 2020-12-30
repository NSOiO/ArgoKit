//
//  ActivityIndicatorView.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension ActivityIndicatorView {
    /// Sets the basic appearance of the activity indicator.
    /// - Parameter value: The basic appearance of the activity indicator.
    /// - Returns: self
    @discardableResult
    public func style(_ value: UIActivityIndicatorView.Style) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.style),value.rawValue)
        return self
    }
    
    /// Sets a Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Parameter value: A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Returns: self
    @discardableResult
    public func hidesWhenStopped(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.hidesWhenStopped),value)
        return self
    }
    
    /// Sets the color of the activity indicator.
    /// - Parameter value: The color of the activity indicator.
    /// - Returns: self
    @discardableResult
    public func color(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.color),value)
        return self
    }
}
