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

    private var innerScrollListener: ViewPageTabScrollingListener?
    private var externalScrollListener: ViewPageTabScrollingListener?
    
    override func createNode() {
        pNode = ArgoKitViewPageNode<T>(viewClass: UICollectionView.self)
        pNode?.flexGrow(1.0)
    }

    internal required init() {
        super.init()
        setupTabScrollingListener()
    }
    
    public convenience init(@ArgoKitListBuilder content: @escaping () -> View) where T:ArgoKitNode{
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            viewPageNode.dataSourceHelper.nodeSourceList?.append(data: nodes)
        }
    }
    
    public convenience init(data: DataSource<DataList<T>>, @ArgoKitListBuilder rowContent: @escaping (T) -> View) where T : ArgoKitIdentifiable{
        self.init()
        viewPageNode.dataSourceHelper.dataSourceList = data
        viewPageNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
    
    private func setupTabScrollingListener() {
        viewPageNode.setTabScrollingListener { [unowned self] (percent, from, to, scrolling) in
            if let inner = innerScrollListener {
                inner(percent, from, to, scrolling)
            }
            if let external = externalScrollListener {
                external(percent, from, to, scrolling)
            }
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
        externalScrollListener = scrollListener
        return self
    }
}

extension ViewPage {
    @discardableResult
    public func link(tabSegment tab: TabSegment) -> Self {
        innerScrollListener = { (percent, from, to, scrolling) in
            tab.scroll(from, to, Float(percent), !scrolling)
        }
        tab.clickedCallback { [weak self] (index, shouldAnim) in
            self?.scrollToPage(index: index, callScrollListener: false)
        }
        return self
    }
}
