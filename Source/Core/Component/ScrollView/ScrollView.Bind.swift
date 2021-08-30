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
    
    /// When contentInsetAdjustmentBehavior allows, UIScrollView may incorporate
    /// its safeAreaInsets into the adjustedContentInset.
    @available(iOS 11.0, *)
    public func adjustedContentInset() -> UIEdgeInsets {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.adjustedContentInset
        }
        return UIEdgeInsets.zero
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
    
    /// Get automaticallyAdjustsScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Returns: Bool
    @available(iOS 13.0, *)
    @discardableResult
    public func automaticallyAdjustsScrollIndicatorInsets() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.automaticallyAdjustsScrollIndicatorInsets
        }
        return true
    }
    
    /// The layout guide based on the untranslated content rectangle of the scroll view.
    /// Use this layout guide when you want to create Auto Layout constraints related to the content area of a scroll view.
    @available(iOS 11.0, *)
    @discardableResult
    public func contentLayoutGuide() -> UILayoutGuide {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.contentLayoutGuide
        }
        return UILayoutGuide()
    }
    
    /// The layout guide based on the untransformed frame rectangle of the scroll view.
    /// Use this layout guide when you want to create Auto Layout constraints that explicitly involve the frame rectangle of the scroll view itself, as opposed to its content rectangle.
    @available(iOS 11.0, *)
    @discardableResult
    public func frameLayoutGuide() -> UILayoutGuide {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.frameLayoutGuide
        }
        return UILayoutGuide()
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
    
    /// default NO. if YES, try to lock vertical or horizontal scrolling while dragging
    @discardableResult
    public func isDirectionalLockEnabled() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isDirectionalLockEnabled
        }
        return false
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
    
    /// Set the indicatorStyle of the UIScrollView behind the wrapper.
    ///
    /// The style of the scroll indicators. The default style is UIScrollView.IndicatorStyle.default.
    /// - Parameter value: new style
    /// - Returns: self
    @available(iOS 11.1, *)
    @discardableResult
    public func indicatorStyle(_ value: @escaping @autoclosure () -> UIScrollView.IndicatorStyle) -> Self {
        return self.bindCallback({ [self] in
            let value_ = value()
            addAttribute(#selector(setter:UIScrollView.indicatorStyle),value_.rawValue)
        }, forKey: #function)
    }
    
    @available(iOS 11.1, *)
    public func showsVerticalScrollIndicator() -> UIScrollView.IndicatorStyle {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.indicatorStyle
        }
        return .default
    }
    
    /// Set the verticalScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new insets
    /// - Returns: self
    @available(iOS 11.1, *)
    @discardableResult
    public func verticalScrollIndicatorInsets(_ value:  @escaping @autoclosure () -> UIEdgeInsets) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.verticalScrollIndicatorInsets),value())
        }, forKey: #function)
    }
    
    @available(iOS 11.1, *)
    @discardableResult
    public func verticalScrollIndicatorInsets() -> UIEdgeInsets {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.verticalScrollIndicatorInsets
        }
        return UIEdgeInsets.zero
    }
    
    /// Set the horizontalScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new insets
    /// - Returns: self
    @available(iOS 11.1, *)
    @discardableResult
    public func horizontalScrollIndicatorInsets(_ value: @escaping @autoclosure () -> UIEdgeInsets) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.horizontalScrollIndicatorInsets),value())
        }, forKey: #function)
    }
    
    @available(iOS 11.1, *)
    public func horizontalScrollIndicatorInsets() -> UIEdgeInsets {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.horizontalScrollIndicatorInsets
        }
        return UIEdgeInsets.zero
    }
    
    /// Set the scrollIndicatorInsets of the UIScrollView behind the wrapper.
    ///
    /// Set the scrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new UIEdgeInsets value
    /// - Returns: self
    @discardableResult
    public func scrollIndicatorInsets(_ value: @escaping @autoclosure () -> UIEdgeInsets) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.scrollIndicatorInsets),value)
        }, forKey: #function)
    }
    
    public func scrollIndicatorInsets() -> UIEdgeInsets {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.scrollIndicatorInsets
        }
        return UIEdgeInsets.zero
    }
    
    /// Set the decelerationRate of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that determines the rate of deceleration after the user lifts their finger.
    /// - Parameter value: new rate
    /// - Returns: self
    @discardableResult
    public func decelerationRate(_ value: @escaping @autoclosure () -> UIScrollView.DecelerationRate) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.scrollIndicatorInsets),value().rawValue)
        }, forKey: #function)
    }
    
    public func decelerationRate() -> UIScrollView.DecelerationRate {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.decelerationRate
        }
        return UIScrollView.DecelerationRate(rawValue: 0)
    }
    
    /// Set the indexDisplayMode of the UIScrollView behind the wrapper.
    ///
    /// The manner in which the index is shown while the user is scrolling.
    /// - Parameter value: new mode
    /// - Returns: self
    @discardableResult
    public func indexDisplayMode(_ value:  @escaping @autoclosure () -> UIScrollView.IndexDisplayMode) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.indexDisplayMode),value().rawValue)
        }, forKey: #function)
    }
    
    public func indexDisplayMode() -> UIScrollView.IndexDisplayMode {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.indexDisplayMode
        }
        return .automatic
    }
    
    /// Set the ContentOffset of the UIScrollView behind the wrapper.
    ///
    /// Sets th@objc e offset from the content view’s origin that corresponds to the receiver’s origin.
    /// - Parameters:
    ///   - contentOffset: A point (expressed in points) that is offset from the content view’s origin.
    ///   - animated: true to animate the transition at a constant velocity to the new offset, false to make the transition immediate.
    /// - Returns: self
    @discardableResult
    public func setContentOffset(_ contentOffset: @escaping @autoclosure () -> CGPoint, animated: Bool) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(UIScrollView.setContentOffset(_:animated:)), contentOffset(), animated)
        }, forKey: #function)
    }
    
    ///  Call the scrollRectToVisible of the UIScrollView behind the wrapper.
    ///
    ///  Scrolls a specific area of the content so that it is visible in the receiver.
    /// - Parameters:
    ///   - rect: A rectangle defining an area of the content view. The rectangle should be in the coordinate space of the scroll view.
    ///   - animated: true if the scrolling should be animated, false if it should be immediate.
    /// - Returns: self
    @discardableResult
    public func scrollRectToVisible(_ rect:  @escaping @autoclosure () -> CGRect, animated: Bool) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(UIScrollView.scrollRectToVisible(_:animated:)), rect(), animated)
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
    
    public func delaysContentTouches() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.delaysContentTouches
        }
        return true
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
    
    public func canCancelContentTouches() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.canCancelContentTouches
        }
        return true
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
    
    public func minimumZoomScale() -> CGFloat {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.minimumZoomScale
        }
        return 1.0
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
    
    public func maximumZoomScale() -> CGFloat {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.maximumZoomScale
        }
        return 1.0
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
    
    public func zoomScale() -> CGFloat {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.zoomScale
        }
        return 1.0
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
    
    public func bouncesZoom() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.bouncesZoom
        }
        return true
    }
    
    // returns YES if user in zoom gesture
    public func isZooming() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isZooming
        }
        return true
    }
    
    // returns YES if we are in the middle of zooming back to the min/max value
    public func isZoomBouncing() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isZoomBouncing
        }
        return true
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
    
    // default is YES.
    public func scrollsToTop() -> Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.scrollsToTop
        }
        return true
    }
    
    // Use these accessors to configure the scroll view's built-in gesture recognizers.
    // Do not change the gestures' delegates or override the getters for these properties.
    
    // Change `panGestureRecognizer.allowedTouchTypes` to limit scrolling to a particular set of touch types.
    public func panGestureRecognizer() -> UIPanGestureRecognizer {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.panGestureRecognizer
        }
        return UIPanGestureRecognizer()
    }
    
    public func pinchGestureRecognizer() -> UIPinchGestureRecognizer? {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.pinchGestureRecognizer
        }
        return nil
    }
    
    public func directionalPressGestureRecognizer() -> UIGestureRecognizer {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.directionalPressGestureRecognizer
        }
        return UIGestureRecognizer()
    }
    
    /// Set the keyboardDismissMode of the UIScrollView behind the wrapper.
    ///
    /// The manner in which the keyboard is dismissed when a drag begins in the scroll view.
    /// - Parameter value: new mode
    /// - Returns: self
    @discardableResult
    public func keyboardDismissMode(_ value:  @escaping @autoclosure () -> UIScrollView.KeyboardDismissMode) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.keyboardDismissMode),value().rawValue)
        }, forKey: #function)
    }
    
    public func keyboardDismissMode() -> UIScrollView.KeyboardDismissMode {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.keyboardDismissMode
        }
        return .none
    }
    
    /// Set the refreshControl of the UIScrollView behind the wrapper.
    ///
    /// The refresh control associated with the scroll view.
    /// - Parameter value: new UIRefreshControl value
    /// - Returns: self
    @available(iOS 10.0, *)
    @discardableResult
    public func refreshControl(_ value:   @escaping @autoclosure () -> UIRefreshControl) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:UIScrollView.keyboardDismissMode),value())
        }, forKey: #function)
    }
    
    public func refreshControl() -> UIRefreshControl? {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.refreshControl
        }
        return nil
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
