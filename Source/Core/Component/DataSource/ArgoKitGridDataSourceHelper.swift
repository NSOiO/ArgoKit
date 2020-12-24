//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitGridDataSourceHelper<D>{
    
    lazy var registedReuseIdSet = Set<String>()

    public var sectionDataSourceList:DataSource<SectionDataList<D>>?{
        didSet{
            
        }
    }
    public var dataSourceList:DataSource<DataList<D>>?{
        didSet{
           
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

extension ArgoKitGridDataSourceHelper {
    
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
    
    // 获取model唯一key
    func dataIdForRow(_ row: Int, at section: Int) -> String {
        if let item = dataForRow(row, at: section) {
            if let reuseItem = item as? ArgoKitIdentifiable {
                return reuseItem.identifier
            }
            if let hashItem = item as? NSObjectProtocol  {
                return String(hashItem.hash)
            }
        }
        return ""
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
            if let sourceData_ = sourceData as? ArgoKitIdentifiable,let node = sourceData_.linkNode as? ArgoKitCellNode {
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
extension ArgoKitGridDataSourceHelper {
    
    
    func reloadSection(data: [D], section: Int) {
        if section >= dataSource()?.count ?? 0 {
            return
        }
        sectionDataSourceList!.wrappedValue?[section] = data
    }
    
    func reloadRow(rowData: D, row: Int, at section: Int) {
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return
        }
        
        sectionDataSourceList!.wrappedValue?[section][row] = rowData
    }
    
    func appendSections(_ data: [[D]]) {
        if dataSource() == nil {
            sectionDataSourceList!.wrappedValue? = data
            return
        }

        sectionDataSourceList?.wrappedValue?.append(contentsOf: data)
    }
    
    func appendRows(rowData: [D], at section: Int) {
        
        if dataSource() == nil {
            sectionDataSourceList!.wrappedValue? = [rowData]
            return
        }

        if section >= dataSource()?.count ?? 0 {
            sectionDataSourceList?.wrappedValue?.append(contentsOf: [rowData])
            return
        }
        
        sectionDataSourceList?.wrappedValue?[section].append(contentsOf: rowData)
    }
    
    func insertSection(data: [D], section: Int) {
        
        if section >= dataSource()?.count ?? 0 {
            appendSections([data])
            return
        }
        sectionDataSourceList?.wrappedValue?.insert(data, at: section)
    }
    
    func insertRow(rowData: D, row: Int, at section: Int) {
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            appendRows(rowData: [rowData], at: section)
            return
        }
        
        sectionDataSourceList?.wrappedValue?[section].insert(rowData, at: row)
    }
    
    func deleteRow(_ row: Int, at section: Int) {
                
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return
        }
        
        sectionDataSourceList?.wrappedValue?[section].remove(at: row)
    }
    
    //注释掉，不需要
    func deleteSection(_ section: Int) {
        sectionDataSourceList?.wrappedValue?.remove(at: section)
    }
        
    func moveSection(_ section: Int, toSection newSection: Int) {
        
        if section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![section]
        sectionDataSourceList?.wrappedValue?.remove(at: section)
        if newSection > section {
            sectionDataSourceList?.wrappedValue?.insert(itemToMove, at: newSection-1)
        } else {
            sectionDataSourceList?.wrappedValue?.insert(itemToMove, at: newSection)
        }
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
                
        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![indexPath.section][indexPath.row]
        sectionDataSourceList?.wrappedValue?[indexPath.section].remove(at: indexPath.row)
        if indexPath.section != newIndexPath.section
            || newIndexPath.row < indexPath.row {
            sectionDataSourceList?.wrappedValue?[newIndexPath.section].insert(itemToMove , at: newIndexPath.row)
        } else {
            sectionDataSourceList?.wrappedValue?[newIndexPath.section].insert(itemToMove , at: newIndexPath.row-1)
        }
    }
}
