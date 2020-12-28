//
//  ArgoKitRefreshHeaderView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation

class RefreshHeaderNode:ArgoKitNode{

    var refreshingBlock: (() -> ())?
    
    var pullingDownBlock: ((_ contentOffset:CGPoint?) -> ())?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshHeaderView:ArgoKitRefreshHeader = ArgoKitRefreshHeader.headerWithRefreshingBlock { [weak self] in
            if let startRefresh = self?.refreshingBlock{
                startRefresh()
            }
        }
        let width = self.width()
        let height = self.height()
        if height > 0 {
            refreshHeaderView.height(height)
        }
        if width >  0{
            refreshHeaderView.width(width)
        }
        // 添加下拉偏移监听
        refreshHeaderView.startPullingDownBlock(pullingDownBlock)
        
        return refreshHeaderView
    }
    func refreshHeader() -> ArgoKitRefreshHeader?{
        if let refreshHeader = self.view as? ArgoKitRefreshHeader  {
           return refreshHeader
        }
        return nil
    }
    func endRefreshing() {
        self.refreshHeader()?.endRefreshing()
    }
    public func pullingDown(_ value:((_ contentOffset:CGPoint?) -> ())?){
        self.pullingDownBlock = value
    }
}

public class RefreshHeaderView: View {
    private var pNode:RefreshHeaderNode?
    public var node: ArgoKitNode?{
        pNode
    }
    public init(startRefreshing:(() -> ())?,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = RefreshHeaderNode(viewClass: ArgoKitRefreshHeader.self)
        pNode?.refreshingBlock = startRefreshing
        addSubViews(builder:builder)
    }
    
    @discardableResult
    public func pullingDown(_ value:((_ contentOffset:CGPoint?) -> ())?) -> Self{
        pNode?.pullingDown(value)
        return self
    }
    
    @discardableResult
    public func endRefreshing() ->Self {
        pNode?.endRefreshing()
        return self
    }
    
}
