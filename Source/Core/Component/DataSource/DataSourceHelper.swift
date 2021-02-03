//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitCellNode: ArgoKitNode {
    var isPreviewing:Bool = false
    var frameObserber: NSKeyValueObservation?

    public func observeFrameChanged(changeHandler: @escaping (ArgoKitCellNode, NSKeyValueObservedChange<CGRect>) -> Void) {
        removeObservingFrameChanged()
        frameObserber = observe(\.frame, options: .new, changeHandler: changeHandler)
    }
    
    public func removeObservingFrameChanged() {
        if frameObserber != nil {
            frameObserber?.invalidate()
            frameObserber = nil
        }
    }
}

class DataSourceHelper<D> {
    weak var _rootNode : DataSourceReloadNode?
    var dataSourceType : DataSourceType  = .none
    var lock:NSLock  = NSLock()
    var cacluteLock:NSLock  = NSLock()
    var cacheLock:NSLock  = NSLock()
    lazy var registedReuseIdSet = Set<String>()
    lazy var cellNodeCache:NSMutableArray = NSMutableArray()
    var nodeQueue:DispatchQueue = DispatchQueue(label: "com.argokit.create.node")
    public var sectionDataSourceList:DataSource<SectionDataList<D>>?{
        didSet{
            sectionDataSourceList?._rootNode = _rootNode
            sectionDataSourceList?.type = dataSourceType
        }
    }
    public var dataSourceList:DataSource<DataList<D>>?{
        didSet{
            dataSourceList?._rootNode = _rootNode
            dataSourceList?.type = dataSourceType
        }
    }
    lazy public var nodeSourceList:DataSource<SectionDataList<ArgoKitNode>>? = {
        let _nodeSourceList = DataSource<SectionDataList<ArgoKitNode>>(wrappedValue: SectionDataList<ArgoKitNode>())
        return _nodeSourceList
    }()
    
    public var buildNodeFunc: ((D)->View?)?
    
    
    func dataSource()->SectionDataList<D>? {
        if let list = sectionDataSourceList?.dataSource{
            return list
        }
        if let list = dataSourceList?.dataSource {
            return [list]
        }
        return [[]]
    }
    deinit {
        removeAll()
    }
}

extension DataSourceHelper {
    
    open func numberOfSection() -> Int {
        if let count =  nodeSourceList?.count(), count >= 1{
            return count
        }
        return dataSource()?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        if let count =  nodeSourceList?.count(), count >= 1,
           let rowCount = nodeSourceList?.count(section: section){
            return rowCount
        }
        if section < dataSource()?.count ?? 0 {
            return dataSource()![section].count
        }
        return 0
    }
    
    
    open func reuseIdForRow(_ row: Int, at section: Int) -> String? {
        if let item = dataForRow(row, at: section) {
            if let reuseItem = item as? ArgoKitIdentifiable {
                return reuseItem.reuseIdentifier
            }
            if let hashItem = item as? NSObjectProtocol  {
                return String(hashItem.hash)
            }
        }
        return nil
    }
    
    open func dataForRow(_ row: Int, at section: Int) -> Any? {
        if let nodelist =  nodeSourceList,
           nodelist.count() > section,
           nodelist.count(section: section) > row{
            return nodeSourceList?[section][row]
        }
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }
        return dataSource()![section][row]
    }
    open func rowHeight(_ row: Int, at section: Int, maxWidth: CGFloat) -> CGFloat {
        if let node = self.nodeForRow(row, at: section) {
            rowHeight(node,maxWidth: maxWidth)
            return node.size.height
        }
        return 0.0
    }
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitCellNode? {
        if let nodelist =  nodeSourceList,
           nodelist.count() > section,
           nodelist.count(section: section) > row{
            let node = nodelist[row,section]
            if let node_ = node.argokit_linkNode as? ArgoKitCellNode {
                return node_
            }
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            node.argokit_linkNode = cellNode
            addCellNode(cellNode)
            return cellNode
        }
        
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }
        if let sourceData = self.dataSource()?[section][row]{
            return nodeForData(sourceData)
        }
        return nil
    }
    open func nodeForData(_ data: Any) -> ArgoKitCellNode?{
        lock.lock()
        let cellNode = _nodeForData_(data)
        lock.unlock()
        return cellNode
    }
    
    private func _nodeForData_(_ data: Any) -> ArgoKitCellNode? {
        if let sourceData_ = data as? ArgoKitIdentifiable,
           let node = sourceData_.argokit_linkNode as? ArgoKitCellNode {
            return node
        }
        if let sourceData_ = data as? D,let view = self.buildNodeFunc?(sourceData_) {
            if let nodes = view.type.viewNodes() {
                let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
                cellNode.addChildNodes(nodes)
                if let sourceData_ = data as? ArgoKitIdentifiable{
                    sourceData_.argokit_linkNode = cellNode
                }else{
                    cellNode.isPreviewing = true
                }
                addCellNode(cellNode)
                return cellNode
            }
        }
        return nil
    }
    
    open func rowHeight(_ node:ArgoKitCellNode?,maxWidth: CGFloat){
        cacluteLock.lock()
        if node?.size.width != maxWidth || node?.size.height == 0 {
            node?.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
        }
        cacluteLock.unlock()
    }
    
    open func nodeForRowNoCache(_ row: Int, at section: Int) -> ArgoKitNode? {
        if let data = dataForRow(row, at: section), let view = self.buildNodeFunc?(data as! D) {
            if let nodes = view.type.viewNodes() {
                let contentNode = ArgoKitCellNode(viewClass: UIView.self)
                contentNode.addChildNodes(nodes)
                return contentNode
            }
        }
        return nil
    }
}

// 数据操作
extension DataSourceHelper {
    public func deleteRows(_ indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let nodeList = nodeSourceList {
            nodeList.delete(at: indexPaths).apply()
        }
        if let sectionList = sectionDataSourceList {
            sectionList.delete(at: indexPaths).apply()
        }
        if let list = dataSourceList {
            list.delete(at: indexPaths).apply()
        }
    }
    
    func deleteRow(_ indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.deleteRows([indexPath], with: animation)
    }

    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        if let nodeList = nodeSourceList {
            nodeList.move(at: indexPath, to: newIndexPath).apply()
        }
        if let sectionList = sectionDataSourceList {
            sectionList.move(at: indexPath, to: newIndexPath).apply()
        }
        if let list = dataSourceList {
            list.move(at: indexPath, to: newIndexPath).apply()
        }
    }
}

extension DataSourceHelper{
    public func removeNode(_ node:Any?){
        cacheLock.lock()
        if let node_ = node,cellNodeCache.contains(node_) {
            cellNodeCache.remove(node_)
        }
        cacheLock.unlock()
    }
    
    public func removeAll(){
        cacheLock.lock()
        cellNodeCache.removeAllObjects()
        cacheLock.unlock()
    }
    
    public func addCellNode(_ node:Any?){
        cacheLock.lock()
        if let node_ = node,cellNodeCache.contains(node_) == false {
            cellNodeCache.add(node_)
        }
        cacheLock.unlock()
    }
    
    public func getCellNodeCache()->NSArray{
        var cache = NSArray()
        cacheLock.lock()
        cache = cellNodeCache.copy() as! NSArray
        cacheLock.unlock()
        return cache
    }
}
