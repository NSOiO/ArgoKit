//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper: NSObject {
    
    lazy var reuseIdCahe: NSCache<NSString, NSString> = { () -> NSCache<NSString, NSString> in
        let cahe = NSCache<NSString, NSString>()
        cahe.name = "com.\(type(of: self).description()).reuseId.cache"
        return cahe
    }()
  
    lazy var nodeCahe: NSCache<NSString, NSArray> = { () -> NSCache<NSString, NSArray> in
        let cahe = NSCache<NSString, NSArray>()
        cahe.name = "com.\(type(of: self).description()).node.cache"
        return cahe
    }()

    lazy var cellHeightCahe: NSCache<NSString, NSNumber> = { () -> NSCache<NSString, NSNumber> in
        let cahe = NSCache<NSString, NSNumber>()
        cahe.name = "com.\(type(of: self).description()).cellHeight.cache"
        return cahe
    }()
    
    lazy var registedReuseIdSet = NSMutableSet()
    lazy var layoutNode = ArgoKitNode(viewClass: UIView.self)
    
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
    
    open func numberOfRowsInSection(section: Int) -> Int {
        
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
    
    open func reuseIdForRowAtSection(_ row: Int, at section: Int) -> String? {
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        if let resuseId = self.reuseIdCahe.object(forKey: cacheKey) {
            return String(resuseId)
        } else if let nodes = self.nodesForRowAtSection(row, at: section) {
            var resuseId: String = String()
            for node in nodes {
                resuseId += node.hierarchyKey()
            }
            self.reuseIdCahe.setObject(resuseId as NSString, forKey: cacheKey)
            return resuseId
        }
        return nil
    }
    
    open func nodesForRowAtSection(_ row: Int, at section: Int) -> [ArgoKitNode]? {
        
        if nodeList != nil {
            if section < nodeList!.count
                && row < nodeList![section].count {
                return [nodeList![section][row]]
            }
            return nil
        }
        
        if section >= dataList?.count ?? 0
            || row >= dataList?[section].count ?? 0 {
            return nil
        }
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        if let nodes = self.nodeCahe.object(forKey: cacheKey) {
            return nodes as? [ArgoKitNode]
        } else if let view = self.buildNodeFunc?(self.dataList![section][row]) {
            if let nodes = view.type.viewNodes() {
                self.nodeCahe.setObject(nodes as NSArray, forKey: cacheKey)
                return nodes
            }
        }
        return nil
    }
    
    open func heightForRowAtSection(_ row: Int, at section: Int, maxWidth: CGFloat) -> CGFloat {
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        if let height = self.cellHeightCahe.object(forKey: cacheKey) {
            return CGFloat(truncating: height)
        } else if let nodes = self.nodesForRowAtSection(row, at: section) {
            self.layoutNode.width(point: maxWidth)
            self.layoutNode.addChildNodes(nodes)
            self.layoutNode.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
            let height = self.layoutNode.size.height
            self.layoutNode.removeAllChildNodes()
            self.cellHeightCahe.setObject(NSNumber(value: height.native), forKey: cacheKey)
            return height
        }
        return 0.0
    }
}

extension ArgoKitDataSourceHelper {
    
    func removeAllCache() {
        
        self.nodeCahe.removeAllObjects()
        self.reuseIdCahe.removeAllObjects()
        self.cellHeightCahe.removeAllObjects()
    }
    
    func removeCacheForRowAtSection(_ row: Int, at section: Int) {
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        self.nodeCahe.removeObject(forKey: cacheKey)
        self.reuseIdCahe.removeObject(forKey: cacheKey)
        self.cellHeightCahe.removeObject(forKey: cacheKey)
    }
}
