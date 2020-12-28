//
//  ArgoKitRefreshFooter.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
open class RefreshFooter: RefreshComponent {
    ///忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
    
    ///是否自动刷新(默认为YES)
    public var automaticallyRefresh: Bool = true
    
    public var _triggerAutomaticallyRefreshOffPages: CGFloat = 0
    
    public var triggerAutomaticallyRefreshOffPages: CGFloat {
        get{
            _triggerAutomaticallyRefreshOffPages
        }
        set(newVlaue){
            _triggerAutomaticallyRefreshOffPages = newVlaue
        }
    }
    
    //MARK: - 创建footer方法
    public class func footerWithRefreshingBlock(_ refreshingBlock: Block) -> RefreshFooter {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
}

extension RefreshFooter {
    override open func prepare() {
        super.prepare()
        // 设置自己的高度
        argokit_height = RefreshConst.footerHeight
    }
}
//MARK: - 公共方法
extension RefreshFooter {
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .NoMoreData
        }
    }
    public func resetNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .Idle
        }
    }
}


open class ArgoKitRefreshAutoFooter: RefreshFooter {
    
    ///当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    ///是否每一次拖拽只发一次请求
    public var onlyRefreshPerDrag: Bool = false
    /// 一个新的拖拽
    var oneNewPan: Bool = false
    
    override open var state: ArgoKitRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            // 根据状态做事情
            if newState == .Refreshing {
                executeRefreshingCallback()
            } else if newState == .NoMoreData || state == .Idle {
                if oldState == .Refreshing {
                    endRefreshingCompletionBlock?()
                }
            }
        }
        get {
            return super.state
        }
    }
    override open var isHidden: Bool {
        set(newHidden) {
            let lastHidden = isHidden
            super.isHidden = newHidden
            
            if !lastHidden && newHidden {
                state = .Idle
                scrollView?.argokit_insetBottom -= argokit_height
            } else if lastHidden && !newHidden {
                scrollView?.argokit_insetBottom += argokit_height
                argokit_y = scrollView?.argokit_contentH ?? 0
            }
        }
        get {
            return super.isHidden
        }
    }
}

extension ArgoKitRefreshAutoFooter {
    override open func prepare() {
        super.prepare()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if isHidden == false {
                scrollView?.argokit_insetBottom += argokit_height
            }
            // 设置位置
            argokit_y = scrollView?.argokit_contentH ?? 0
        } else {// 被移除了
            if isHidden == false {
                scrollView?.argokit_insetBottom -= argokit_height
            }
        }
    }
    
    override open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        
        // 设置位置
        argokit_y = scrollView?.argokit_contentH ?? 0
    }
    override open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
       super.scrollViewContentOffsetDidChange(change)
        if state != .Idle || !automaticallyRefresh || argokit_y == 0 {
            return
        }
        guard let scrollView = scrollView else { return }
        if scrollView.argokit_insetTop + scrollView.argokit_contentH > scrollView.argokit_height {// 内容超过一个屏幕
            if scrollView.argokit_offsetY >= scrollView.argokit_contentH - scrollView.argokit_height + argokit_height * triggerAutomaticallyRefreshPercent + scrollView.argokit_insetBottom - argokit_height {
                guard let change = change else {return}
                // 防止手松开时连续调用
                let old = change[NSKeyValueChangeKey.oldKey] as? CGPoint
                let new = change[.newKey] as? CGPoint
                if new?.y ?? 0 <= old?.y ?? 0 {return}
                
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
    }
    override open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)

        guard let scrollView = scrollView, state == .Idle else {return}
        let panState = scrollView.panGestureRecognizer.state
        switch panState {
        case .ended:// 手松开
            if scrollView.argokit_insetTop + scrollView.argokit_contentH <= scrollView.argokit_height {// 不够一个屏幕
                if scrollView.argokit_offsetY >= scrollView.argokit_insetTop {// 向上拽
                    beginRefreshing()
                }
            } else {
                if scrollView.argokit_offsetY >= scrollView.argokit_contentH + scrollView.argokit_insetBottom - scrollView.argokit_height * (_triggerAutomaticallyRefreshOffPages + 1) {
                    beginRefreshing()
                }
            }
        case .began:
            oneNewPan = true
        default:
            break
        }
    }
    override open func beginRefreshing() {
        if !oneNewPan && onlyRefreshPerDrag {
            return
        }
        super.beginRefreshing()
        oneNewPan = false
    }
}
