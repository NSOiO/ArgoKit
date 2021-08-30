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
    /// - Parameter builder: view builder used for ScrollView ArgoKitListBuilder
    public convenience init(@ArgoKitListBuilder content:@escaping () -> View) {
        self.init()
        addSubViews(builder: content)
    }
    
    func createNode() {
        let node = ArgoKitScrollViewNode(viewClass: UIScrollView.self, type: Self.self)
        node.createContentNode()
        pNode = node
    }
}

extension ScrollView {
    /// Called when the adjusted content insets of the scroll view change.
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func adjustedContentInsetDidChange() -> Self {
        addAttribute(#selector(UIScrollView.adjustedContentInsetDidChange))
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
    
    /// Set the callback called when the user scrolls the content view within the receiver.
    /// - Parameter action: the callback with UIScrollView
    /// - Returns: self
    public func didScroll(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScroll(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
            return action(nil)
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
    
    /// Set the callback called when the scroll view’s zoom factor changed.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func didZoom(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidZoom(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
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
    
    /// Set the callback called when  the scroll view is about to start scrolling the content.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func willBeginDragging(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDragging(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
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
            if paramter?.count ?? 0 >= 3,
               let velocity = paramter![1] as? CGPoint,
               let targetContentOffset = paramter![2] as? UnsafeMutablePointer<CGPoint>{
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
            if paramter?.count ?? 0 >= 2,
               let decelerate = paramter![1] as? Bool{
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
    
    /// Set the callback called when  the scroll view is starting to decelerate the scrolling movement.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func willBeginDecelerating(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewWillBeginDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
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
    
    /// Set the calback called when  the scroll view has ended decelerating the scrolling movement.
    /// - Parameter action: callback  with UIScrollView
    /// - Returns: self
    @discardableResult
    public func didEndDecelerating(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndDecelerating(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
            return nil
        })
        return self
    }
    
    /// Set the callback called when a scrolling animation in the scroll view concludes.
    /// - Parameter action: callback
    /// - Returns: self
    @discardableResult
    @objc 
    public func didEndScrollingAnimation(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            action()
            return nil
        })
        return self
    }
    
    /// Set the callback called when a scrolling animation in the scroll view concludes.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func didEndScrollingAnimation(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidEndScrollingAnimation(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
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
    
    /// Set the callback called for the view to scale when zooming is about to occur in the scroll view.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func viewForZooming(_ action: @escaping (UIScrollView?) -> UIView?) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.viewForZooming(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                return action(view)
            }else{
                return action(nil);
            }
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
            if paramter?.count ?? 0 >= 2,
               let view = paramter![1] as? UIView{
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
            if paramter?.count ?? 0 >= 3,
               let view = paramter![1] as? UIView,
               let scale = paramter![2] as? Float{
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
    
    /// Set the calback that returns the Boolean value.
    ///  to determine if the scroll view should scroll to the top of the content.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func shouldScrollToTop(_ action: @escaping (UIScrollView?) -> Bool) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewShouldScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                return action(view)
            }else{
                return action(nil);
            }
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
    
    /// Set the callback called when the scroll view scrolled to the top of the content.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @discardableResult
    public func didScrollToTop(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidScrollToTop(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
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
    
    /// Set the callback called when the scroll view's inset values changed.
    /// - Parameter action: callback with UIScrollView
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    public func didChangeAdjustedContentInset(_ action: @escaping (UIScrollView?) -> Void) -> Self {
        let sel = #selector(ArgoKitScrollViewNode.scrollViewDidChangeAdjustedContentInset(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let view = paramter?.first as? UIScrollView{
                action(view)
            }else{
                action(nil);
            }
            return nil
        })
        return self
    }
}

extension ScrollView{
    
    /// Returns whether the user has touched the content to initiate scrolling.
    /// - Returns: YES if user has touched. may not yet have started dragging
    public func isTracking() ->Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isTracking
        }
        return false
    }

    /// A Boolean value that indicates whether the user has begun scrolling the content.
    /// - Returns: YES if user has started scrolling. this may require some time and or distance to move to initiate dragging
    public func isDragging() ->Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isDragging
        }
        return false
    }
    
    /// Returns whether the content is moving in the scroll view after the user lifted their finger.
    /// - Returns: YES if user isn't dragging (touch up) but scroll view is still moving
    public func isDecelerating() ->Bool {
        if let view =  self.node?.nodeView() as? UIScrollView {
            return view.isDecelerating
        }
        return false
    }


}
