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

    private var _nodeObserver:ArgoKitNodeObserver?
    
    public func observeFrameChanged(changeHandler: @escaping (ArgoKitCellNode?) -> Void) {
        if _nodeObserver == nil {
            _nodeObserver = ArgoKitNodeObserver()
            _nodeObserver?.setFrameChange { [weak self] frame in
                if let `self` = self{
                    changeHandler(self)
                }
            }
            
            if let nodeObserver = _nodeObserver {
                self.addNode(observer: nodeObserver)
            }
        }

    }
    
    public func observeFrameChanged(changeHandler: @escaping (ArgoKitCellNode, NSKeyValueObservedChange<CGRect>) -> Void) {
        if frameObserber == nil{
//            frameObserber = observe(\.frame, options:[.old,.new], changeHandler:changeHandler)
            frameObserber = observe(\.frame, options:[.old,.new], changeHandler: { (cellNode, change) in
                if let oldFrame = change.oldValue,
                   let newFrame = change.newValue,
                   !oldFrame.equalTo(newFrame){
                    changeHandler(cellNode,change)
                }
            })
        }
    }
    
    public func removeObservingFrameChanged() {
        if frameObserber != nil {
            frameObserber?.invalidate()
            frameObserber = nil
        }
    }
    deinit {
        if #available(iOS 11.0, *) {
            } else {
                if let observation = self.frameObserber {
                    self.removeObserver(observation, forKeyPath: "frame")
                }
            }
    }
}

class DataSourceHelper<D> {
    weak var _rootNode : DataSourceReloadNode?
    var dataSourceType : DataSourceType  = .none
    let nodeLock:NSRecursiveLock  = NSRecursiveLock()
    private var defaultHeight:CGFloat = -1.0
    lazy var registedReuseIdSet = Set<String>()
    lazy var cellNodeCache:ArgoKitSafeMutableArray = ArgoKitSafeMutableArray()
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
    
    
    
    private func rowHeight_(_ node:ArgoKitCellNode?,maxWidth: CGFloat){
        if node?.size.width != maxWidth || node?.size.height == 0 {
            nodeLock.lock()
            defer {
                nodeLock.unlock()
            }
            node?.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
        }
    }
    
    @discardableResult
    open func rowHeight(_ data:Any?,maxWidth: CGFloat) -> CGFloat {
        if let sourceData_ = data,
           let node = self.nodeForData(sourceData_) {
            rowHeight_(node,maxWidth: maxWidth)
            return node.size.height
        }
        return 0.0
    }
    open func rowHeight(_ row: Int, at section: Int, maxWidth: CGFloat) -> CGFloat {
        if let node = self.nodeForRow(row, at: section) {
            rowHeight_(node,maxWidth: maxWidth)
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
    open func nodeForData(_ data: Any) -> ArgoKitCellNode? {
        let cellNode = _nodeForData_(data)
        return cellNode
    }
    private func _nodeForData_(_ data: Any) -> ArgoKitCellNode? {
        if let sourceData_ = data as? ArgoKitIdentifiable,
           let node = sourceData_.argokit_linkNode as? ArgoKitCellNode {
            return node
        }
        nodeLock.lock()
        defer {
            nodeLock.unlock()
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
        if let node_ = node{
            self.cellNodeCache.remove(node_)
            if let cellNode = node_ as? ArgoKitNode {
                cellNode.destroyProperties()
            }
        }
    }
    
    public func removeAll(){
        if let cache = self.cellNodeCache.copy() as? NSArray,
           cache.count > 0 {
//            DispatchQueue.global().async {
                for item in cache {
                    if let cellNode = item as? ArgoKitNode {
                        cellNode.destroyProperties()
                    }
                }
//            }
            self.cellNodeCache.removeAllObjects()
        }
       
    }
    
    public func addCellNode(_ node:Any?){
        if let node_ = node,self.cellNodeCache.contains(node_) == false{
            self.cellNodeCache.add(node_)
        }
    }
}
