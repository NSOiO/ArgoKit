//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper {
    
    lazy var registedReuseIdSet = Set<String>()
        
    public var dataList: [[Any]]?
    public var buildNodeFunc: ((Any)->View)?
}

extension ArgoKitDataSourceHelper {
    
    open func numberOfSection() -> Int {
        
        return dataList?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        
        if section < dataList?.count ?? 0 {
            return dataList![section].count
        }
        return 0
    }
    
    open func reuseIdForRow(_ row: Int, at section: Int) -> String? {
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let item = dataList![section][row] as? ArgoKitIdentifiable {
            return item.reuseIdentifier
        }
        return nil
    }
    
    open func dataForRow(_ row: Int, at section: Int) -> Any? {
                
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let node = self.dataList![section][row] as? ArgoKitCellNode {
            return node.cellSourceData
        }
        
        if self.dataList![section][row] is ArgoKitNode {
            return nil
        }
        return dataList![section][row]
    }
    
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitCellNode? {
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }

        if let node = self.dataList![section][row] as? ArgoKitCellNode {
            return node
        }
        
        if let node = self.dataList![section][row] as? ArgoKitNode {
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            self.dataList![section][row] = cellNode
            return cellNode
        }
        
        let sourceData = self.dataList![section][row]
        if let view = self.buildNodeFunc?(sourceData) {
            if let nodes = view.type.viewNodes() {
                let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
                cellNode.addChildNodes(nodes)
                cellNode.cellSourceData = sourceData;
                self.dataList![section][row] = cellNode
                return cellNode
            }
        }
        return nil
    }
    
    open func nodeForRowNoCache(_ row: Int, at section: Int) -> ArgoKitNode? {
                
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let view = self.buildNodeFunc?(self.dataList![section][row]) {
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

extension ArgoKitDataSourceHelper {
    
    func appendSection(_ data: [Any]) {
        if dataList == nil {
            dataList = [data]
            return
        }
        
        dataList?.append(data)
    }
    
    func appendRow(rowData: Any, at section: Int) {
        
        if dataList == nil {
            dataList = [[rowData]]
            return
        }

        if section >= dataList?.count ?? 0 {
            dataList?.append([rowData])
            return
        }
        
        dataList?[section].append(rowData)
    }
    
    func insertSection(data: [Any], section: Int) {
        
        if section >= dataList?.count ?? 0 {
            appendSection(data)
            return
        }
        
        dataList?.insert(data, at: section)
    }
    
    func insertRow(rowData: Any, row: Int, at section: Int) {
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            appendRow(rowData: rowData, at: section)
            return
        }
        
        dataList?[section].insert(rowData, at: row)
    }
    
    func deleteRow(_ row: Int, at section: Int) {
                
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return
        }
        
        dataList![section].remove(at: row)
    }
    
    func deleteSection(_ section: Int) {

        dataList?.remove(at: section)
    }
        
    func moveRow(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                
        if sourceIndexPath.section >= dataList?.count ?? 0
            || sourceIndexPath.row >= dataList?[sourceIndexPath.section].count ?? 0
            || destinationIndexPath.section >= dataList?.count ?? 0 {
            return
        }
        
        let itemToMove = dataList![sourceIndexPath.section][sourceIndexPath.row]
        dataList![sourceIndexPath.section].remove(at: sourceIndexPath.row)
        dataList![destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
    }
}
