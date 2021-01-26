//
//  ArgoKitRefreshHeader.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
open class RefreshHeader: RefreshComponent {
    
    public class func headerWithRefreshingBlock(_ refreshingBlock: Block) -> RefreshHeader {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    var lastUpdatedTimeKey: String?
    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey ?? "") as? Date
    }
    
    public var ignoredScrollViewContentInsetTop: CGFloat = 0 {
        didSet {
            self.argokit_y = -self.argokit_height - ignoredScrollViewContentInsetTop
        }
    }
    
    var insetTDelta: CGFloat?
    
    override open var state: ArgoKitRefreshState {
        set(newState) {
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            if newState == .Idle {
                if oldState != .Refreshing {return}
                UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey ?? ArgoKitRefreshHead.lastUpdateTimeKey)
                UserDefaults.standard.synchronize()
                
                UIView.animate(withDuration: RefreshConst.slowAnimationDuration, animations: {
                    self.scrollView?.argokit_insetTop += self.insetTDelta ?? 0
                    if self.automaticallyChangeAlpha ?? false {
                        self.alpha = 0.0
                    }
                }) { (finished) in
                    self.pullingPercent = 0.0
                    self.endRefreshingCompletionBlock?(self)
                }
            } else if newState == .Refreshing {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self, let scrollViewOriginalInset = self.scrollViewOriginalInset, let scrollView = self.scrollView else {return}
                    UIView.animate(withDuration: RefreshConst.fastAnimationDuration, animations: {
                        let top = scrollViewOriginalInset.top + self.argokit_height
                        scrollView.argokit_insetTop = top
                        var offset = scrollView.contentOffset
                        offset.y = -top
                        scrollView.setContentOffset(offset, animated: false)
                    }, completion: { (finished) in
                        self.executeRefreshingCallback()
                    })
                }
            }
        }
        get {
            return super.state
        }
    }
}

extension RefreshHeader {
    override open func prepare() {
        super.prepare()
        lastUpdatedTimeKey = ArgoKitRefreshHead.lastUpdateTimeKey
        argokit_height = RefreshConst.headerHeight
    }
    override open func placeSubviews() {
        super.placeSubviews()
        argokit_y = -argokit_height - ignoredScrollViewContentInsetTop
    }
    
    override open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
       
        guard let scrollView = scrollView, var scrollViewOriginalInset = scrollViewOriginalInset else {return}
        if state == .Refreshing {
            if window == nil {return}
            var insetT = -scrollView.argokit_offsetY > scrollViewOriginalInset.top ? -scrollView.argokit_offsetY : scrollViewOriginalInset.top
            insetT = insetT > (argokit_height + scrollViewOriginalInset.top) ? argokit_height + scrollViewOriginalInset.top : insetT
            scrollView.argokit_insetTop = insetT
            insetTDelta = scrollViewOriginalInset.top - insetT
            return
        }
        scrollViewOriginalInset = scrollView.argokit_inset
        
        let offsetY = scrollView.argokit_offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        if offsetY >= happenOffsetY {
            return
        }
        if let pullingDownBlock = pullingDownBlock {
            pullingDownBlock(scrollView.argokit_offset)
        }
        let normal2pullingOffsetY = happenOffsetY - argokit_height
        let pullingPercent = (happenOffsetY - offsetY) / argokit_height
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .Idle && offsetY < normal2pullingOffsetY {
                self.state = .Pulling
            } else if self.state == .Pulling && offsetY >= normal2pullingOffsetY {
                self.state = .Idle
            }
        } else if self.state == .Pulling {
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
