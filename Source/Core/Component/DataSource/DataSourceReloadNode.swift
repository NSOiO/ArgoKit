//
//  DataSourceReloadNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/25.
//

import Foundation

public protocol DataSourceReloadNode: class {
    
    func reloadData()
    
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)

    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)

    func moveSection(_ section: Int, toSection newSection: Int)
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)

    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation)
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
    
    func reloadComponent(_ component: Int)
    
    func removeNode(_ node:Any?)
    
    func removeAll()
    
    func createNodeFromData(_ data:Any)
}

extension DataSourceReloadNode {
    
    func reloadComponent(_ component: Int) {
        
    }
    
    func createNodeFromData(_ data:Any){
        
    }
    
}

