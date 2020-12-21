//
//  ArgoKitRefreshFooterView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
class RefreshFooterNode:ArgoKitNode{

    var refreshingBlock: (() -> ())?
    var offPage:CGFloat?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshFooterView:ArgoKitRefreshFooter = ArgoKitRefreshAutoFooter.footerWithRefreshingBlock {  [weak self] in
            if let startRefresh = self?.refreshingBlock{
                startRefresh()
            }
        }
        let width = self.width()
        let height = self.height()
        if height > 0 {
            refreshFooterView.height(height)
        }
        if width >  0{
            refreshFooterView.width(height)
        }
        refreshFooterView.triggerAutomaticallyRefreshOffPages = offPage ?? 0
        return refreshFooterView
    }
    func refreshFooter() -> ArgoKitRefreshFooter?{
        if let refreshFooter = self.view as? ArgoKitRefreshFooter{
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

public class RefreshFooterView: View {
    private var pNode:RefreshFooterNode?
    public var node: ArgoKitNode?{
        pNode
    }
    public init(startRefreshing:(() -> ())?,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = RefreshFooterNode(viewClass: ArgoKitRefreshAutoFooter.self)
        pNode?.refreshingBlock = startRefreshing
        pNode?.column()
        addSubNodes(builder:builder)
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
