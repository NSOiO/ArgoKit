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
    
    public convenience init(data: DataSource<DataList<T>>, @ArgoKitListBuilder rowContent: @escaping (T) -> View){
        self.init()
        viewPageNode.dataSourceHelper.dataSourceList = data
        viewPageNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}

extension ViewPage{
    /// Sets the action that handle the item at the specified index path .
    /// - Parameter action: The action that handle the item at the specified index path.
    /// - Returns: Self
    @discardableResult
    public func sizeForItem(_ action:@escaping (_ data: T, _ indexPath: IndexPath) -> CGSize) -> Self {
        let sel = #selector(viewPageNode.collectionView(_:layout:sizeForItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? T ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the item at the specified index path was selected.
    /// - Parameter action: The action that handle the item at the specified index path was selected.
    /// - Returns: Self
    @discardableResult
    public func cellSelected(_ action:@escaping (_ data: T, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(GridNode<T>.collectionView(_:didSelectItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? T ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
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
