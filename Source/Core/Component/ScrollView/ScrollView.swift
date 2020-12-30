//
//  ScrollView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

/// Wrapper of UIScrollView
public class ScrollView: View {
    var pNode : ArgoKitScrollViewNode?
    
    /// the node behind the ScrollView
    public var node: ArgoKitNode? {
        pNode
    }
    
    required public init() {
        createNode()
    }
    
    /// init the ScrollView
    /// - Parameter builder: view builder used for ScrollView
    public convenience init(@ArgoKitViewBuilder builder:@escaping () -> View) {
        self.init()
        addSubViews(builder: builder)
    }
    
    func createNode() {
        let node = ArgoKitScrollViewNode(viewClass: UIScrollView.self)
        node.createContentNode()
        pNode = node
    }
}

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

    /// Called when the adjusted content insets of the scroll view change.
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func adjustedContentInsetDidChange() -> Self {
        addAttribute(#selector(UIScrollView.adjustedContentInsetDidChange))
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
    
    /// Set the indicatorStyle of the UIScrollView behind the wrapper.
    ///
    /// The style of the scroll indicators. The default style is UIScrollView.IndicatorStyle.default.
    /// - Parameter value: new style
    /// - Returns: self
    @discardableResult
    public func indicatorStyle(_ value: UIScrollView.IndicatorStyle) -> Self {
        addAttribute(#selector(setter:UIScrollView.indicatorStyle),value.rawValue)
        return self
    }
    
    /// Set the verticalScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new insets
    /// - Returns: self
    @available(iOS 11.1, *)
    @discardableResult
    public func verticalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.verticalScrollIndicatorInsets),value)
        return self
    }
    
    /// Set the horizontalScrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new insets
    /// - Returns: self
    @available(iOS 11.1, *)
    @discardableResult
    public func horizontalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.horizontalScrollIndicatorInsets),value)
        return self
    }
    
    /// Set the scrollIndicatorInsets of the UIScrollView behind the wrapper.
    ///
    /// Set the scrollIndicatorInsets of the UIScrollView behind the wrapper.
    /// - Parameter value: new UIEdgeInsets value
    /// - Returns: self
    @discardableResult
    public func scrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollIndicatorInsets),value)
        return self
    }
    
    /// Set the decelerationRate of the UIScrollView behind the wrapper.
    ///
    /// A floating-point value that determines the rate of deceleration after the user lifts their finger.
    /// - Parameter value: new rate
    /// - Returns: self
    @discardableResult
    public func decelerationRate(_ value: UIScrollView.DecelerationRate) -> Self {
        addAttribute(#selector(setter:UIScrollView.decelerationRate),value.rawValue)
        return self
    }
    
    /// Set the indexDisplayMode of the UIScrollView behind the wrapper.
    ///
    /// The manner in which the index is shown while the user is scrolling.
    /// - Parameter value: new mode
    /// - Returns: self
    @discardableResult
    public func indexDisplayMode(_ value: UIScrollView.IndexDisplayMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.indexDisplayMode),value.rawValue)
        return self
    }
    
    /// Set the ContentOffset of the UIScrollView behind the wrapper.
    ///
    /// Sets the offset from the content view’s origin that corresponds to the receiver’s origin.
    /// - Parameters:
    ///   - contentOffset: A point (expressed in points) that is offset from the content view’s origin.
    ///   - animated: true to animate the transition at a constant velocity to the new offset, false to make the transition immediate.
    /// - Returns: self
    @discardableResult
    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setContentOffset(_:animated:)), contentOffset, animated)
        return self
    }
    
    ///  Call the scrollRectToVisible of the UIScrollView behind the wrapper.
    ///
    ///  Scrolls a specific area of the content so that it is visible in the receiver.
    /// - Parameters:
    ///   - rect: A rectangle defining an area of the content view. The rectangle should be in the coordinate space of the scroll view.
    ///   - animated: true if the scrolling should be animated, false if it should be immediate.
    /// - Returns: self
    @discardableResult
    public func scrollRectToVisible(_ rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.scrollRectToVisible(_:animated:)), rect, animated)
        return self
    }
    
    /// Call the flashScrollIndicators of the UIScrollView behind the wrapper.
    ///
    ///Displays the scroll indicators momentarily.
    /// - Returns: self
    @discardableResult
    public func flashScrollIndicators() -> Self {
        addAttribute(#selector(UIScrollView.flashScrollIndicators))
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
    
    /// Set the keyboardDismissMode of the UIScrollView behind the wrapper.
    ///
    /// The manner in which the keyboard is dismissed when a drag begins in the scroll view.
    /// - Parameter value: new mode
    /// - Returns: self
    @discardableResult
    public func keyboardDismissMode(_ value: UIScrollView.KeyboardDismissMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.keyboardDismissMode),value.rawValue)
        return self
    }
    
    /// Set the refreshControl of the UIScrollView behind the wrapper.
    ///
    /// The refresh control associated with the scroll view.
    /// - Parameter value: new UIRefreshControl value
    /// - Returns: self
    @available(iOS 10.0, *)
    @discardableResult
    public func refreshControl(_ value: UIRefreshControl) -> Self {
        addAttribute(#selector(setter:UIScrollView.refreshControl),value)
        return self
    }
}

