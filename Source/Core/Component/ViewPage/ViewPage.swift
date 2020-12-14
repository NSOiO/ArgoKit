//
//  ViewPager.swift
//  ArgoKit
//
//  Created by sun-zt on 2020/12/4.
//

import Foundation

// MARK: Init
public class ViewPage<T> : ScrollView where T : ArgoKitIdentifiable {
    
    private var viewPageNode : ArgoKitViewPageNode {
        pNode as! ArgoKitViewPageNode
    }

    private override init() {
        super.init()
    }
    
    public convenience init(@ArgoKitListBuilder content: @escaping () -> View) {
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            viewPageNode.dataSourceHelper.dataList = [nodes]
        }
    }
    
    public convenience init(data: [T], @ArgoKitListBuilder rowContent: @escaping (T) -> View) {
        self.init()
        viewPageNode.dataSourceHelper.dataList = [data]
        viewPageNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    override func createNode() {
        pNode = ArgoKitViewPageNode(viewClass: UICollectionView.self)
        pNode?.flexGrow(1.0)
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
    public func scrollToPage(index:Int) -> Self {
        viewPageNode.scrollToPage(index: index)
        return self
    }
    @discardableResult
    public func pageCount(pageCount:Int) -> Self {
        viewPageNode.pageCount(pageCount: pageCount)
        return self
    }
    @discardableResult
    public func scrollEnable(enable:Bool) -> Self {
        addAttribute(#selector(setter: UICollectionView.isScrollEnabled), enable)
        return self
    }
    @discardableResult
    public func reuseEnable(enable:Bool) -> Self {
        viewPageNode.reuseEnable(enable: enable)
        return self
    }
    @discardableResult
    public func spacing(spacing:CGFloat) -> Self {
        viewPageNode.spacing(spacing: spacing)
        return self
    }
    @discardableResult
    public func onChangeSelected(selectedFunc:@escaping ViewPageChangedCloser) -> Self {
        viewPageNode.onChangeSelected(selectedFunc: selectedFunc)
        return self
    }
    @discardableResult
    public func setTabScrollingListener(scrollListener:@escaping ViewPageTabScrollingListener) -> Self {
        viewPageNode.setTabScrollingListener(scrollListener: scrollListener)
        return self
    }
}
