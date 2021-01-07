//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitCellNode: ArgoKitNode {
    
    var cellSourceData: Any?
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
    lazy var registedReuseIdSet = Set<String>()

    public var sectionDataSourceList:DataSource<SectionDataList<D>>?{
        didSet{
            sectionDataSourceList?._rootNode = _rootNode
        }
    }
    public var dataSourceList:DataSource<DataList<D>>?{
        didSet{
            dataSourceList?._rootNode = _rootNode
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
        if let nodelist =  nodeSourceList?.dataSource, nodelist.count >= 1{
            return nodelist.count
        }
        return dataSource()?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        if let nodelist =  nodeSourceList?.dataSource, nodelist.count >= 1{
            return nodelist[section].count
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
        if let nodelist =  nodeSourceList?.dataSource,
           nodelist.count > section,
           nodelist[section].count > row{
            
            return nodelist[section][row]
        }
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }

        return dataSource()![section][row]
    }
    
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitCellNode? {
        if let nodelist =  nodeSourceList?.dataSource,
           nodelist.count > section,
           nodelist[section].count > row{
            let node = nodelist[section][row]
            if let node_ = node.argokit_linkNode as? ArgoKitCellNode {
                return node_
            }
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            node.argokit_linkNode = cellNode
            return cellNode
        }
        
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }
        if let sourceData = self.dataSource()?[section][row]{
            // MARK:数据源中存在重复的数据对象的兼容处理
            let indexPath = IndexPath(row: row, section: section)
            if let sourceData_ = sourceData as? ArgoKitIdentifiable,let indexPath_ =  sourceData_.argokit_indexPath {
                if !indexPath.elementsEqual(indexPath_) {
                    sourceData_.argokit_linkNode = nil
                    sourceData_.argokit_indexPath = nil
                }
            }
            if let sourceData_ = sourceData as? ArgoKitIdentifiable,
               let node = sourceData_.argokit_linkNode as? ArgoKitCellNode {
                sourceData_.argokit_indexPath = indexPath
                return node
            }
            if let view = self.buildNodeFunc?(sourceData) {
                if let nodes = view.type.viewNodes() {
                    let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
                    cellNode.addChildNodes(nodes)
                    if let sourceData_ = sourceData as? ArgoKitIdentifiable{
                        sourceData_.argokit_linkNode = cellNode
                    }else{
                        cellNode.isPreviewing = true
                    }
                    return cellNode
                }
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
    
    open func rowHeight(_ row: Int, at section: Int, maxWidth: CGFloat) -> CGFloat {
        if let node = self.nodeForRow(row, at: section) {
            if node.size.width != maxWidth || node.size.height == 0 {
                node.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
            }
            return node.size.height
        }
        return 0.0
    }
}

// 数据操作
extension DataSourceHelper {
    public func deleteRows(_ indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        for indexPath in indexPaths {
            if var value = self.sectionDataSourceList?.dataSource{
                value[indexPath.section].remove(at:indexPath.row)
                self.sectionDataSourceList?.dataSource = value
            }
            if var value = self.dataSourceList?.dataSource{
                value.remove(at:indexPath.row)
                self.dataSourceList?.dataSource = value
            }
        }
        
        if let node = self._rootNode{
            node.deleteRows(at: indexPaths, with: animation)
        }
    }
    
    func deleteRow(_ indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.deleteRows([indexPath], with: animation)
    }

    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        
        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![indexPath.section][indexPath.row]
        if var value = self.sectionDataSourceList?.dataSource {
            value[indexPath.section].remove(at:indexPath.row)
            self.sectionDataSourceList?.dataSource = value
        }else if var value = self.dataSourceList?.dataSource{
            value.remove(at:indexPath.row)
            self.dataSourceList?.dataSource = value
        }
        if indexPath.section != newIndexPath.section
            || newIndexPath.row < indexPath.row {
            if var value = self.sectionDataSourceList?.dataSource {
                value[newIndexPath.section].insert(itemToMove,at:newIndexPath.row)
                self.sectionDataSourceList?.dataSource = value
            }else if var value = self.dataSourceList?.dataSource{
                value.insert(itemToMove,at:newIndexPath.row)
                self.dataSourceList?.dataSource = value
            }
        } else {
            if var value = self.sectionDataSourceList?.dataSource {
                value[newIndexPath.section].insert(itemToMove,at:newIndexPath.row - 1)
                self.sectionDataSourceList?.dataSource = value
            }else if var value = self.dataSourceList?.dataSource{
                value.insert(itemToMove,at:newIndexPath.row - 1)
                self.dataSourceList?.dataSource = value
            }
        }
        if let node = self._rootNode{
            node.moveRow(at: indexPath, to: newIndexPath)
        }
    }
}

