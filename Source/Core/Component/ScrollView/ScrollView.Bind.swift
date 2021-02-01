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
    
    /// Set the content size
    /// - Parameter value: the new size
    /// - Returns: self
    @discardableResult
    public func contentSize(_ value: @escaping @autoclosure () -> CGSize) -> Self {
		return self.bindCallback({ [self] in 
			pNode?.contentSize(value())
		}, forKey: #function)
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
            }
        }, forKey: #function)
    }
    /// Sets the height of this view.
    /// - Parameter value: The height of this view.
    /// - Returns: self
    @discardableResult
    public func height(_ value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.adjustsHeightToFitSubView = false
                if !node.setFlexGrow {
                    node.flexGrow(0)
                }
            }
            switch value(){
            case .point(let value):
                self.node?.height(point: value)
                break
            case .percent(let value):
                self.node?.height(percent: value)
                break
            case .auto:
                if let node = self.node as? ArgoKitScrollViewNode{
                    node.adjustsHeightToFitSubView = true
                    node.flexGrow(1)
                }
                break
            default:
                break
            }
        }, forKey: #function)
    }
    
    /// Sets how a flex item will grow or shrink to fit the space available in its flex container.
    /// - Parameter value: The value of flex.
    /// - Returns: self
    @discardableResult
    public func flex(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.adjustsHeightToFitSubView = false
                if !node.setFlexGrow {
                    node.flexGrow(0)
                }

            }
            self.node?.flex(value())
        }, forKey: #function)
    }
    
    /// Sets the flex grow factor of a flex item's main size.
    /// This property specifies how much of the remaining space in the flex container should be assigned to the item (the flex grow factor).
    /// - Parameter value: The value of grow.
    /// - Returns: self
    @discardableResult
    public func grow(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.setFlexGrow = true
                node.adjustsHeightToFitSubView = false
            }
            self.node?.flexGrow(value())
        }, forKey: #function)
    }
    
    /// Sets the flex shrink factor of a flex item. If the size of all flex items is larger than the flex container, items shrink to fit according to flex-shrink.
    /// - Parameter value: The value of shrink.
    /// - Returns: self
    @discardableResult
    public func shrink(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.adjustsHeightToFitSubView = false
                if !node.setFlexGrow {
                    node.flexGrow(0)
                }
            }
            self.node?.flexShrink(value())
        }, forKey: #function)
    }
    
    /// Sets the initial main size of a flex item.
    /// - Parameter value: The type of basis.
    /// - Returns: self
    @discardableResult
    public func basis(_ value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            if let node = self.node as? ArgoKitScrollViewNode{
                node.adjustsHeightToFitSubView = false
                if !node.setFlexGrow {
                    node.flexGrow(0)
                }
            }
            switch value(){
            case .auto:
                self.node?.flexBasisAuto()
                break
            case .point(let value):
                self.node?.flexBasis(point: value)
                break
            case .percent(let value):
                self.node?.flexBasis(percent: value)
                break
            default:
                break
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