extension ScrollView {
    /// Set the callback called when the user scrolls the content view within the receiver.
    /// - Parameter action: the callback
    /// - Returns: self
    @discardableResult
    public func didScroll(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScroll(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    /// Set the callback called when the scroll view’s zoom factor changed.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didZoom(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidZoom(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    /// Set the callback called when  the scroll view is about to start scrolling the content.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func willBeginDragging(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDragging(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    /// Set the callback called when the user finishes scrolling the content.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func willEndDragging(_ action: @escaping (_ velocity: CGPoint, _ targetContentOffset:  UnsafeMutablePointer<CGPoint>) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3 {
                let velocity: CGPoint = paramter![1] as! CGPoint
                let targetContentOffset: UnsafeMutablePointer<CGPoint> = paramter![2] as! UnsafeMutablePointer<CGPoint>
                action(velocity, targetContentOffset)
            }
            return nil
        })
        return self
    }
    
    /// Set the callback called when dragging ended in the scroll view.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didEndDragging(_ action: @escaping (_ decelerate: Bool) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndDragging(_:willDecelerate:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1 {
                let decelerate: Bool = paramter![0] as! Bool
                action(decelerate)
            }
            return nil
        })
        return self
    }
    
    /// Set the callback called when  the scroll view is starting to decelerate the scrolling movement.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func willBeginDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    /// Set the calback called when  the scroll view has ended decelerating the scrolling movement.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didEndDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    /// Set the callback called when a scrolling animation in the scroll view concludes.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didEndScrollingAnimation(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    /// Set the callback called for the view to scale when zooming is about to occur in the scroll view.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func viewForZooming(_ action: @escaping () -> UIView?) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.viewForZooming(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    /// Set the callback called when zooming of the content in the scroll view is about to commence.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func willBeginZooming(_ action: @escaping (_ view: UIView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginZooming(_:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let view: UIView = paramter![1] as! UIView
                action(view)
            } else {
                action(nil)
            }
            return nil
        })
        return self
    }
    
    /// Set the callback called when zooming of the content in the scroll view completed.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didEndZooming(_ action: @escaping (_ view: UIView?, _ atScale: Float) -> Void?) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndZooming(_:with:atScale:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3 {
                let view: UIView = paramter![1] as! UIView
                let scale: Float = paramter![2] as! Float
                action(view, scale)
            } else if paramter?.count ?? 0 >= 2 {
                let scale: Float = paramter![1] as! Float
                action(nil, scale)
            }
            return nil
        })
        return self
    }
    
    /// Set the calback that returns the Boolean value.
    ///  to determine if the scroll view should scroll to the top of the content.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func shouldScrollToTop(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewShouldScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    /// Set the callback called when the scroll view scrolled to the top of the content.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    public func didScrollToTop(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    /// Set the callback called when the scroll view's inset values changed.
    /// - Parameter action: callback
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func didChangeAdjustedContentInset(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidChangeAdjustedContentInset(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
}
