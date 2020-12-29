//
//  GridDataOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
//MARK: Reload
extension Grid {
    
    /// Reloads all of the data for the grid.
    /// - Returns: Self
    @discardableResult
    public func reloadData() -> Self {
        gridNode?.reloadData()
        return self
    }
    
    /// Reloads the data in the specified sections of the grid.
    /// - Parameter sections: The indexes of the sections to reload.
    /// - Returns: Self
    @discardableResult
    public func reloadSections(sections:IndexSet) -> Self {
        gridNode?.reloadSections(sections)
        return self
    }
    
    /// Inserts new sections at the specified indexes.
    /// - Parameter sections: An index set containing the indexes of the sections you want to insert. This parameter must not be nil.
    /// - Returns: Self
    @discardableResult
    func insertSections(_ sections: IndexSet) -> Self {
        gridNode?.insertSections(sections)
        return self
    }
    
    /// Deletes the sections at the specified indexes.
    /// - Parameter sections: The indexes of the sections you want to delete. This parameter must not be nil.
    /// - Returns: Self
    @discardableResult
    func deleteSections(_ sections: IndexSet) -> Self {
        gridNode?.deleteSections(sections)
        return self
    }
    
    /// Moves a section from one location to another in the grid.
    /// - Parameters:
    ///   - section: The index of the section you want to move.
    ///   - newSection: The index in the grid that is the destination of the move for the section. The existing section at that location moves up or down to an adjoining index position to make room for it.
    /// - Returns: Self
    @discardableResult
    func moveSection(_ section: Int, toSection newSection: Int) -> Self {
        gridNode?.moveSection(section,toSection: newSection)
        return self
    }
    
    /// Reloads just the items at the specified index paths.
    /// - Parameter indexPaths: An array of IndexPath objects identifying the items you want to update.
    /// - Returns: Self
    @discardableResult
    public func reloadItems(at indexPaths: [IndexPath]) -> Self {
        gridNode?.reloadItems(at: indexPaths)
        return self
    }
    
    /// Inserts new items at the specified index paths.
    /// - Parameter indexPaths: An array of IndexPath objects, each of which contains a section index and item index at which to insert a new cell. This parameter must not be nil.
    /// - Returns: Self
    @discardableResult
    public func insertItems(at indexPaths: [IndexPath]) -> Self {
        gridNode?.insertItems(at: indexPaths)
        return self
    }
    
    /// Deletes the items at the specified index paths.
    /// - Parameter indexPaths: An array of IndexPath objects, each of which contains a section index and item index for the item you want to delete from the grid. This parameter must not be nil.
    /// - Returns: Self
    @discardableResult
    func deleteItems(at indexPaths: [IndexPath]) -> Self {
        gridNode?.deleteItems(at:indexPaths)
        return self
    }
    
    /// Moves an item from one location to another in the grid.
    /// - Parameters:
    ///   - indexPath: The index path of the item you want to move. This parameter must not be nil.
    ///   - newIndexPath: The index path of the item’s new location. This parameter must not be nil.
    /// - Returns: Self
    @discardableResult
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) -> Self {
        gridNode?.moveItem(at:indexPath,to: newIndexPath)
        return self
    }
}
