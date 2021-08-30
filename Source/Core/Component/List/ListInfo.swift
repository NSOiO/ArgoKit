//
//  ListInfo.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/11.
//

import Foundation
extension List{
    /// The list tuples that contain models and cells that are visible in the list.
    /// - Returns: The return value of this function is an array containing tuples that contain viewmodes and cells, each representing a visible viewmode in the list.
    public func visibleModelCells() -> [(D,UITableViewCell)] {
        return self.tableNode.visibleModelCells()
    }
    
    /// The list models that are visible in the list.
    /// - Returns: The return value of this function is an array containing viewmodel objects, each representing a visible viewmode in the list.
    public func visibleModels() -> [D] {
        return self.tableNode.visibleModels()
    }
    
    /// The number of sections in the table view.
    /// UITableView gets the value in this property from its data source and caches it.
    
    /// The number of sections in the table view.
    /// UITableView gets the value in this property from its data source and caches it.
    /// - Returns: The number of sections in the table view.
    public func numberOfSections()->Int{
        if let tableView = self.tableNode.tableView{
            return tableView.numberOfSections
        }
        return 0
    }
    
    /// Returns the number of rows (table cells) in a specified section.
    /// - Parameter section:An index number that identifies a section of the table. Table views in a plain style have a section index of zero.
    /// - Returns: The number of rows in the section.
    public func numberOfRows(inSection section: Int)->Int{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.numberOfRows(inSection: section)
        }
        return 0
    }
    
    /// Returns the drawing area for a specified section of the table view.
    /// - Parameter section: An index number identifying a section of the table view. Plain-style table views always have a section index of zero.
    /// - Returns: A rectangle defining the area in which the table view draws the section.
    public func rect(forSection section: Int)->CGRect{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.rect(forSection: section)
        }
        return CGRect.zero
    }
    
    /// Returns the drawing area for the header of the specified section.
    /// - Parameter section: An index number identifying a section of the table view. Plain-style table views always have a section index of zero.
    /// - Returns: A rectangle defining the area in which the table view draws the section header.
    public func rectForHeader(inSection section: Int)->CGRect{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.rectForHeader(inSection: section)
        }
        return CGRect.zero
    }
    
    
    /// Returns the drawing area for the footer of the specified section.
    /// - Parameter section: An index number identifying a section of the table view. Plain-style table views always have a section index of zero.
    /// - Returns: A rectangle defining the area in which the table view draws the section footer.
    public func rectForFooter(inSection section: Int)->CGRect{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.rectForFooter(inSection: section)
        }
        return CGRect.zero
    }
    
    
    /// Returns the drawing area for a row identified by index path.
    /// - Parameter indexPath: An index path object that identifies a row by its index and its section index.
    /// - Returns: A rectangle defining the area in which the table view draws the row or CGRectZero if indexPath is invalid.
    public func rectForRow(at indexPath: IndexPath)->CGRect{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.rectForRow(at: indexPath)
        }
        return CGRect.zero
    }
    
    /// Returns an index path identifying the row and section at the given point.
    /// - Parameter point: A point in the local coordinate system of the table view (the table view’s bounds).
    /// - Returns: An index path representing the row and section associated with point, or nil if the point is out of the bounds of any row.
    public func indexPathForRow(at point: CGPoint) -> IndexPath?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.indexPathForRow(at: point)
        }
        return nil
    }

    /// Returns an index path representing the row and section of a given table-view cell.
    /// - Parameter cell: A cell object of the table view.
    /// - Returns: An index path representing the row and section of the cell, or nil if the index path is invalid.
    public func indexPath(for cell: UITableViewCell) -> IndexPath?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.indexPath(for: cell)
        }
        return nil
    }

    // returns nil if rect not valid
    
    /// An array of index paths, each representing a row enclosed by a given rectangle.
    /// - Parameter rect: A rectangle defining an area of the table view in local coordinates.
    /// - Returns: An array of NSIndexPath objects each representing a row and section index identifying a row within rect. Returns an empty array if there aren’t any rows to return.
    public func indexPathsForRows(in rect: CGRect) -> [IndexPath]?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.indexPathsForRows(in: rect)
        }
        return nil
    }

    
    /// Returns the table cell at the specified index path.
    /// - Parameter indexPath: The index path locating the row in the table view.
    /// - Returns: An object representing a cell of the table, or nil if the cell is not visible or indexPath is out of range.
    public func cellForRow(at indexPath: IndexPath) -> UITableViewCell?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.cellForRow(at: indexPath)
        }
        return nil
    }
    
    /// Returns the header view associated with the specified section.
    /// - Parameter section: An index number that identifies a section of the table. Table views in a plain style have a section index of zero.
    /// - Returns: The header view associated with the section, or nil if the section does not have a header view.
    @available(iOS 6.0, *)
    public func headerView(forSection section: Int) -> UITableViewHeaderFooterView?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.headerView(forSection: section)
        }
        return nil
    }
    
    /// Returns the footer view associated with the specified section.
    /// - Parameter section: An index number that identifies a section of the table. Table views in a plain style have a section index of zero.
    /// - Returns: The footer view associated with the section, or nil if the section does not have a footer view.
    @available(iOS 6.0, *)
    public func footerView(forSection section: Int) -> UITableViewHeaderFooterView?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.footerView(forSection: section)
        }
        return nil
    }
    
}
