//
//  ArgoKitRefreshFooterView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
class RefreshFooterNode:ArgoKitNode{
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        refreshingBlock = nil
    }
    var refreshingBlock: ((RefreshFooter?) -> ())?
    var offPage:CGFloat?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshFooterView:RefreshFooter = ArgoKitRefreshAutoFooter()
        refreshFooterView.setrefreshingBlock { [weak self] view in
            if let startRefresh = self?.refreshingBlock, let view = view as? RefreshFooter{
                startRefresh(view)
            }
        }
        let width = frame.size.width
        let height = frame.size.height
        if height > 0 {
            refreshFooterView.height(height)
        }
        if width >  0{
            refreshFooterView.width(width)
        }
        refreshFooterView.triggerAutomaticallyRefreshOffPages = offPage ?? 0
        return refreshFooterView
    }
    func refreshFooter() -> RefreshFooter?{
        if let refreshFooter = self.view as? RefreshFooter{
           return refreshFooter
        }
        return nil
    }
    
    func endRefreshing() {
        self.refreshFooter()?.endRefreshing()
    }
    
    func resetNoMoreData(){
        self.refreshFooter()?.resetNoMoreData()
    }
    
    func autoRefreshOffPage(_ value:CGFloat){
        offPage = value
    }
    
}

public struct RefreshFooterView: View {
    private var pNode:RefreshFooterNode?
    public var node: ArgoKitNode?{
        pNode
    }
    public init(startRefreshing:((RefreshFooter?) -> ())?,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = RefreshFooterNode(viewClass: ArgoKitRefreshAutoFooter.self, type: Self.self)
        pNode?.refreshingBlock = startRefreshing
        addSubViews(builder:builder)
    }
    
    @discardableResult
    public func endRefreshing() -> Self {
        pNode?.endRefreshing()
        return self
    }
    
    @discardableResult
    public func resetNoMoreData() -> Self {
        pNode?.resetNoMoreData()
        return self
    }
    
    @discardableResult
    public func autoRefreshOffPage(_ value:CGFloat) -> Self {
        pNode?.autoRefreshOffPage(value)
        return self
    }
    
}
