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
    public func contentOffset(_ value: CGPoint) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentOffset),value)
        return self
    }
    
    /// Set the content size
    /// - Parameter value: the new size
    /// - Returns: self
    @discardableResult
    public func contentSize(_ value: CGSize) -> Self {
        pNode?.contentSize(value)
        return self
    }
    
    /// Set the content width
    /// - Parameter value: new width
    /// - Returns: self
    @discardableResult
    public func contentWidth(_ value: CGFloat) -> Self {
        pNode?.contentWidth(value)
        return self
    }
    
    /// Set the content height
    /// - Parameter value: new height
    /// - Returns: self
    @discardableResult
    public func contentHeight(_ value: CGFloat) -> Self {
        pNode?.contentHeight(value)
        return self
    }
    
    /// Set the content inset of the UIScrollView behind the wrapper.
    /// - Parameter value: new content inste
    /// - Returns: self
    @discardableResult
    public func contentInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInset),value)
        return self
    }
    
    /// Set the contentInsetAdjustmentBehavior of the UIScrollview behind the wrapper.
    /// - Parameter value: new value
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInsetAdjustmentBehavior),value.rawValue)
        return self
    }
    
    /// Set automaticallyAdjustsScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: true to adjust automatically
    /// - Returns: self
    @available(iOS 13.0, *)
    @discardableResult
    public func automaticallyAdjustsScrollIndicatorInsets(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.automaticallyAdjustsScrollIndicatorInsets),value)
        return self
    }
    
    /// call the isDirectionalLockEnabled of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether scrolling is disabled in a particular direction.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func isDirectionalLockEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isDirectionalLockEnabled),value)
        return self
    }
    
    /// Set the bounces of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func bounces(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bounces),value)
        return self
    }
    
    /// Set the alwaysBounceVertical of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func alwaysBounceVertical(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceVertical),value)
        return self
    }
    
    /// Set the alwaysBounceHorizontal of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func alwaysBounceHorizontal(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceHorizontal),value)
        return self
    }
    
    ///Set the isPagingEnabled of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that determines whether paging is enabled for the scroll view.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func isPagingEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isPagingEnabled),value)
        return self
    }
    
    /// Set the isScrollEnabled of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that determines whether scrolling is enabled.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func scrollEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isScrollEnabled),value)
        return self
    }
    
    /// Set the showsVerticalScrollIndicator of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether the vertical scroll indicator is visible.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsVerticalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value)
        return self
    }
    
    ///Set the showsHorizontalScrollIndicator of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether the horizontal scroll indicator is visible.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsHorizontalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value)
        return self
    }
    
    /// Set both showsVerticalScrollIndicator and showsHorizontalScrollIndicator at the same time.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func showsScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value)
        addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value)
        return self
    }
    
    /// Call the delaysContentTouches of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func delaysContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.delaysContentTouches),value)
        return self
    }
    
    /// Call the canCancelContentTouches of the UIScrollView behind the wrapper.
    ///
    ///A Boolean value that controls whether touches in the content view always lead to tracking.
    /// - Parameter value: new value
    /// - Returns: self
    @discardableResult
    public func canCancelContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.canCancelContentTouches),value)
        return self
    }
    
    /// Call the minimumZoomScale of the UIScrollView behind the wrapper.
    ///
    ///A floating-point value that specifies the minimum scale factor that can be applied to the scroll view's content.
    /// - Parameter value: new point value
    /// - Returns: self
    @discardableResult
    public func minimumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.minimumZoomScale),value)
        return self
    }
    
    /// Call the maximumZoomScale of the UIScrollView behind the wrapper.
    ///
    ///A floating-point value that specifies the maximum scale factor that can be applied to the scroll view's content.
    /// - Parameter value: new point value
    /// - Returns: self
    @discardableResult
    public func maximumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.maximumZoomScale),value)
        return self
    }
    
    /// Call the zoomScale of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that specifies the current scale factor applied to the scroll view's content.
    /// - Parameter value: new float value
    /// - Returns: self
    @discardableResult
    public func zoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.zoomScale),value)
        return self
    }
    
    /// Call the setZoomScale of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that specifies the current zoom scale.
    /// - Parameters:
    ///   - scale: The new value to scale the content to.
    ///   - animated: true to animate the transition to the new scale, false to make the transition immediate.
    /// - Returns: self
    @discardableResult
    public func setZoomScale(_ scale: CGFloat, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setZoomScale(_:animated:)), scale, animated)
        return self
    }
    
    /// Call the zoom of the UIScrollView behind the wrapper.
    ///
    /// Zooms to a specific area of the content so that it is visible in the receiver.
    /// - Parameters:
    ///   - rect: A rectangle defining an area of the content view. The rectangle should be in the coordinate space of the view returned by viewForZooming(in:).
    ///   - animated: true if the scrolling should be animated, false if it should be immediate.
    /// - Returns: self
    @discardableResult
    public func zoom(to rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.zoom(to:animated:)), rect, animated)
        return self
    }
    
    /// Call the bouncesZoom of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that determines whether the scroll view animates the content scaling when the scaling exceeds the maximum or minimum limits.
    /// - Parameter value: new Boolean value
    /// - Returns: self
    @discardableResult
    public func bouncesZoom(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bouncesZoom),value)
        return self
    }
    
    /// Set the scrollsToTop of the UIScrollView behind the wrapper.
    ///
    /// A Boolean value that controls whether the scroll-to-top gesture is enabled.
    /// - Parameter value: new Boolean value
    /// - Returns: self
    @discardableResult
    public func scrollsToTop(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollsToTop),value)
        return self
    }
}
