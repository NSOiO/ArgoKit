//
//  ListAppearance.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation

extension List{
    /// Sets the number of table rows at which to display the index list on the right edge of the table.
    /// - Parameter value: The number of table rows at which to display the index list on the right edge of the table.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexMinimumDisplayRowCount),value)
        return self
    }
    
    /// Gets the number of table rows at which to display the index list on the right edge of the table.
    /// - Returns: Int
    public func sectionIndexMinimumDisplayRowCount() -> Int{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.sectionIndexMinimumDisplayRowCount
        }
        return 0
    }
    
    /// Sets the color to use for the list’s index text.
    /// - Parameter value: The color to use for the list’s index text.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexColor),value)
        return self
    }
    
    /// Gets the color to use for the list’s index text.
    /// - Returns: UIColor
    @discardableResult
    public func sectionIndexColor() -> UIColor? {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.sectionIndexColor
        }
        return nil
    }
    
    /// Sets the color to use for the background of the list’s section index.
    /// - Parameter value: The color to use for the background of the list’s section index.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexBackgroundColor),value)
        return self
    }
    
    /// Gets the color to use for the background of the list’s section index.
    /// - Returns: UIColor
    @discardableResult
    public func sectionIndexBackgroundColor() -> UIColor? {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.sectionIndexBackgroundColor
        }
        return nil
    }
    
    /// Sets the color to use for the list’s index background area.
    /// - Parameter value: The color to use for the list’s index background area.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexTrackingBackgroundColor),value)
        return self
    }
    
    /// Gets tthe color to use for the list’s index background area.
    /// - Returns: UIColor
    @discardableResult
    public func sectionIndexTrackingBackgroundColor() -> UIColor? {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.sectionIndexTrackingBackgroundColor
        }
        return nil
    }
    
    /// Sets the style for table cells used as separators.
    /// - Parameter value: The style for table cells used as separators.
    /// - Returns: Self
    @discardableResult
    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        addAttribute(#selector(setter:UITableView.separatorStyle),value.rawValue)
        return self
    }
    
    /// Gets the style for table cells used as separators.
    /// - Returns: UITableViewCell.SeparatorStyle
    @discardableResult
    public func separatorStyle() -> UITableViewCell.SeparatorStyle {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.separatorStyle
        }
        return UITableViewCell.SeparatorStyle.none
    }
    
    /// Sets the color of separator rows in the list.
    /// - Parameter value: The color of separator rows in the list.
    /// - Returns: Self
    @discardableResult
    public func separatorColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorColor),value)
        return self
    }
    
    /// Gets the color of separator rows in the list.
    /// - Returns: UIColor
    @discardableResult
    public func separatorColor() -> UIColor? {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.separatorColor
        }
        return nil
    }
    
    /// Sets the effect applied to table separators.
    /// - Parameter value: The effect applied to table separators.
    /// - Returns: Self
    @available(iOS 8.0, *)
    @discardableResult
    public func separatorEffect(_ value: UIVisualEffect?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorEffect),value)
        return self
    }
    
    /// Gets the effect applied to table separators.
    /// - Returns: UIVisualEffect
    @available(iOS 8.0, *)
    @discardableResult
    public func separatorEffect() -> UIVisualEffect? {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.separatorEffect
        }
        return nil
    }
    
    /// Sets a Boolean value that indicates whether the cell margins are derived from the width of the readable content guide.
    /// - Parameter value: A Boolean value that indicates whether the cell margins are derived from the width of the readable content guide.
    /// - Returns: Self
    @available(iOS 9.0, *)
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.cellLayoutMarginsFollowReadableWidth),value)
        return self
    }
    
    /// Gets a Boolean value that indicates whether the cell margins are derived from the width of the readable content guide.
    /// - Returns: Bool
    @available(iOS 9.0, *)
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth() -> Bool {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.cellLayoutMarginsFollowReadableWidth
        }
        return false
    }
    
    /// Sets a Boolean value that indicates whether the list adjusts the content views of its cells, headers, and footers to fit within the safe area.
    /// - Parameter value: A Boolean value that indicates whether the list adjusts the content views of its cells, headers, and footers to fit within the safe area.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.insetsContentViewsToSafeArea),value)
        return self
    }
    
    /// Gets a Boolean value that indicates whether the list adjusts the content views of its cells, headers, and footers to fit within the safe area.
    /// - Returns: Bool
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea() -> Bool {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.insetsContentViewsToSafeArea
        }
        return true
    }
    
    /// The view that is displayed above the table's content.
    /// - Returns: UIView
    public func tableHeaderView() -> UIView?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.tableHeaderView
        }
        return nil
    }
    
    
    /// The view that is displayed below the table's content.
    /// - Returns: UIView
    public func tableFooterView() -> UIView?{
        if let tableView = self.nodeView() as? UITableView{
            return tableView.tableFooterView
        }
        return nil
    }
}
