//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper: NSObject {
    
    lazy var reuseIdCache: NSCache<NSString, NSString> = { () -> NSCache<NSString, NSString> in
        let cahe = NSCache<NSString, NSString>()
        cahe.name = "com.\(type(of: self).description()).reuseId.cache"
        return cahe
    }()
  
    lazy var nodeCache: NSCache<NSString, ArgoKitNode> = { () -> NSCache<NSString, ArgoKitNode> in
        let cahe = NSCache<NSString, ArgoKitNode>()
        cahe.name = "com.\(type(of: self).description()).node.cache"
        return cahe
    }()

    lazy var cellHeightCache: NSCache<NSString, NSNumber> = { () -> NSCache<NSString, NSNumber> in
        let cahe = NSCache<NSString, NSNumber>()
        cahe.name = "com.\(type(of: self).description()).cellHeight.cache"
        return cahe
    }()
    
    lazy var registedReuseIdSet = NSMutableSet()
    
    public var nodeList: [[ArgoKitNode]]?
    
    public var dataList: [[ArgoKitModelProtocol]]?
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
                let node = nodeList![section][row]
                return String(ObjectIdentifier(node).hashValue)
            }
            return "defualt"
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return "defualt"
        }
        
        let node = self.dataList![section][row]
        return String("\(node)".hashValue)
    }
    
    open func reuseIdForRow(_ row: Int, at section: Int) -> String? {
        
        let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
        if let resuseId = self.reuseIdCache.object(forKey: cacheKey) {
            return String(resuseId)
        } else if let node = self.nodeForRow(row, at: section) {
            let resuseId = node.hierarchyKey()
            self.reuseIdCache.setObject(resuseId as NSString, forKey: cacheKey)
            return resuseId
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
    
    open func rowHeight(_ row: Int, at section: Int, maxWidth: CGFloat) -> CGFloat {
        
        let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
        if let height = self.cellHeightCache.object(forKey: cacheKey) {
            return CGFloat(truncating: height)
        } else if let node = self.nodeForRow(row, at: section) {
            node.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
            let height = node.size.height
            self.cellHeightCache.setObject(NSNumber(value: height.native), forKey: cacheKey)
            return height
        }
        return 0.0
    }
}

extension ArgoKitDataSourceHelper {
    
    func removeAllCache() {
        
        self.nodeCache.removeAllObjects()
        self.reuseIdCache.removeAllObjects()
        self.cellHeightCache.removeAllObjects()
    }
    
    func removeCache(_ row: Int, at section: Int) {
        
        let cacheKey = self.cacheKeyForRow(row, at: section) as NSString
        self.nodeCache.removeObject(forKey: cacheKey)
        self.reuseIdCache.removeObject(forKey: cacheKey)
        self.cellHeightCache.removeObject(forKey: cacheKey)
    }
    
    func deleteRow(_ row: Int, at section: Int) {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                removeCache(row, at: section)
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
