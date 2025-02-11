//
//  ProgressView.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension ProgressView {
    /// Set current graphical style of the receiver.
    ///
    /// The value of this property is a constant that specifies the style of the progress view. The default style is UIProgressView.Style.default. For more on these constants, see UIProgressView.Style.
    /// - Parameter value: current style
    /// - Returns: self
    @discardableResult
    public func progressViewStyle(_ value: @escaping @autoclosure () -> UIProgressView.Style) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.progressViewStyle),value().rawValue)
		}, forKey: #function)
    }
    /// Set current progress shown by the receiver.
    ///
    ///The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
    /// - Parameter value: the number
    /// - Returns: self
    @discardableResult
    public func progress(_ value: @escaping @autoclosure () -> Float) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.progress),value())
		}, forKey: #function)
    }
    /// Set the color shown for the portion of the progress bar that is filled.
    /// - Parameter value: the color
    /// - Returns: self
    @discardableResult
    public func progressTintColor(_ value: @escaping @autoclosure () -> UIColor?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.progressTintColor),value())
		}, forKey: #function)
    }
    /// Set color shown for the portion of the progress bar that is not filled.
    /// - Parameter value: the color
    /// - Returns: self
    @discardableResult
    public func trackTintColor(_ value: @escaping @autoclosure () -> UIColor?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.trackTintColor),value())
		}, forKey: #function)
    }
    /// Set An image to use for the portion of the progress bar that is filled.
    /// - Parameter value: an image
    /// - Returns: self
    @discardableResult
    public func progressImage(_ value: @escaping @autoclosure () -> UIImage?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.progressImage),value())
		}, forKey: #function)
    }
    /// Set An image to use for the portion of the track that is not filled.
    /// - Parameter value: an image
    /// - Returns: self
    @discardableResult
    public func trackImage(_ value: @escaping @autoclosure () -> UIImage?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.trackImage),value())
		}, forKey: #function)
    }
    /// Adjusts the current progress shown by the receiver, optionally animating the change.
    ///
    /// The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
    /// - Parameters:
    ///   - value: The new progress value.
    ///   - animated: true if the change should be animated, false if the change should happen immediately.
    /// - Returns: self
    @discardableResult
    public func setProgress(_ value: @escaping @autoclosure () -> Float, animated: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIProgressView.setProgress),value(),animated())
		}, forKey: #function)
    }
    
    /// The progress object to use for updating the progress view.
    ///
    /// When this property is set, the progress view updates its progress value automatically using information it receives from the Progress object. (Progress updates are animated.) Set the property to nil when you want to update the progress manually. The default value of this property is nil.
    ///For more information about configuring a progress object to manage progress information, see Progress.
    /// - Parameter value: the new progress object
    /// - Returns: self
    @available(iOS 9.0, *)
    @discardableResult
    public func observedProgress(_ value: @escaping @autoclosure () -> Progress?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIProgressView.observedProgress),value())
		}, forKey: #function)
    }
}
