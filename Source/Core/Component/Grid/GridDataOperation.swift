//
//  GridDataOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
//MARK: Reload
extension Grid {
    
    @discardableResult
    public func reloadData() ->Self {
        gridNode?.reloadData()
        return self
    }
    
    @discardableResult
    public func insertItems(at indexPaths: [IndexPath]) -> Self{
        gridNode?.insertItems(at: indexPaths)
        return self
    }
    
    @discardableResult
    public func reloadItems(at indexPaths: [IndexPath]) -> Self{
        gridNode?.reloadItems(at: indexPaths)
        return self
    }
    
    public func reloadSections(sections:IndexSet) -> Self{
        gridNode?.reloadSections(sections)
        return self
    }
    
    func insertSections(_ sections: IndexSet) -> Self{
        gridNode?.insertSections(sections)
        return self
    }

    func deleteSections(_ sections: IndexSet)-> Self{
        gridNode?.deleteSections(sections)
        return self
    }

    func moveSection(_ section: Int, toSection newSection: Int)-> Self{
        gridNode?.moveSection(section,toSection: newSection)
        return self
    }

    func deleteItems(at indexPaths: [IndexPath])-> Self{
        gridNode?.deleteItems(at:indexPaths)
        return self
    }

    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)-> Self{
        gridNode?.moveItem(at:indexPath,to: newIndexPath)
        return self
    }
    
}
