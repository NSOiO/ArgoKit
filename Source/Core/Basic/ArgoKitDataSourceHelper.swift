//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper {
      
    lazy var nodeCache: NSCache<NSString, ArgoKitNode> = { () -> NSCache<NSString, ArgoKitNode> in
        let cahe = NSCache<NSString, ArgoKitNode>()
        cahe.name = "com.\(type(of: self)).node.cache"
        cahe.countLimit = 500
        return cahe
    }()
    
    lazy var registedReuseIdSet = NSMutableSet()
    
    public var nodeList: [[ArgoKitNode]]?
    
    public var dataList: [[Any]]?
    public var buildNodeFunc: ((Any)->View)?
}

extension ArgoKitDataSourceHelper {
    
    open func numberOfSection() -> Int {
        
        if nodeList != nil {
            return nodeList?.count ?? 1
        }
        return dataList?.count ?? 1
    }
    
    open func numberOfRows(section: Int) -> Int {
        
        if nodeList != nil {
            if section < nodeList!.count {
                return nodeList![section].count
            }
            return 0
        }
        
        if section < dataList?.count ?? 0 {
            return dataList![section].count
        }
        return 0
    }
    
    open func cacheKeyForRow(_ row: Int, at section: Int) -> String {
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                if let node = nodeList![section][row] as? ArgoKitIdentifiable {
                    return node.identifier
                } else {
                    let node = nodeList![section][row]
                    return String("\(node)".hashValue)
                }
            }
            return "defualt"
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return "defualt"
        }
        
        if let item = dataList![section][row] as? ArgoKitIdentifiable {
            return item.identifier
        }
        
        let item = dataList![section][row]
        return String("\(item)".hashValue)
    }
    
    open func reuseIdForRow(_ row: Int, at section: Int) -> String? {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                if let node = nodeList![section][row] as? ArgoKitIdentifiable {
                    return node.reuseIdentifier
                }
            }
            return nil
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let item = dataList![section][row] as? ArgoKitIdentifiable {
            return item.reuseIdentifier
        }
        return nil
    }
    
    open func nodeForRow(_ row: Int, at section: Int) -> ArgoKitNode? {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                return nodeList![section][row]
            }
            return nil
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
        if let node = self.nodeCache.object(forKey: cacheKey) {
            return node
        } else if let view = self.buildNodeFunc?(self.dataList![section][row]) {
            if let nodes = view.type.viewNodes() {
                let contentNode = ArgoKitNode(viewClass: UIView.self)
                contentNode.addChildNodes(nodes)
                self.nodeCache.setObject(contentNode, forKey: cacheKey)
                return contentNode
            }
        }
        return nil
    }
    
    open func nodeForRowNoCache(_ row: Int, at section: Int) -> ArgoKitNode? {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                return nodeList![section][row]
            }
            return nil
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        if let view = self.buildNodeFunc?(self.dataList![section][row]) {
            if let nodes = view.type.viewNodes() {
                let contentNode = ArgoKitNode(viewClass: UIView.self)
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
    
    func removeAllCache() {
        
        if nodeList != nil {
            for section in nodeList! {
                for node in section {
                    node.size = .zero
                    node.markDirty()
                }
            }
            return
        }
        
        self.nodeCache.removeAllObjects()
    }
    
    func removeCache(at section: Int) {
        
        if nodeList != nil {
            if section < nodeList!.count {
                let nodeSection = nodeList![section]
                for node in nodeSection {
                    node.size = .zero
                    node.markDirty()
                }
            }
            return
        }
        
        if section >= dataList?.count ?? 0 {
            return
        }
    
        let itemSection = dataList![section]
        if itemSection.count > 0 {
            for row in 0..<itemSection.count {
                let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
                self.nodeCache.removeObject(forKey: cacheKey)
            }
        }
    }
    
    func removeCache(_ row: Int, at section: Int) {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                let node = nodeList![section][row]
                node.size = .zero
                node.markDirty()
            }
            return
        }
        
        let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
        self.nodeCache.removeObject(forKey: cacheKey)
    }
    
    func deleteRow(_ row: Int, at section: Int) {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                nodeList![section].remove(at: row)
            }
            return
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return
        }
        
        removeCache(row, at: section)
        dataList![section].remove(at: row)
    }
    
    func moveRow(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if nodeList != nil {
            if sourceIndexPath.section < nodeList!.count
                && sourceIndexPath.row < nodeList![sourceIndexPath.section].count
                && destinationIndexPath.section < nodeList!.count {
                let itemToMove = nodeList![sourceIndexPath.section][sourceIndexPath.row]
                nodeList![sourceIndexPath.section].remove(at: sourceIndexPath.row)
                nodeList![destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
            }
            return
        }
        
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
