//
//  ArgoKitRefreshHeaderView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation

class RefreshHeaderNode:ArgoKitNode{

    var refreshingBlock: (() -> ())?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let refreshHeaderView:ArgoKitRefreshHeader = ArgoKitRefreshHeader.headerWithRefreshingBlock { [weak self] in
            if let startRefresh = self?.refreshingBlock{
                startRefresh()
            }
        }
        return refreshHeaderView
    }
    
    func endRefreshing() {
        (self.view as! ArgoKitRefreshHeader).endRefreshing()
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
        addSubNodes(builder:builder)
    }
    
    public func endRefreshing() {
        pNode?.endRefreshing()
    }
    
}
