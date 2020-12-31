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
    public func style(_ value: @escaping @autoclosure () -> UIActivityIndicatorView.Style) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIActivityIndicatorView.style),value().rawValue)
		}, forKey: #function)
    }
    
    /// Sets a Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Parameter value: A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Returns: self
    @discardableResult
    public func hidesWhenStopped(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIActivityIndicatorView.hidesWhenStopped),value())
		}, forKey: #function)
    }
    
    /// Sets the color of the activity indicator.
    /// - Parameter value: The color of the activity indicator.
    /// - Returns: self
    @discardableResult
    public func color(_ value: @escaping @autoclosure () -> UIColor) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIActivityIndicatorView.color),value())
		}, forKey: #function)
    }
}
