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
}

extension DataSourceReloadNode {
    
    func reloadComponent(_ component: Int) {
        
    }
}

//extension DataSourceReloadNode{
//        public func reloadData() ->Self{
//            return self
//        }
//        public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//        public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//        public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//        public func moveSection(_ section: Int, toSection newSection: Int) ->Self{
//            return self
//        }
//        public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//    
//        public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//        public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
//            return self
//        }
//        public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) ->Self{
//            return self
//        }
//}
