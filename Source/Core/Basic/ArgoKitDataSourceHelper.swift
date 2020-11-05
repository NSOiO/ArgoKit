//
//  ArgoKitDataSourceNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitDataSourceHelper: NSObject {
  
    private var nodeCahe: NSCache<NSString, ArgoKitNode>?
    
    public var nodeList: [[ArgoKitNode]]?
    
    public var dataList: [[Any]]? {
        willSet {
            self.nodeCahe = NSCache()
            self.nodeCahe?.name = "com.\(type(of: self).description())Cache"
        }
    }
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
    
    open func nodeForRowAtSection(_ row: Int, at section: Int) -> ArgoKitNode? {
        
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
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        if let node = self.nodeCahe?.object(forKey: cacheKey) {
            return node
        } else if let view = self.buildNodeFunc?(self.dataList![section][row]) {
            if let node = view.type.viewNode() {
                self.nodeCahe?.setObject(node, forKey: cacheKey)
                return node
            }
        }
        return nil
    }
}

extension ArgoKitDataSourceHelper {
    
    func removeAllCache() {
        
        self.nodeCahe?.removeAllObjects()
    }
    
    func removeCacheForRowAtSection(_ row: Int, at section: Int) {
        
        let cacheKey = NSString(format: "cache_%d_%d", section, row)
        self.nodeCahe?.removeObject(forKey: cacheKey)
    }
}
