//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitGridDataSourceHelper{
    
    lazy var registedReuseIdSet = Set<String>()
        
    public var dataList:DataBind<Array<Array<Any>>>?
    public var buildNodeFunc: ((Any)->View?)?
    func dataSource()->Array<Array<Any>>? {
        return dataList?.wrappedValue
    }
    
}

extension ArgoKitGridDataSourceHelper {
    
    open func numberOfSection() -> Int {
        
        return dataSource()?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        
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
                
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }
        
        if let node = self.dataSource()![section][row] as? ArgoKitCellNode {
            return node.cellSourceData
        }

        return dataSource()![section][row]
    }
    
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitCellNode? {
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return nil
        }

        if let node = self.dataSource()![section][row] as? ArgoKitCellNode {
            return node
        }
        
        let sourceData = self.dataSource()![section][row]
        
        if let node = sourceData as? ArgoKitNode {
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            cellNode.cellSourceData = node
            dataList!.wrappedValue?[section][row] = cellNode
            return cellNode
        }
        
        if let view = self.buildNodeFunc?(sourceData) {
            if let nodes = view.type.viewNodes() {
                let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
                cellNode.addChildNodes(nodes)
                cellNode.cellSourceData = sourceData;
                dataList!.wrappedValue?[section][row] = cellNode
                return cellNode
            }
        }
        return nil
    }
    
    open func nodeForRowNoCache(_ row: Int, at section: Int) -> ArgoKitNode? {
                
        if let data = dataForRow(row, at: section), let view = self.buildNodeFunc?(data) {
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

extension ArgoKitGridDataSourceHelper {
    
    func reloadSection(data: [Any], section: Int) {
        if section >= dataSource()?.count ?? 0 {
            return
        }
        
        dataList!.wrappedValue?[section] = data
    }
    
    func reloadRow(rowData: Any, row: Int, at section: Int) {
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return
        }
        
        dataList!.wrappedValue?[section][row] = rowData
    }
    
    func appendSections(_ data: [[Any]]) {
        if dataSource() == nil {
            dataList!.wrappedValue? = data
            return
        }

        dataList?.wrappedValue?.append(contentsOf: data)
    }
    
    func appendRows(rowData: [Any], at section: Int) {
        
        if dataSource() == nil {
            dataList!.wrappedValue? = [rowData]
            return
        }

        if section >= dataSource()?.count ?? 0 {
            dataList?.wrappedValue?.append(contentsOf: [rowData])
            return
        }
        
        dataList?.wrappedValue?[section].append(contentsOf: rowData)
    }
    
    func insertSection(data: [Any], section: Int) {
        
        if section >= dataSource()?.count ?? 0 {
            appendSections([data])
            return
        }
        
        dataList?.wrappedValue?.insert(data, at: section)
    }
    
    func insertRow(rowData: Any, row: Int, at section: Int) {
        
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            appendRows(rowData: [rowData], at: section)
            return
        }
        
        dataList?.wrappedValue?[section].insert(rowData, at: row)
    }
    
    func deleteRow(_ row: Int, at section: Int) {
                
        if section >= dataSource()?.count ?? 0
            || row >= dataSource()?[section].count ?? 0 {
            return
        }
        
        dataList?.wrappedValue?[section].remove(at: row)
    }
    
    func deleteSection(_ section: Int) {

        dataList?.wrappedValue?.remove(at: section)
    }
        
    
    func moveSection(_ section: Int, toSection newSection: Int) {
        
        if section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![section]
        dataList?.wrappedValue?.remove(at: section)
        if newSection > section {
            dataList?.wrappedValue?.insert(itemToMove, at: newSection-1)
        } else {
            dataList?.wrappedValue?.insert(itemToMove, at: newSection)
        }
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
                
        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![indexPath.section][indexPath.row]
        dataList?.wrappedValue?[indexPath.section].remove(at: indexPath.row)
        if indexPath.section != newIndexPath.section
            || newIndexPath.row < indexPath.row {
            dataList?.wrappedValue?[newIndexPath.section].insert(itemToMove, at: newIndexPath.row)
        } else {
            dataList?.wrappedValue?[newIndexPath.section].insert(itemToMove, at: newIndexPath.row-1)
        }
    }
}
