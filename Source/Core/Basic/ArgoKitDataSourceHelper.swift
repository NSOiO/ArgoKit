//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper: NSObject {
  
    lazy var nodeCahe: NSCache<NSString, NSArray> = { () -> NSCache<NSString, NSArray> in
        let cahe = NSCache<NSString, NSArray>()
        cahe.name = "com.\(type(of: self).description()).node.cache"
        return cahe
    }()
    
    lazy var reuseIdCahe: NSCache<NSString, NSString> = { () -> NSCache<NSString, NSString> in
        let cahe = NSCache<NSString, NSString>()
        cahe.name = "com.\(type(of: self).description()).reuseId.cache"
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
    
    open func reuseIdForRowAtSection(_ row: Int, at section: Int) -> String? {
        print("row : \(row)")
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        if let resuseId = self.reuseIdCahe.object(forKey: cacheKey) {
            return String( resuseId)
        } else if let nodes = self.nodesForRowAtSection(row, at: section) {
            var resuseId: String = String()
            for node in nodes {
                resuseId += node.hierarchyKey()
            }
            return resuseId
        }
        return nil
    }
}

extension ArgoKitDataSourceHelper {
    
    func removeAllCache() {
        
        self.nodeCahe.removeAllObjects()
        self.reuseIdCahe.removeAllObjects()
    }
    
    func removeCacheForRowAtSection(_ row: Int, at section: Int) {
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        self.nodeCahe.removeObject(forKey: cacheKey)
        self.reuseIdCahe.removeObject(forKey: cacheKey)
    }
}
