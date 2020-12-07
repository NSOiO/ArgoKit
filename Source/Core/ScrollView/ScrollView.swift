//
//  ScrollView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

public class ScrollView: View {
    var pNode : ArgoKitScrollViewNode?
    
    public var type: ArgoKitNodeType {
        .single(pNode!)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init() {
        createNode()
    }
    
    func createNode() {
        pNode = ArgoKitScrollViewNode(viewClass: UIScrollView.self)
    }
}

extension ScrollView {
    
    public func contentOffset(_ value: CGPoint) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentOffset),value)
        return self
    }

    public func contentSize(_ value: CGSize) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentSize),value)
        return self
    }

    public func contentInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInset),value)
        return self
    }

    
    @available(iOS 11.0, *)
    public func adjustedContentInsetDidChange() -> Self {
        addAttribute(#selector(UIScrollView.adjustedContentInsetDidChange))
        return self
    }

    @available(iOS 11.0, *)
    public func contentInsetAdjustmentBehavior(_ value: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        addAttribute(#selector(setter:UIScrollView.contentInsetAdjustmentBehavior),value.rawValue)
        return self
    }

    @available(iOS 13.0, *)
    public func automaticallyAdjustsScrollIndicatorInsets(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.automaticallyAdjustsScrollIndicatorInsets),value)
        return self
    }

    public func isDirectionalLockEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isDirectionalLockEnabled),value)
        return self
    }

    public func bounces(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bounces),value)
        return self
    }

    public func alwaysBounceVertical(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceVertical),value)
        return self
    }

    public func alwaysBounceHorizontal(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.alwaysBounceHorizontal),value)
        return self
    }

    public func isPagingEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isPagingEnabled),value)
        return self
    }

    public func isScrollEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.isScrollEnabled),value)
        return self
    }

    public func showsVerticalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsVerticalScrollIndicator),value)
        return self
    }

    public func showsHorizontalScrollIndicator(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.showsHorizontalScrollIndicator),value)
        return self
    }

    public func indicatorStyle(_ value: UIScrollView.IndicatorStyle) -> Self {
        addAttribute(#selector(setter:UIScrollView.indicatorStyle),value.rawValue)
        return self
    }
    
    @available(iOS 11.1, *)
    public func verticalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.verticalScrollIndicatorInsets),value)
        return self
    }

    @available(iOS 11.1, *)
    public func horizontalScrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.horizontalScrollIndicatorInsets),value)
        return self
    }

    public func scrollIndicatorInsets(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollIndicatorInsets),value)
        return self
    }

    public func decelerationRate(_ value: UIScrollView.DecelerationRate) -> Self {
        addAttribute(#selector(setter:UIScrollView.decelerationRate),value.rawValue)
        return self
    }

    public func indexDisplayMode(_ value: UIScrollView.IndexDisplayMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.indexDisplayMode),value.rawValue)
        return self
    }

    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setContentOffset(_:animated:)), contentOffset, animated)
        return self
    }

    public func scrollRectToVisible(_ rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.scrollRectToVisible(_:animated:)), rect, animated)
        return self
    }

    public func flashScrollIndicators() -> Self {
        addAttribute(#selector(UIScrollView.flashScrollIndicators))
        return self
    }
        
    public func delaysContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.delaysContentTouches),value)
        return self
    }

    public func canCancelContentTouches(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.canCancelContentTouches),value)
        return self
    }

    public func minimumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.minimumZoomScale),value)
        return self
    }

    public func maximumZoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.maximumZoomScale),value)
        return self
    }

    public func zoomScale(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIScrollView.zoomScale),value)
        return self
    }

    public func setZoomScale(_ scale: CGFloat, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.setZoomScale(_:animated:)), scale, animated)
        return self
    }

    public func zoom(to rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(UIScrollView.zoom(to:animated:)), rect, animated)
        return self
    }

    public func bouncesZoom(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.bouncesZoom),value)
        return self
    }

    public func scrollsToTop(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIScrollView.scrollsToTop),value)
        return self
    }

    public func keyboardDismissMode(_ value: UIScrollView.KeyboardDismissMode) -> Self {
        addAttribute(#selector(setter:UIScrollView.keyboardDismissMode),value.rawValue)
        return self
    }

    @available(iOS 10.0, *)
    public func refreshControl(_ value: UIRefreshControl) -> Self {
        addAttribute(#selector(setter:UIScrollView.refreshControl),value)
        return self
    }
}

extension ScrollView {
    
    public func didScroll(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScroll(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    public func didZoom(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidZoom(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
    public func willBeginDragging(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDragging(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action();
            return nil
        })
        return self
    }
    
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
    
    public func willBeginDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func didEndDecelerating(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func didEndScrollingAnimation(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    public func viewForZooming(_ action: @escaping () -> UIView?) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.viewForZooming(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
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
    
    public func shouldScrollToTop(_ action: @escaping () -> Bool) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewShouldScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    public func didScrollToTop(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    @available(iOS 11.0, *)
    public func didChangeAdjustedContentInset(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidChangeAdjustedContentInset(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
}
