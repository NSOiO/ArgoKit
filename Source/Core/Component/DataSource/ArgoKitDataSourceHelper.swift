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

class ArgoKitDataSourceHelper {
    
    lazy var registedReuseIdSet = Set<String>()
        
    public var dataList: [[Any]]?
    public var buildNodeFunc: ((Any)->View?)?
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
                
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let node = self.dataList![section][row] as? ArgoKitCellNode {
            return node.cellSourceData
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
        
        let sourceData = self.dataList![section][row]
        
        if let node = sourceData as? ArgoKitNode {
            let cellNode: ArgoKitCellNode = ArgoKitCellNode(viewClass: UIView.self)
            cellNode.addChildNode(node)
            cellNode.cellSourceData = node
            self.dataList![section][row] = cellNode
            return cellNode
        }
        
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

extension ArgoKitDataSourceHelper {
    
    func reloadSection(data: [Any], section: Int) {
        if section >= dataList?.count ?? 0 {
            return
        }
        
        dataList?[section] = data
    }
    
    func reloadRow(rowData: Any, row: Int, at section: Int) {
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return
        }
        
        dataList?[section][row] = rowData
    }
    
    func appendSections(_ data: [[Any]]) {
        if dataList == nil {
            dataList = data
            return
        }

        dataList?.append(contentsOf: data)
    }
    
    func appendRows(rowData: [Any], at section: Int) {
        
        if dataList == nil {
            dataList = [rowData]
            return
        }

        if section >= dataList?.count ?? 0 {
            dataList?.append(contentsOf: [rowData])
            return
        }
        
        dataList?[section].append(contentsOf: rowData)
    }
    
    func insertSection(data: [Any], section: Int) {
        
        if section >= dataList?.count ?? 0 {
            appendSections([data])
            return
        }
        
        dataList?.insert(data, at: section)
    }
    
    func insertRow(rowData: Any, row: Int, at section: Int) {
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            appendRows(rowData: [rowData], at: section)
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
        
    
    func moveSection(_ section: Int, toSection newSection: Int) {
        
        if section >= dataList?.count ?? 0 {
            return
        }
        
        let itemToMove = dataList![section]
        dataList!.remove(at: section)
        if newSection > section {
            dataList!.insert(itemToMove, at: newSection-1)
        } else {
            dataList!.insert(itemToMove, at: newSection)
        }
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
                
        if indexPath.section >= dataList?.count ?? 0
            || indexPath.row >= dataList?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataList?.count ?? 0 {
            return
        }
        
        let itemToMove = dataList![indexPath.section][indexPath.row]
        dataList![indexPath.section].remove(at: indexPath.row)
        if indexPath.section != newIndexPath.section
            || newIndexPath.row < indexPath.row {
            dataList![newIndexPath.section].insert(itemToMove, at: newIndexPath.row)
        } else {
            dataList![newIndexPath.section].insert(itemToMove, at: newIndexPath.row-1)
        }
    }
}
