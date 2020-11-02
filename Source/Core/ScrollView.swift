//
//  ScrollView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

public protocol ScrollView: View {
    
    var scrollView: UIScrollView {get}
}

public extension ScrollView {
    
    var type: ArgoKitNodeType {
        let view = UIScrollView()
        let node = ArgoKitNode(view:view)
        view.delegate = node
        return .single(node)
    }
    
    var node: ArgoKitNode? {
        type.viewNode()
    }
    
    var body: View {
        self
    }
    
    var scrollView: UIScrollView {
        type.viewNode()?.view as! UIScrollView
    }
}

extension ScrollView {
    
    public func contentOffset(_ value: CGPoint) -> Self {
        scrollView.contentOffset = value
        return self
    }

    public func contentSize(_ value: CGSize) -> Self {
        scrollView.contentSize = value
        return self
    }

    public func contentInset(_ value: UIEdgeInsets) -> Self {
        scrollView.contentInset = value
        return self
    }

    
    @available(iOS 11.0, *)
    public func adjustedContentInsetDidChange() -> Self {
        scrollView.adjustedContentInsetDidChange()
        return self
    }

    @available(iOS 11.0, *)
    public func contentInsetAdjustmentBehavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        scrollView.contentInsetAdjustmentBehavior = value
        return self
    }

    @available(iOS 13.0, *)
    public func automaticallyAdjustsScrollIndicatorInsets(_ value: Bool) -> Self {
        scrollView.automaticallyAdjustsScrollIndicatorInsets = value
        return self
    }

    public func isDirectionalLockEnabled(_ value: Bool) -> Self {
        scrollView.isDirectionalLockEnabled = value
        return self
    }

    public func bounces(_ value: Bool) -> Self {
        scrollView.bounces = value
        return self
    }

    public func alwaysBounceVertical(_ value: Bool) -> Self {
        scrollView.alwaysBounceVertical = value
        return self
    }

    public func alwaysBounceHorizontal(_ value: Bool) -> Self {
        scrollView.alwaysBounceHorizontal = value
        return self
    }

    public func isPagingEnabled(_ value: Bool) -> Self {
        scrollView.isPagingEnabled = value
        return self
    }

    public func isScrollEnabled(_ value: Bool) -> Self {
        scrollView.isScrollEnabled = value
        return self
    }

    public func showsVerticalScrollIndicator(_ value: Bool) -> Self {
        scrollView.showsVerticalScrollIndicator = value
        return self
    }

    public func showsHorizontalScrollIndicator(_ value: Bool) -> Self {
        scrollView.showsHorizontalScrollIndicator = value
        return self
    }

    public func indicatorStyle(_ value: UIScrollView.IndicatorStyle) -> Self {
        scrollView.indicatorStyle = value
        return self
    }
    
    @available(iOS 11.1, *)
    public func verticalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        scrollView.verticalScrollIndicatorInsets = value
        return self
    }

    @available(iOS 11.1, *)
    public func horizontalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        scrollView.horizontalScrollIndicatorInsets = value
        return self
    }

    public func scrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        scrollView.scrollIndicatorInsets = value
        return self
    }

    public func decelerationRate(_ value: UIScrollView.DecelerationRate) -> Self {
        scrollView.decelerationRate = value
        return self
    }

    public func indexDisplayMode(_ value: UIScrollView.IndexDisplayMode) -> Self {
        scrollView.indexDisplayMode = value
        return self
    }

    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        scrollView.setContentOffset(contentOffset, animated: animated)
        return self
    }

    public func scrollRectToVisible(_ rect: CGRect, animated: Bool) -> Self {
        scrollView.scrollRectToVisible(rect, animated: animated)
        return self
    }

    public func flashScrollIndicators() -> Self {
        scrollView.flashScrollIndicators()
        return self
    }
        
    public func delaysContentTouches(_ value: Bool) -> Self {
        scrollView.delaysContentTouches = value
        return self
    }

    public func canCancelContentTouches(_ value: Bool) -> Self {
        scrollView.canCancelContentTouches = value
        return self
    }

    public func minimumZoomScale(_ value: CGFloat) -> Self {
        scrollView.minimumZoomScale = value
        return self
    }

    public func maximumZoomScale(_ value: CGFloat) -> Self {
        scrollView.maximumZoomScale = value
        return self
    }

    public func zoomScale(_ value: CGFloat) -> Self {
        scrollView.zoomScale = value
        return self
    }

    public func setZoomScale(_ scale: CGFloat, animated: Bool) -> Self {
        scrollView.setZoomScale(scale, animated: animated)
        return self
    }

    public func zoom(to rect: CGRect, animated: Bool) -> Self {
        scrollView.zoom(to: rect, animated: animated)
        return self
    }

    public func bouncesZoom(_ value: Bool) -> Self {
        scrollView.bouncesZoom = value
        return self
    }

    public func scrollsToTop(_ value: Bool) -> Self {
        scrollView.scrollsToTop = value
        return self
    }

    public func keyboardDismissMode(_ value: UIScrollView.KeyboardDismissMode) -> Self {
        scrollView.keyboardDismissMode = value
        return self
    }

    @available(iOS 10.0, *)
    public func refreshControl(_ value: UIRefreshControl) -> Self {
        scrollView.refreshControl = value
        return self
    }
}

extension ScrollView {
    
    public func scrollViewDidScroll(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidScroll(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    public func scrollViewDidZoom(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidZoom(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    public func scrollViewWillBeginDragging(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewWillBeginDragging(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    public func scrollViewWillEndDraggingWithVelocityTargetContentOffset(_ action: @escaping (_ velocity: CGPoint, _ targetContentOffset:  UnsafeMutablePointer<CGPoint>) -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let velocity: CGPoint = paramter![0] as! CGPoint
                let targetContentOffset: UnsafeMutableRawPointer = (paramter![1] as! NSValue).pointerValue!
                action(velocity, targetContentOffset.assumingMemoryBound(to: CGPoint.self))
            }
            return nil
        })
        return self
    }
    
    public func scrollViewDidEndDraggingWillDecelerate(_ action: @escaping (_ decelerate: Bool) -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidEndDragging(_:willDecelerate:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1 {
                let decelerate: Bool = paramter![0] as! Bool
                action(decelerate)
            }
            return nil
        })
        return self
    }
    
    public func scrollViewWillBeginDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewWillBeginDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func scrollViewDidEndDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidEndDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func scrollViewDidEndScrollingAnimation(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func viewForZoomingInScrollView(_ action: @escaping () -> UIView?) -> Self {
        let sel = #selector(ArgoKitNode.viewForZooming(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    public func scrollViewWillBeginZoomingWithView(_ action: @escaping (_ view: UIView?) -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewWillBeginZooming(_:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1 {
                let view: UIView = paramter![0] as! UIView
                action(view)
            } else {
                action(nil)
            }
            return nil
        })
        return self
    }
    
    public func scrollViewDidEndZoomingWithViewAtScale(_ action: @escaping (_ view: UIView?, _ atScale: Float) -> Void?) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidEndZooming(_:with:atScale:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let scale: Float = paramter![0] as! Float
                let view: UIView = paramter![1] as! UIView
                action(view, scale)
            } else if paramter?.count ?? 0 >= 1 {
                let scale: Float = paramter![0] as! Float
                action(nil, scale)
            }
            return nil
        })
        return self
    }
    
    public func scrollViewShouldScrollToTop(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewShouldScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    public func scrollViewDidScrollToTop(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitNode.scrollViewDidChangeAdjustedContentInset(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
}
