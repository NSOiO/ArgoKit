//
//  ListReload.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/24.
//

import Foundation

extension List {
    
    /// Reloads the rows and sections of the list.
    /// - Returns: Self
    @discardableResult
    public func reloadData() -> Self {
        tableNode.reloadData()
        return self
    }
    
    /// Inserts one or more sections in the list, with an option to animate the insertion.
    /// - Parameters:
    ///   - sections: An index set that specifies the sections to insert in the list. If a section already exists at the specified index location, it is moved down one index location.
    ///   - animation: A constant that indicates how the insertion is to be animated, for example, fade in or slide in from the left. See UITableView.RowAnimation for descriptions of these constants.
    /// - Returns: Self
    @discardableResult
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        tableNode.insertSections(sections,with: animation)
        return self
    }
    
    /// Deletes one or more sections in the list, with an option to animate the deletion.
    /// - Parameters:
    ///   - sections: An index set that specifies the sections to delete from the list. If a section exists after the specified index location, it is moved up one index location.
    ///   - animation: A constant that either specifies the kind of animation to perform when deleting the section or requests no animation. See UITableView.RowAnimation for descriptions of the constants.
    /// - Returns: Self
    @discardableResult
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        tableNode.deleteSections(sections,with: animation)
        return self
    }
    
    /// Reloads the specified sections using a given animation effect.
    /// - Parameters:
    ///   - sections: An index set identifying the sections to reload.
    ///   - animation: A constant that indicates how the reloading is to be animated, for example, fade out or slide out from the bottom. See UITableView.RowAnimation for descriptions of these constants.
    /// - Returns: Self
    @discardableResult
    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        tableNode.reloadSections(sections,with: animation)
        return self
    }
    
    /// Moves a section to a new location in the list.
    /// - Parameters:
    ///   - section: The index of the section to move.
    ///   - newSection: The index in the list that is the destination of the move for the section. The existing section at that location slides up or down to an adjoining index position to make room for it.
    /// - Returns: Self
    @discardableResult
    public func moveSection(_ section: Int, toSection newSection: Int) -> Self {
        tableNode.moveSection(section,toSection: newSection)
        return self
    }

    /// Inserts rows in the list at the locations identified by an array of index paths, with an option to animate the insertion.
    /// - Parameters:
    ///   - indexPaths: An array of index path objects, each representing a row index and section index that together identify a row in the list.
    ///   - animation: A constant that either specifies the kind of animation to perform when inserting the cell or requests no animation. See UITableView.RowAnimation for descriptions of the constants.
    /// - Returns: Self
    @discardableResult
    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        tableNode.insertRows(at:indexPaths,with: animation)
        return self
    }
    
    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion.
    /// - Parameters:
    ///   - indexPaths: An array of IndexPath objects identifying the rows to delete.
    ///   - animation: A constant that indicates how the deletion is to be animated, for example, fade out or slide out from the bottom. See UITableView.RowAnimation for descriptions of these constants.
    /// - Returns: Self
    @discardableResult
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        tableNode.deleteRows(at:indexPaths,with: animation)
        return self
    }
    
    /// Reloads the specified rows using a given animation effect.
    /// - Parameters:
    ///   - indexPaths: An array of IndexPath objects identifying the rows to reload.
    ///   - animation: A constant that indicates how the reloading is to be animated, for example, fade out or slide out from the bottom. See UITableView.RowAnimation for descriptions of these constants.
    /// - Returns: Self
    @discardableResult
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        tableNode.reloadRows(at:indexPaths,with: animation)
        return self
    }
    
    /// Moves the row at a specified location to a destination location.
    /// - Parameters:
    ///   - indexPath: An index path identifying the row to move.
    ///   - newIndexPath: An index path identifying the row that is the destination of the row at indexPath. The existing row at that location slides up or down to an adjoining index position to make room for it.
    /// - Returns: Self
    @discardableResult
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) -> Self {
        tableNode.moveRow(at:indexPath,to: newIndexPath)
        return self
    }
}
