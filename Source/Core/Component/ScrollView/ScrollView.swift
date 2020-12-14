//
//  ScrollView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

public class ScrollView: View {
    var pNode : ArgoKitScrollViewNode?
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    required public init() {
        createNode()
    }
    
    public convenience init(@ArgoKitViewBuilder builder:@escaping () -> View) {
        self.init()
        addSubNodes(builder: builder)
    }
    
    func createNode() {
        pNode = ArgoKitScrollViewNode(viewClass: UIScrollView.self)
    }
}

extension ScrollView {
    
    @discardableResult
    public func contentOffset(_ value: CGPoint) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentOffset),value)
        return self
    }

    @discardableResult
    public func contentSize(_ value: CGSize) -> Self {
        pNode?.contentSize(value)
        return self
    }
    
    @discardableResult
    public func contentWidth(_ value: CGFloat) -> Self {
        pNode?.contentWidth(value)
        return self
    }
    
    @discardableResult
    public func contentHeight(_ value: CGFloat) -> Self {
        pNode?.contentHeight(value)
        return self
    }

    @discardableResult
    public func contentInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInset),value)
        return self
    }

    
    @available(iOS 11.0, *)
    @discardableResult
    public func adjustedContentInsetDidChange() -> Self {
        addAttribute(#selector(UIScrollView.adjustedContentInsetDidChange))
        return self
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInsetAdjustmentBehavior),value.rawValue)
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func automaticallyAdjustsScrollIndicatorInsets(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.automaticallyAdjustsScrollIndicatorInsets),value)
        return self
    }

    @discardableResult
    public func isDirectionalLockEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isDirectionalLockEnabled),value)
        return self
    }

    @discardableResult
    public func bounces(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bounces),value)
        return self
    }

    @discardableResult
    public func alwaysBounceVertical(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceVertical),value)
        return self
    }

    @discardableResult
    public func alwaysBounceHorizontal(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceHorizontal),value)
        return self
    }

    @discardableResult
    public func isPagingEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isPagingEnabled),value)
        return self
    }

    @discardableResult
    public func isScrollEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isScrollEnabled),value)
        return self
    }

    @discardableResult
    public func showsVerticalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value)
        return self
    }

    @discardableResult
    public func showsHorizontalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value)
        return self
    }

    @discardableResult
    public func indicatorStyle(_ value: UIScrollView.IndicatorStyle) -> Self {
        addAttribute(#selector(setter:UIScrollView.indicatorStyle),value.rawValue)
        return self
    }
    
    @available(iOS 11.1, *)
    @discardableResult
    public func verticalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.verticalScrollIndicatorInsets),value)
        return self
    }

    @available(iOS 11.1, *)
    @discardableResult
    public func horizontalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.horizontalScrollIndicatorInsets),value)
        return self
    }

    @discardableResult
    public func scrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollIndicatorInsets),value)
        return self
    }

    @discardableResult
    public func decelerationRate(_ value: UIScrollView.DecelerationRate) -> Self {
        addAttribute(#selector(setter:UIScrollView.decelerationRate),value.rawValue)
        return self
    }

    @discardableResult
    public func indexDisplayMode(_ value: UIScrollView.IndexDisplayMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.indexDisplayMode),value.rawValue)
        return self
    }

    @discardableResult
    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setContentOffset(_:animated:)), contentOffset, animated)
        return self
    }

    @discardableResult
    public func scrollRectToVisible(_ rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.scrollRectToVisible(_:animated:)), rect, animated)
        return self
    }

    @discardableResult
    public func flashScrollIndicators() -> Self {
        addAttribute(#selector(UIScrollView.flashScrollIndicators))
        return self
    }
        
    @discardableResult
    public func delaysContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.delaysContentTouches),value)
        return self
    }

    @discardableResult
    public func canCancelContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.canCancelContentTouches),value)
        return self
    }
    
    @discardableResult
    public func minimumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.minimumZoomScale),value)
        return self
    }

    @discardableResult
    public func maximumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.maximumZoomScale),value)
        return self
    }

    @discardableResult
    public func zoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.zoomScale),value)
        return self
    }

    @discardableResult
    public func setZoomScale(_ scale: CGFloat, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setZoomScale(_:animated:)), scale, animated)
        return self
    }

    @discardableResult
    public func zoom(to rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.zoom(to:animated:)), rect, animated)
        return self
    }

    @discardableResult
    public func bouncesZoom(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bouncesZoom),value)
        return self
    }

    @discardableResult
    public func scrollsToTop(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollsToTop),value)
        return self
    }

    @discardableResult
    public func keyboardDismissMode(_ value: UIScrollView.KeyboardDismissMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.keyboardDismissMode),value.rawValue)
        return self
    }

    @available(iOS 10.0, *)
    @discardableResult
    public func refreshControl(_ value: UIRefreshControl) -> Self {
        addAttribute(#selector(setter:UIScrollView.refreshControl),value)
        return self
    }
}

extension ScrollView {
    
    @discardableResult
    public func didScroll(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScroll(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    @discardableResult
    public func didZoom(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidZoom(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    @discardableResult
    public func willBeginDragging(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDragging(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
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
    
    @discardableResult
    public func willBeginDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    @discardableResult
    public func didEndDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    @discardableResult
    public func didEndScrollingAnimation(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    @discardableResult
    public func viewForZooming(_ action: @escaping () -> UIView?) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.viewForZooming(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
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
    
    @discardableResult
    public func shouldScrollToTop(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewShouldScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    @discardableResult
    public func didScrollToTop(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
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
