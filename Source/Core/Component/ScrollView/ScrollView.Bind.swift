//
//  ScrollView.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension ScrollView {
    /// Set the cotentOffset of the UIScrollView behind the wrapper.
    /// - Parameter value: the new offset
    /// - Returns: self
    @discardableResult
    public func contentOffset(_ value: @escaping @autoclosure () -> CGPoint) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.contentOffset),value())
		}, forKey: #function)
    }
    
    /// Get the cotent offset of the UIScrollView.
    public func contentOffset() -> CGPoint {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.contentOffset
        }
        return CGPoint.zero
    }
    
    /// Set the content size
    /// - Parameter value: the new size
    /// - Returns: self
    @discardableResult
    public func contentSize(_ value: @escaping @autoclosure () -> CGSize) -> Self {
		return self.bindCallback({ [self] in 
			pNode?.contentSize(value())
		}, forKey: #function)
    }
    
    /// Get the cotent size of the UIScrollView.
    public func contentSize() -> CGSize {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.contentSize
        }
        return CGSize.zero
    }
    
    /// Set the content width
    /// - Parameter value: new width
    /// - Returns: self
    @discardableResult
    public func contentWidth(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			pNode?.contentWidth(value())
		}, forKey: #function)
    }
    
    /// Set the content height
    /// - Parameter value: new height
    /// - Returns: self
    @discardableResult
    public func contentHeight(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			pNode?.contentHeight(value())
		}, forKey: #function)
    }
    
    /// Set the content inset of the UIScrollView behind the wrapper.
    /// - Parameter value: new content inste
    /// - Returns: self
    @discardableResult
    public func contentInset(_ value: @escaping @autoclosure () -> UIEdgeInsets) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.contentInset),value())
		}, forKey: #function)
    }
    
    /// Get the cotent inset of the UIScrollView.
    public func contentInset() -> UIEdgeInsets {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.contentInset
        }
        return UIEdgeInsets.zero
    }
    
    /// Set the contentInsetAdjustmentBehavior of the UIScrollview behind the wrapper.
    /// - Parameter value: new value
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ value: @escaping @autoclosure () -> UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.contentInsetAdjustmentBehavior),value().rawValue)
		}, forKey: #function)
    }
    
    /// Set automaticallyAdjustsScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: true to adjust automatically
    /// - Returns: self
    @available(iOS 13.0, *)
    @discardableResult
    public func automaticallyAdjustsScrollIndicatorInsets(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.automaticallyAdjustsScrollIndicatorInsets),value())
		}, forKey: #function)
    }
    
    /// call the isDirectionalLockEnabled of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether scrolling is disabled in a particular direction.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func isDirectionalLockEnabled(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.isDirectionalLockEnabled),value())
		}, forKey: #function)
    }
    
    /// Set the bounces of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func bounces(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.bounces),value())
		}, forKey: #function)
    }
    
    /// Get the bounces of the UIScrollView.
    public func bounces() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.bounces
        }
        return true
    }
    
    /// Set the alwaysBounceVertical of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func alwaysBounceVertical(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.alwaysBounceVertical),value())
		}, forKey: #function)
    }
    
    /// Get the alwaysBounceVertical of the UIScrollView.
    public func alwaysBounceVertical() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.alwaysBounceVertical
        }
        return false
    }
    
    /// Set the alwaysBounceHorizontal of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func alwaysBounceHorizontal(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.alwaysBounceHorizontal),value())
		}, forKey: #function)
    }
    
    /// Get the alwaysBounceHorizontal of the UIScrollView.
    public func alwaysBounceHorizontal() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.alwaysBounceHorizontal
        }
        return false
    }
    
    ///Set the isPagingEnabled of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that determines whether paging is enabled for the scroll view.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func isPagingEnabled(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.isPagingEnabled),value())
		}, forKey: #function)
    }
    
    /// Get the isPagingEnabled of the UIScrollView.
    public func isPagingEnabled() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isPagingEnabled
        }
        return false
    }
    
    /// Set the isScrollEnabled of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that determines whether scrolling is enabled.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func scrollEnabled(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.isScrollEnabled),value())
		}, forKey: #function)
    }
    
    /// Get the isScrollEnabled of the UIScrollView.
    public func isScrollEnabled() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isScrollEnabled
        }
        return true
    }
    
    /// Set the showsVerticalScrollIndicator of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether the vertical scroll indicator is visible.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsVerticalScrollIndicator(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value())
		}, forKey: #function)
    }
    
    /// Get the showsVerticalScrollIndicator of the UIScrollView.
    public func showsVerticalScrollIndicator() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.showsVerticalScrollIndicator
        }
        return true
    }
    
    ///Set the showsHorizontalScrollIndicator of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether the horizontal scroll indicator is visible.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsHorizontalScrollIndicator(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value())
		}, forKey: #function)
    }
    
    /// Get the showsHorizontalScrollIndicator of the UIScrollView.
    public func showsHorizontalScrollIndicator() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.showsHorizontalScrollIndicator
        }
        return true
    }
    
    /// Set both showsVerticalScrollIndicator and showsHorizontalScrollIndicator at the same time.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsScrollIndicator(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value())
			addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value())
		}, forKey: #function)
    }
    
    /// Call the delaysContentTouches of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func delaysContentTouches(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.delaysContentTouches),value())
		}, forKey: #function)
    }
    
    /// Call the canCancelContentTouches of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether touches in the content view always lead to tracking.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func canCancelContentTouches(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.canCancelContentTouches),value())
		}, forKey: #function)
    }
    
    /// Call the minimumZoomScale of the UIScrollView behind the wrapper.
    ///
    ///A floating-point value that specifies the minimum scale factor that can be applied to the scroll view's content.
    /// - Parameter value: new point value
    /// - Returns: self
    @discardableResult
    public func minimumZoomScale(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.minimumZoomScale),value())
		}, forKey: #function)
    }
    
    /// Call the maximumZoomScale of the UIScrollView behind the wrapper.
    ///
    ///A floating-point value that specifies the maximum scale factor that can be applied to the scroll view's content.
    /// - Parameter value: new point value
    /// - Returns: self
    @discardableResult
    public func maximumZoomScale(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.maximumZoomScale),value())
		}, forKey: #function)
    }
    
    /// Call the zoomScale of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that specifies the current scale factor applied to the scroll view's content.
    /// - Parameter value: new float value
    /// - Returns: self
    @discardableResult
    public func zoomScale(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.zoomScale),value())
		}, forKey: #function)
    }
    
    /// Call the setZoomScale of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that specifies the current zoom scale.
    /// - Parameters:
    ///   - scale: The new value to scale the content to.
    ///   - animated: true to animate the transition to the new scale, false to make the transition immediate.
    /// - Returns: self
    @discardableResult
    public func setZoomScale(_ scale: @escaping @autoclosure () -> CGFloat, animated: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIScrollView.setZoomScale(_:animated:)), scale(), animated())
		}, forKey: #function)
    }
    
    /// Call the zoom of the UIScrollView behind the wrapper.
    ///
    /// Zooms to a specific area of the content so that it is visible in the receiver.
    /// - Parameters:
    ///   - rect: A rectangle defining an area of the content view. The rectangle should be in the coordinate space of the view returned by viewForZooming(in:).
    ///   - animated: true if the scrolling should be animated, false if it should be immediate.
    /// - Returns: self
    @discardableResult
    public func zoom(to rect: @escaping @autoclosure () -> CGRect, animated: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(UIScrollView.zoom(to:animated:)), rect(), animated())
		}, forKey: #function)
    }
    
    /// Call the bouncesZoom of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether the scroll view animates the content scaling when the scaling exceeds the maximum or minimum limits.
    /// - Parameter value: new Boolean value
    /// - Returns: self
    @discardableResult
    public func bouncesZoom(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.bouncesZoom),value())
		}, forKey: #function)
    }
    
    /// Set the scrollsToTop of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that controls whether the scroll-to-top gesture is enabled.
    /// - Parameter value: new Boolean value
    /// - Returns: self
    @discardableResult
    public func scrollsToTop(_ value: @escaping @autoclosure () -> Bool) -> Self {
		return self.bindCallback({ [self] in 
			addAttribute(#selector(setter:UIScrollView.scrollsToTop),value())
		}, forKey: #function)
    }
    

}

extension ScrollView{
    @discardableResult
    public func adjustsHeightToFitSubView(_ value: @escaping @autoclosure () -> Bool) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.adjustsHeightToFitSubView = value()
                node.height(point: 0)
            }
        }, forKey: #function)
    }
}


extension ScrollView{
    @available(*, deprecated, message: "ScrollView、List、Grid does not support the method!Please use contentInset and contentSize")
    @discardableResult
    public func padding(top: @escaping @autoclosure () -> ArgoValue, right: @escaping @autoclosure () -> ArgoValue, bottom: @escaping @autoclosure () -> ArgoValue, left: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self
    }
    
    @available(*, deprecated, message: "ScrollView、List、Grid does not support the method!Please use contentInset and contentSize")
    @discardableResult
    public func padding(edge: @escaping @autoclosure () -> ArgoEdge, value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self
    }
}
