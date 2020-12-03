//
//  ArgoKitRefreshFooterView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
class RefreshFooterNode:ArgoKitNode{

    var refreshingBlock: (() -> ())?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshFooterView:ArgoKitRefreshFooter = ArgoKitRefreshAutoFooter.footerWithRefreshingBlock {  [weak self] in
            if let startRefresh = self?.refreshingBlock{
                startRefresh()
            }
        }
        return refreshFooterView
    }
    
    func endRefreshing() {
        (self.view as! ArgoKitRefreshFooter).endRefreshing()
    }
    
    func resetNoMoreData(){
        (self.view as! ArgoKitRefreshFooter).resetNoMoreData()
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
        addSubNodes(builder:builder)
    }
    
    public func endRefreshing() {
        pNode?.endRefreshing()
    }
    
    public func resetNoMoreData() {
        pNode?.endRefreshing()
    }
    
}
