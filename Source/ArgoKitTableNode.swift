//
//  ArgoKitTableNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

private let kCellReuseIdentifier = "ArgoKitListCell"

class ArgoKitTableNode: ArgoKitNode, UITableViewDelegate, UITableViewDataSource {
  
    public var tableView: UITableView? {
        
        if let tableView = self.view as? UITableView {
            return tableView
        }
        return nil
    }
    
    public var nodeList: Array<ArgoKitNode>?
    
    public var nodeCahe: NSCache<NSString, ArgoKitNode>?
    public var dataList: [Any]? {
        willSet {
            self.nodeCahe = NSCache()
            self.nodeCahe?.name = "com.argo.tableNodeCache"
            self.nodeCahe?.countLimit = 20
        }
    }
    public var buildNodeFunc: ((Any)->View)?
    
    override init(view: UIView) {
        super.init(view: view)
        if let tableView = view as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ArgoKitListCell.self, forCellReuseIdentifier: kCellReuseIdentifier)
        }
    }
}

extension ArgoKitTableNode {
    
    func numberOfSection() -> Int {
        
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if dataList != nil {
            return dataList?.count ?? 0
        }
        return nodeList?.count ?? 0
    }
    
    func nodeForRowAtIndexPath(indexPath: IndexPath) -> ArgoKitNode? {
        
        if indexPath.row < self.nodeList?.count ?? 0 {
            return self.nodeList![indexPath.row]
        }
        
        if indexPath.row >= self.dataList?.count ?? 0 {
            return nil
        }
        
        let cacheKey = NSString(format: "cache_%d_%d", indexPath.section, indexPath.row)
        if let node = self.nodeCahe?.object(forKey: cacheKey) {
            return node
        } else if let view = self.buildNodeFunc?(self.dataList![indexPath.row]) {
            if let node = view.type.viewNode() {
                self.nodeCahe?.setObject(node, forKey: cacheKey)
                return node
            }
        }
        return nil
    }
}

extension ArgoKitTableNode {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! ArgoKitListCell
        if let node = self.nodeForRowAtIndexPath(indexPath: indexPath) {
            cell.linkCellNode(node)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let node = nodeList?[indexPath.row] {
//            return node.size.height // 缺少高度
        }
        return 100
    }
}
