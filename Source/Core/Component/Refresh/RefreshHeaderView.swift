//
//  ArgoKitRefreshHeaderView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation

class RefreshHeaderNode:ArgoKitNode{
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        refreshingBlock = nil
        pullingDownBlock = nil
    }
    var refreshingBlock: ((RefreshHeader?) -> ())?
    
    var pullingDownBlock: ((_ contentOffset:CGPoint?) -> ())?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshHeaderView:RefreshHeader = RefreshHeader()
        refreshHeaderView.setrefreshingBlock {[weak self] view in
            if let startRefresh = self?.refreshingBlock, let view = view as? RefreshHeader{
                startRefresh(view)
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
    func refreshHeader() -> RefreshHeader?{
        if let refreshHeader = self.view as? RefreshHeader  {
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
    public init(startRefreshing:((RefreshHeader?) -> ())?,@ArgoKitViewBuilder _ builder:@escaping ()->View) {
        pNode = RefreshHeaderNode(viewClass: RefreshHeader.self)
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
