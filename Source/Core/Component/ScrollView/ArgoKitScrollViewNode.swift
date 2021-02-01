//
//  ArgoKitScrollViewNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

class ArgoKitScrollContentNode: ArgoKitArttibuteNode {
    
    var innerFrame = CGRect.zero

    override func createNodeViewIfNeed(_ frame: CGRect) {
        // 覆盖父类，不要任何实现
    }

    override var frame: CGRect {

        set {
            innerFrame = newValue
            size = frame.size
            sendFrameChanged(frame: newValue)
        }

        get {
            return innerFrame
        }
    }
}

class ArgoKitScrollViewNode: ArgoKitArttibuteNode, UIScrollViewDelegate {
    var defaultViewHeight:CGFloat = 0
    var defaultFlexGrow:CGFloat = 0
    var adjustsHeightToFitSubView:Bool = false
    var setFlexGrow:Bool = false
    var autoHeight:CGFloat = 0 {
        didSet{
            if autoHeight < defaultViewHeight {
                self.height(point:autoHeight)
                self.flexGrow(0)
                self.markDirty()
            }else{
                self.height(point:defaultViewHeight)
                self.flexGrow(defaultFlexGrow)
                self.markDirty()
            }
            _ = self.applyLayout(size: self.size)
        }
    }

    func setContentSizeViewHeight(_ height:CGFloat){
        if adjustsHeightToFitSubView && autoHeight < defaultViewHeight{
            autoHeight = height
        }
    }
    
    lazy var nodeObserver = ArgoKitNodeObserver()
    lazy var frameObserver = ArgoKitNodeObserver()
    
    var contentNode: ArgoKitScrollContentNode?
    private var contentSize = CGSize(width: CGFloat.nan, height: CGFloat.nan)

    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let scrollView = UIScrollView(frame: frame)
        scrollView.delegate = self
        return scrollView
    }

    func createContentNode() {
        let node = ArgoKitScrollContentNode(viewClass: UIScrollView.self)
        frameObserver.setFrameChange { [weak self] frame in
            if let strongSelf = self {
                ArgoKitNodeViewModifier._addAttribute_(isCALayer: false, strongSelf, #selector(setter:UIScrollView.contentSize), [frame.size])
                if let scrollView = strongSelf.view as? UIScrollView {
                    scrollView.contentSize = frame.size
                }
            }
        }
        node.addNode(observer: frameObserver)
        contentNode = node
        
        nodeObserver.setCreateViewBlock { [weak self] view in
            if let strongSelf = self {
                strongSelf.contentNode?.bindView(view)
                strongSelf.contentNode?.applyLayout(size: strongSelf.contentSize)
            }
        }
        self.addNode(observer: nodeObserver)
    }
}
    
extension ArgoKitScrollViewNode {
    
    public func contentSize(_ value: CGSize) {
        contentSize = value
        contentNode?.width(point: value.width)
        contentNode?.height(point: value.height)
    }
    
    public func contentWidth(_ value: CGFloat) {
        contentSize.width = value
        contentNode?.width(point: value)
    }
    
    public func contentHeight(_ value: CGFloat) {
        contentSize.height = value
        contentNode?.height(point: value)
    }
}

extension ArgoKitScrollViewNode {
    
    override func addChildNode(_ node: ArgoKitNode?) {
        if let _contentNode = self.contentNode {
            _contentNode.addChildNode(node)
        }else{
            super.addChildNode(node)
        }
    }

    override func insertChildNode(_ node: ArgoKitNode, at index: Int) {
        if let _contentNode = self.contentNode {
            _contentNode.insertChildNode(node, at: index)
        }else{
            super.insertChildNode(node, at: index)
        }
    }

    override func applyLayout() -> CGSize {
        if let _contentNode = self.contentNode {
            _contentNode.applyLayout(size: contentSize)
            return super.applyLayout()
        }else{
            return super.applyLayout()
        }
    }

    override func applyLayout(size: CGSize) -> CGSize {
        if let _contentNode = self.contentNode {
            _contentNode.applyLayout(size: contentSize)
            return super.applyLayout(size: size)
        }else{
            return super.applyLayout(size: size)
        }
    }

    override func calculateLayout(size: CGSize) -> CGSize {
        if let _contentNode = self.contentNode {
            _contentNode.calculateLayout(size: contentSize)
            return super.calculateLayout(size: size)
        }else{
            return super.calculateLayout(size: size)
        }
    }

    override func applyLayoutAferCalculation(withView: Bool) {
        if let _contentNode = self.contentNode {
            _contentNode.applyLayoutAferCalculation(withView: withView)
            super.applyLayoutAferCalculation(withView: withView)
        }else{
            super.applyLayoutAferCalculation(withView: withView)
        }
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
