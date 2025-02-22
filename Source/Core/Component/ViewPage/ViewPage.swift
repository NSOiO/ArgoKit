//
//  ViewPager.swift
//  ArgoKit
//
//  Created by sun-zt on 2020/12/4.
//

import Foundation

// MARK: Init
public class ViewPage<T> : ScrollView {
    
    var viewPageNode : ArgoKitViewPageNode<T> {
        pNode as! ArgoKitViewPageNode
    }
    
    override func createNode() {
        pNode = ArgoKitViewPageNode<T>(viewClass: UICollectionView.self, type: Self.self)
        pNode?.flexGrow(1.0)
    }

    internal required init() {
        super.init()
    }
    
    public convenience init(@ArgoKitListBuilder content: @escaping () -> View) where T:ArgoKitNode{
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            viewPageNode.dataSourceHelper.nodeSourceList?.append(nodes)
        }
    }
    
    public convenience init(data: DataSource<DataList<T>>, @ArgoKitListBuilder rowContent: @escaping (T) -> View) where T : ArgoKitIdentifiable{
        self.init()
        viewPageNode.dataSourceHelper.dataSourceList = data
        viewPageNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}

// MARK: UI Method

extension ViewPage {
    
    @discardableResult
    public func reloadData() -> Self {
        viewPageNode.reloadData()
        return self
    }
    
    @discardableResult
    public func onChangeSelected(selectedFunc:@escaping ViewPageChangedCloser) -> Self {
        viewPageNode.onChangeSelected(selectedFunc: selectedFunc)
        return self
    }
    
    @discardableResult
    public func pageScrollingListener(scrollListener:@escaping ViewPageTabScrollingListener) -> Self {
        viewPageNode.setTabScrollingListener(scrollListener: scrollListener)
        return self
    }
}

extension ViewPage {
    @discardableResult
    public func link(tabSegment tab: TabSegment?) -> Self {
        if let tab = tab {
            viewPageNode.setTabInternalScrollingListener { (percent, from, to, scrolling) in
                tab.scroll(from, to, Float(percent), !scrolling)
            }
            tab.clickedInternalCallback { [weak viewPageNode] (index, shouldAnim) in
                viewPageNode?.scrollToPage(to: index, callScrollListener: false)
            }
        }
        return self
    }
    
    @discardableResult
    public func unlink(tabSegment tab: TabSegment?) -> Self {
        if let tab = tab {
            viewPageNode.setTabInternalScrollingListener(nil)
            tab.clickedInternalCallback(nil)
        }
        return self
    }
}
