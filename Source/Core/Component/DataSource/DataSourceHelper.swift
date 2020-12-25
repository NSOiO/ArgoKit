//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class DataSourceHelper<D>{
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
    public var nodeSourceList:DataSource<SectionDataList<ArgoKitNode>>?
    
    public var buildNodeFunc: ((D)->View?)?
    
    init() {
        nodeSourceList = DataSource<SectionDataList<ArgoKitNode>>(wrappedValue: SectionDataList<ArgoKitNode>())
    }
    
    func dataSource()->Array<Array<D>>? {
        if let list = sectionDataSourceList?.wrappedValue{
            return list
        }
        if let list = dataSourceList?.wrappedValue {
            return [list]
        }
        return [[]]
    }
}

extension DataSourceHelper {
    
    open func numberOfSection() -> Int {
        if let nodelist =  nodeSourceList?.wrappedValue, nodelist.count >= 1{
            return nodelist.count
        }
        return dataSource()?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        if let nodelist =  nodeSourceList?.wrappedValue, nodelist.count >= 1{
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
        if let nodelist =  nodeSourceList?.wrappedValue,
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
    
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitCellNode?{
        if let nodelist =  nodeSourceList?.wrappedValue,
           nodelist.count > section,
           nodelist[section].count > row{
            let node = nodelist[section][row]
            if let node_ = node.linkNode as? ArgoKitCellNode{
                return node_
            }
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            node.linkNode = cellNode
            return cellNode
        }
        
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }
        if let sourceData = self.dataSource()?[section][row]{
            // MARK:数据源中存在重复的数据对象的兼容处理
            let indexPath = IndexPath(row: row, section: section)
            if let sourceData_ = sourceData as? ArgoKitIdentifiable,let indexPath_ =  sourceData_.indexpPath{
                if !indexPath.elementsEqual(indexPath_) {
                    sourceData_.linkNode = nil
                    sourceData_.indexpPath = nil
                }
            }
            if let sourceData_ = sourceData as? ArgoKitIdentifiable,
               let node = sourceData_.linkNode as? ArgoKitCellNode {
                sourceData_.indexpPath = indexPath
                return node
            }
            if let view = self.buildNodeFunc?(sourceData) {
                if let nodes = view.type.viewNodes() {
                    let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
                    cellNode.addChildNodes(nodes)
                    if let sourceData_ = sourceData as? ArgoKitIdentifiable{
                        sourceData_.linkNode = cellNode
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
    func deleteRow(_ indexPath: IndexPath,with animation: UITableView.RowAnimation) {

        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0 {
            return
        }
        if let list =  self.sectionDataSourceList {
            list.deleteRow(at: indexPath, with: animation)
        }else if let list = self.dataSourceList{
            list.deleteRow(at: indexPath, with: animation)
        }
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
                
        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataSource()?.count ?? 0 {
            return
        }
        
        if let list =  self.sectionDataSourceList {
            list.moveRow(at: indexPath, to: newIndexPath)
        }else if let list = self.dataSourceList{
            list.moveRow(at: indexPath, to: newIndexPath)
        }
    }
}
// MARK:暂时不需要
extension DataSourceHelper {
    
    
//    func reloadSection(data: [D], section: Int) {
//        if section >= dataSource()?.count ?? 0 {
//            return
//        }
//        sectionDataSourceList!.wrappedValue[section] = data
//    }
//
//    func reloadRow(rowData: D, row: Int, at section: Int) {
//        if section >= dataSource()?.count ?? 0
//            || row >= dataSource()?[section].count ?? 0 {
//            return
//        }
//
//        sectionDataSourceList!.wrappedValue[section][row] = rowData
//    }
//
//    func appendSections(_ data: [[D]]) {
//        if dataSource() == nil {
//            sectionDataSourceList!.wrappedValue = data
//            return
//        }
//
//        sectionDataSourceList?.wrappedValue.append(contentsOf: data)
//    }
//
//    func appendRows(rowData: [D], at section: Int) {
//
//        if dataSource() == nil {
//            sectionDataSourceList!.wrappedValue = [rowData]
//            return
//        }
//
//        if section >= dataSource()?.count ?? 0 {
//            sectionDataSourceList?.wrappedValue.append(contentsOf: [rowData])
//            return
//        }
//
//        sectionDataSourceList?.wrappedValue[section].append(contentsOf: rowData)
//    }
//
//    func insertSection(data: [D], section: Int) {
//
//        if section >= dataSource()?.count ?? 0 {
//            appendSections([data])
//            return
//        }
//        sectionDataSourceList?.wrappedValue.insert(data, at: section)
//    }
//
//    func insertRow(rowData: D, row: Int, at section: Int) {
//
//        if section >= dataSource()?.count ?? 0
//            || row >= dataSource()?[section].count ?? 0 {
//            appendRows(rowData: [rowData], at: section)
//            return
//        }
//
//        sectionDataSourceList?.wrappedValue[section].insert(rowData, at: row)
//    }
    

    
    //注释掉，不需要
//    func deleteSection(_ section: Int) {
//        sectionDataSourceList?.wrappedValue.remove(at: section)
//    }
//
//    func moveSection(_ section: Int, toSection newSection: Int) {
//
//        if section >= dataSource()?.count ?? 0 {
//            return
//        }
//
//        let itemToMove = dataSource()![section]
//        sectionDataSourceList?.wrappedValue.remove(at: section)
//        if newSection > section {
//            sectionDataSourceList?.wrappedValue.insert(itemToMove, at: newSection-1)
//        } else {
//            sectionDataSourceList?.wrappedValue.insert(itemToMove, at: newSection)
//        }
//    }
    

}
