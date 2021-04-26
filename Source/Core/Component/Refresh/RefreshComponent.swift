//
//  ArgoKitRefreshComponent.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import UIKit

public enum ArgoKitRefreshState: Int {
    case Idle = 1
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
}

open class RefreshComponent: UIView {
    public typealias Block = ((RefreshComponent?) -> ())?
   
    var pullingDownBlock: ((_ contentOffset:CGPoint?) -> ())?
    
    var refreshingBlock: ((RefreshComponent?) -> ())?
    var refreshingTarget: Any?
    var refreshingAction: Selector?
    
    var beginRefreshingCompletionBlock: ((RefreshComponent?) -> ())?
    
    var endRefreshingCompletionBlock: ((RefreshComponent?) -> ())?
    
    public var refreshing: Bool {
        return self.state == .Refreshing || self.state == .WillRefresh
    }

    open var state: ArgoKitRefreshState {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    
    public func setrefreshingBlock(_ value:Block){
        self.refreshingBlock = value
    }

    var scrollViewOriginalInset: UIEdgeInsets?

    private(set) weak var scrollView: UIScrollView?
    
    open var pullingPercent: CGFloat? {
        didSet {
            if self.refreshing {
                return
            }
            if self.automaticallyChangeAlpha ?? false {
                self.alpha = pullingPercent ?? 0
            }
        }
    }

    public var automaticallyChangeAlpha: Bool? {
        willSet(_automaticallyChangeAlpha) {
            self.automaticallyChangeAlpha = _automaticallyChangeAlpha
            if self.refreshing {
                return
            }
            if _automaticallyChangeAlpha ?? false {
                self.alpha = self.pullingPercent ?? 0
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    var pan: UIPanGestureRecognizer?
    
    override public init(frame: CGRect) {
        state = .Idle
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let newSuperview = newSuperview,
        newSuperview.isKind(of: UIScrollView.self)
        else { return }
        removeObservers()
        
        argokit_width = newSuperview.argokit_width
        argokit_x = -(scrollView?.argokit_insetLeft ?? 0)
        scrollView = newSuperview as? UIScrollView
        scrollView?.alwaysBounceVertical = true
        scrollViewOriginalInset = scrollView?.argokit_inset
        
        addObservers()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .WillRefresh {
            state = .Refreshing
        }
    }
}

extension RefreshComponent {
    @objc public func beginRefreshing() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        if window != nil {
            state = .Refreshing
        } else {
            if state != .Refreshing {
                state = .WillRefresh
                setNeedsDisplay()
            }
        }
    }
    
    public func startPullingDownBlock(_ pullDownBlock:((_ contentOffset:CGPoint?) -> ())?){
        pullingDownBlock = pullDownBlock
    }
    
    public func beginRefreshingWithCompletionBlock(_ completionBlock: Block) {
        beginRefreshingCompletionBlock = completionBlock
        beginRefreshing()
    }
    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .Idle
        }
    }
    public func endRefreshingWithCompletionBlock(_ completionBlock: Block) {
        endRefreshingCompletionBlock = completionBlock
        endRefreshing()
    }
}
//MARK: - 交给子类们去实现
extension RefreshComponent {
    @objc open func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }
    
    open func height(_ value:CGFloat){
        self.argokit_height = value
    }
    
    open func width(_ value:CGFloat){
        self.argokit_width = value
    }
    @objc open func placeSubviews() {
        
    }
    @objc open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    @objc open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    @objc open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
extension RefreshComponent {
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: RefreshKeyPath.contentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshKeyPath.contentSize, options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: RefreshKeyPath.panState, options: options, context: nil)
    }
    func removeObservers() {
        superview?.removeObserver(self, forKeyPath: RefreshKeyPath.contentOffset)
        superview?.removeObserver(self, forKeyPath: RefreshKeyPath.contentSize)
        pan?.removeObserver(self, forKeyPath: RefreshKeyPath.panState)
        pan = nil
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !isUserInteractionEnabled {
            return
        }
        
        if keyPath == RefreshKeyPath.contentSize {
            scrollViewContentSizeDidChange(change)
        }
        if isHidden {
            return
        }
        if keyPath == RefreshKeyPath.contentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == RefreshKeyPath.panState {
            scrollViewPanStateDidChange(change)
        }
    }
}

extension RefreshComponent {
    func setRefreshing(_ target: Any?, _ action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }
    func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshingBlock?(self)
            self?.beginRefreshingCompletionBlock?(self)
        }
    }
}
