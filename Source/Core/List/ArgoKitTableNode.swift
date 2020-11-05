//
//  ArgoKitTableNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

private let kCellReuseIdentifier = "ArgoKitListCell"

class ArgoKitTableNode: ArgoKitDataSourceNode, UITableViewDelegate, UITableViewDataSource {
  
    public var tableView: UITableView? {
        
        if let tableView = self.view as? UITableView {
            return tableView
        }
        return nil
    }
    
    public var tableHeaderNode: ArgoKitNode? {
        didSet {
            tableHeaderNode?.applyLayout()
            self.tableView?.tableHeaderView = tableHeaderNode?.view
        }
    }
    
    public var tableFooterNode: ArgoKitNode? {
        didSet {
            tableFooterNode?.applyLayout()
            self.tableView?.tableFooterView = tableFooterNode?.view
        }
    }
    
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
    
    open func reloadData() {
        self.nodeCahe?.removeAllObjects()
        self.tableView?.reloadData()
    }
}

extension ArgoKitTableNode {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! ArgoKitListCell
        if let node = self.nodeForRowAtSection(indexPath.row, at: indexPath.section) {
            cell.linkCellNode(node)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let node = self.nodeForRowAtSection(indexPath.row, at: indexPath.section) {
//            return node.height() // TODO 高度有问题
            return 100
        }
        return 0
    }
}
