//
//  ArgoKitScrollViewNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

class ArgoKitScrollViewNode: ArgoKitNode, UIScrollViewDelegate {
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let scrollView = UIScrollView(frame: frame)
        scrollView.delegate = self
        return scrollView
    }
    
}

extension ArgoKitScrollViewNode {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidScroll(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidZoom(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewWillBeginDragging(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let sel = #selector(self.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView, velocity, targetContentOffset])
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let sel = #selector(self.scrollViewDidEndDragging(_:willDecelerate:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView, decelerate])
    }

    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewWillBeginDecelerating(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidEndDecelerating(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidEndScrollingAnimation(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let sel = #selector(self.viewForZooming(in:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [scrollView]) as? UIView
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        let sel = #selector(self.scrollViewWillBeginZooming(_:with:))
        if view != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [scrollView, view!])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
        }
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let sel = #selector(self.scrollViewDidEndZooming(_:with:atScale:))
        if view != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [scrollView, view!, scale])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [scrollView, scale])
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        let sel = #selector(self.scrollViewShouldScrollToTop(_:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [scrollView]) as? Bool ?? scrollView.scrollsToTop
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidScrollToTop(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }

    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        let sel = #selector(self.scrollViewDidChangeAdjustedContentInset(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [scrollView])
    }
}
