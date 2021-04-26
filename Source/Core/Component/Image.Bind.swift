//
//  Image.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Image {
    /// Sets the displayed image.
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: self
    @discardableResult
    public func image(url: @escaping @autoclosure () -> URL?, placeholder: @escaping @autoclosure () -> String?) -> Self {
		return self.bindCallback({ [self] in 
			pNode.image(url: url(), placeholder: placeholder())
		}, forKey: #function)
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: self
    @discardableResult
    public func image(urlString: @escaping @autoclosure () -> String?, placeholder: @escaping @autoclosure () -> String?) -> Self {
        return self.bindCallback({
            var url:URL? = nil
            if let urlString = urlString() {
                url = URL(string: urlString)
            }
            pNode.image(url: url, placeholder: placeholder())
        }, forKey: #function)
    }
    
    /// Sets the highlighted image displayed in the image view.
    /// - Parameter value: The highlighted image displayed in the image view.
    /// - Returns: self
    @discardableResult
    public func highlightedImage(_ value: @escaping @autoclosure () -> UIImage?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.highlightedImage),value())
		}, forKey: #function)
    }
    
    /// Sets the configuration values to use when rendering the image.
    /// - Parameter value: The configuration values to use when rendering the image.
    /// - Returns: self
    @available(iOS 13.0, *)
    @discardableResult
    public func preferredSymbolConfiguration(_ value: @escaping @autoclosure () -> UIImage.SymbolConfiguration?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.preferredSymbolConfiguration),value())
		}, forKey: #function)
    }
    
    /// Sets a Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Parameter value: A Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Returns: self
    @discardableResult
    public func userInteractionEnabled(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.isUserInteractionEnabled),value())
		}, forKey: #function)
    }
    
    /// Sets a Boolean value that determines whether the image is highlighted.
    /// - Parameter value: A Boolean value that determines whether the image is highlighted.
    /// - Returns: self
    @discardableResult
    public func isHighlighted(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.isHighlighted),value())
		}, forKey: #function)
    }
    
    /// Sets an array of UIImage objects to use for an animation.
    /// - Parameter value: An array of UIImage objects to use for an animation.
    /// - Returns: self
    @discardableResult
    public func animationImages(_ value: @escaping @autoclosure () -> [UIImage]?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.animationImages),value())
		}, forKey: #function)
    }
    
    /// Sets an array of UIImage objects to use for an animation when the view is highlighted.
    /// - Parameter value: An array of UIImage objects to use for an animation when the view is highlighted.
    /// - Returns: self
    @discardableResult
    public func highlightedAnimationImages(_ value: @escaping @autoclosure () -> [UIImage]?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.highlightedAnimationImages),value())
		}, forKey: #function)
    }
    
    /// Sets the amount of time it takes to go through one cycle of the images.
    /// - Parameter value: The amount of time it takes to go through one cycle of the images.
    /// - Returns: self
    @discardableResult
    public func animationDuration(_ value: @escaping @autoclosure () -> TimeInterval) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.animationDuration),value())
		}, forKey: #function)
    }
    
    
    /// Specifies the number of times to repeat the animation.
    /// - Parameter value: the number of times to repeat the animation.
    /// - Returns: self
    @discardableResult
    public func animationRepeatCount(_ value: @escaping @autoclosure () -> Int) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.animationRepeatCount),value())
		}, forKey: #function)
    }
    
    /// Sets a color used to tint template images in the view hierarchy.
    /// - Parameter value: A color used to tint template images in the view hierarchy.
    /// - Returns: self
    @discardableResult
    public func tintColor(_ value: @escaping @autoclosure () -> UIColor) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.tintColor),value())
		}, forKey: #function)
    }
    
    /// Sets the displayed image.
    /// - Parameter value: The image displayed in the image view.
    /// - Returns: self
    @discardableResult
    public func image(_ value: @escaping @autoclosure () -> UIImage?) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIImageView.image),value())
		}, forKey: #function)
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - value: The image displayed in the image view.
    ///   - placeholder: The placeholder image displayed in the image view if the value invalid
    /// - Returns: self
    @discardableResult
    public func image(_ value: @escaping @autoclosure () -> UIImage?, placeholder: @escaping @autoclosure () -> UIImage?) -> Self {
		return self.bindCallback({ [self] in 
			self.image(value() ?? placeholder())
		}, forKey: #function)
    }
}
