//
//  ListModifier.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/24.
//

import Foundation

extension List {
    
    /// Sets the style of selected cells.
    /// - Parameter value: The style of selected cells.
    /// - Returns: Self
    @discardableResult
    public func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        tableNode.selectionStyle = value
        return self
    }
    
    /// Sets the default inset of cell separators.
    /// - Parameter value: The default inset of cell separators.
    /// - Returns: Self
    @discardableResult
    public func separatorInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInset),value)
        return self
    }
    
    /// Sets an indicator of how the separator inset value should be interpreted.
    /// - Parameter value: An indicator of how the separator inset value should be interpreted.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func separatorInsetReference(_ value: UITableView.SeparatorInsetReference) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInsetReference),value.rawValue)
        return self
    }
    
    /// Scrolls through the list until a row identified by index path is at a particular location on the screen.
    /// - Parameters:
    ///   - indexPath: An index path that identifies a row in the list by its row index and its section index. NSNotFound is a valid row index for scrolling to a section with zero rows.
    ///   - scrollPosition: A constant that identifies a relative position in the list (top, middle, bottom) for row when scrolling concludes. See UITableView.ScrollPosition for descriptions of valid constants.
    ///   - animated: true if you want to animate the change in position; false if it should be immediate.
    /// - Returns: Self
    @discardableResult
    public func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToRow(at:at:animated:)),indexPath, scrollPosition.rawValue, animated)
        return self
    }
    
    /// Scrolls the list so that the selected row nearest to a specified position in the list is at that position.
    /// - Parameters:
    ///   - scrollPosition: A constant that identifies a relative position in the list (top, middle, bottom) for the row when scrolling concludes. See UITableView.ScrollPosition for a descriptions of valid constants.
    ///   - animated: true if you want to animate the change in position; false if it should be immediate.
    /// - Returns: Self
    @discardableResult
    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToNearestSelectedRow(at:animated:)), scrollPosition.rawValue, animated)
        return self
    }
    
    /// Toggles the list into and out of editing mode.
    /// - Parameters:
    ///   - editing: true to enter editing mode; false to leave it. The default value is false.
    ///   - animated: true to animate the transition to editing mode; false to make the transition immediate.
    /// - Returns: Self
    @discardableResult
    public func setEditing(_ editing: Bool, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.setEditing(_:animated:)), editing, animated)
        return self
    }
    
    /// Sets a Boolean value that determines whether users can select a row.
    /// - Parameter value: A Boolean value that determines whether users can select a row.
    /// - Returns: Self
    @discardableResult
    public func allowsSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelection),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether users can select cells while the list is in editing mode.
    /// - Parameter value: A Boolean value that determines whether users can select cells while the list is in editing mode.
    /// - Returns: Self
    @discardableResult
    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelectionDuringEditing),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether users can select more than one row outside of editing mode.
    /// - Parameter value: A Boolean value that determines whether users can select more than one row outside of editing mode.
    /// - Returns: Self
    @discardableResult
    public func allowsMultipleSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelection),value)
        return self
    }
    
    /// Sets a Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Parameter value: A Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Returns: Self
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    /// Selects a row in the list identified by index path, optionally scrolling the row to a location in the list.
    /// - Parameters:
    ///   - indexPath: An index path identifying a row in the list.
    ///   - animated: true if you want to animate the selection and any change in position; false if the change should be immediate.
    ///   - scrollPosition: A constant that identifies a relative position in the list (top, middle, bottom) for the row when scrolling concludes. See UITableView.ScrollPosition for descriptions of valid constants.
    /// - Returns: Self
    @discardableResult
    public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> Self {
        addAttribute(#selector(UITableView.selectRow(at:animated:scrollPosition:)), indexPath, animated, scrollPosition.rawValue)
        return self
    }
    
    /// Deselects a given row identified by index path, with an option to animate the deselection.
    /// - Parameters:
    ///   - indexPath: An index path identifying a row in the list.
    ///   - animated: true if you want to animate the deselection, and false if the change should be immediate.
    /// - Returns: Self
    @discardableResult
    public func deselectRow(at indexPath: IndexPath, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.deselectRow(at:animated:)), indexPath, animated)
        return self
    }
    
    /// Sets the number of table rows at which to display the index list on the right edge of the table.
    /// - Parameter value: The number of table rows at which to display the index list on the right edge of the table.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexMinimumDisplayRowCount),value)
        return self
    }
    
    /// Sets the color to use for the list’s index text.
    /// - Parameter value: The color to use for the list’s index text.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexColor),value)
        return self
    }
    
    /// Sets the color to use for the background of the list’s section index.
    /// - Parameter value: The color to use for the background of the list’s section index.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexBackgroundColor),value)
        return self
    }
    
    /// Sets the color to use for the list’s index background area.
    /// - Parameter value: The color to use for the list’s index background area.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexTrackingBackgroundColor),value)
        return self
    }
    
    /// Sets the style for table cells used as separators.
    /// - Parameter value: The style for table cells used as separators.
    /// - Returns: Self
    @discardableResult
    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        addAttribute(#selector(setter:UITableView.separatorStyle),value.rawValue)
        return self
    }
    
    /// Sets the color of separator rows in the list.
    /// - Parameter value: The color of separator rows in the list.
    /// - Returns: Self
    @discardableResult
    public func separatorColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorColor),value)
        return self
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
    
    /// Sets a Boolean value that indicates whether the cell margins are derived from the width of the readable content guide.
    /// - Parameter value: A Boolean value that indicates whether the cell margins are derived from the width of the readable content guide.
    /// - Returns: Self
    @available(iOS 9.0, *)
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.cellLayoutMarginsFollowReadableWidth),value)
        return self
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
    
    /// Sets a Boolean value that indicates whether the list should automatically return the focus to the cell at the last focused index path.
    /// - Parameter value: A Boolean value that indicates whether the list should automatically return the focus to the cell at the last focused index path.
    /// - Returns: Self
    @available(iOS 9.0, *)
    @discardableResult
    public func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.remembersLastFocusedIndexPath),value)
        return self
    }
    
    /// Sets a Boolean value that triggers an automatic selection when focus moves to a cell.
    /// - Parameter value: A Boolean value that triggers an automatic selection when focus moves to a cell.
    /// - Returns: Self
    @available(iOS 14.0, *)
    @discardableResult
    public func selectionFollowsFocus(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.selectionFollowsFocus),value)
        return self
    }
    
    /// Sets A Boolean value indicating whether the list supports drags and drops between apps.
    /// - Parameter value: A Boolean value indicating whether the list supports drags and drops between apps.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.dragInteractionEnabled),value)
        return self
    }
}

extension List {
    
    /// Asks the data source to verify that the given row is editable.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func canEditRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:canEditRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath
               {
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    /// Asks the data source whether a given row can be moved to another location in the list.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func canMoveRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:canMoveRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    /// Sets the titles for the sections of a list.
    /// - Parameter value: The titles for the sections of a list.
    /// - Returns: Self
    @discardableResult
    public func sectionIndexTitles(_ value: [String]?) -> Self {
        tableNode.sectionIndexTitles = value;
        return self
    }
    
    /// Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func commitEditingRow(_ action: @escaping (_ editingStyle: UITableViewCell.EditingStyle, _ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:commit:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3,
                let editingStyle = paramter?[0] as? UITableViewCell.EditingStyle,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath {
                action(editingStyle, data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Tells the data source to move a row at a specific location in the list to another location.
    /// - Parameter action: The action that handle tells the data source to move a row at a specific location in the list to another location.
    /// - Returns: Self
    @discardableResult
    public func moveRow(_ action: @escaping (_ sourceData: D, _ destinationData: D, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:moveRowAt:to:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4,
                let sourceData: D = paramter?[0] as? D,
                let destinationData: D = paramter?[1] as? D,
                let sourceIndexPath: IndexPath = paramter?[2] as? IndexPath,
                let destinationIndexPath: IndexPath = paramter?[3] as? IndexPath{
                action(sourceData, destinationData, sourceIndexPath, destinationIndexPath)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    /// Instructs your prefetch data source object to begin preparing data for the cells at the supplied index paths.
    /// - Parameter action: The action to prefetch data source.
    /// - Returns: Self
    @discardableResult
    public func prefetchRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:prefetchRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let indexPaths = paramter?[0] as? [IndexPath] {
                action(indexPaths)
            }
            return nil
        })
        return self
    }
    
    /// Cancels a previously triggered data prefetch request.
    /// - Parameter action: The action to cancel a previously triggered data prefetch request.
    /// - Returns: Self
    @discardableResult
    public func cancelPrefetchingRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:cancelPrefetchingForRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
                let indexPaths = paramter?[0] as? [IndexPath]
            {
                action(indexPaths)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    /// Sets the action that handle the list is about to draw a cell for a particular row.
    /// - Parameter action: The action that handle the list is about to draw a cell for a particular row.
    /// - Returns: Self
    @discardableResult
    public func cellWillAppear(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willDisplay:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the table is about to display the header view for the specified section.
    /// - Parameter action: The action that handle the table is about to display the header view for the specified section.
    /// - Returns: Self
    @discardableResult
    public func headerWillAppear(_ action: @escaping (_ data: D, _ section: Int) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willDisplayHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let section = paramter?.last as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the table is about to display the footer view for the specified section.
    /// - Parameter action: The action that handle the table is about to display the footer view for the specified section.
    /// - Returns: Self
    @discardableResult
    public func headerDidDisappear(_ action: @escaping (_ data: D, _ section: Int) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willDisplayFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? D,
                let section = paramter?[1] as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified cell was removed from the table.
    /// - Parameter action: The action that handle the specified cell was removed from the table.
    /// - Returns: Self
    @discardableResult
    public func cellDidDisappear(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didEndDisplaying:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified header view was removed from the table.
    /// - Parameter action: The action that handle the specified header view was removed from the table.
    /// - Returns: Self
    @discardableResult
    public func footerWillAppear(_ action: @escaping (_ data: D, _ section: Int) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didEndDisplayingHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? D,
                let section = paramter?[1] as? Int {
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified footer view was removed from the table.
    /// - Parameter action: The action that handle the specified footer view was removed from the table.
    /// - Returns: Self
    @discardableResult
    public func footerDidDisappear(_ action: @escaping (_ data: D, _ section: Int) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didEndDisplayingFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? D,
                let section = paramter?[1] as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate if the specified row should be highlighted.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func shouldHighlightRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    /// Sets the action that handle the specified row was highlighted.
    /// - Parameter action: The action that handle the specified row was highlighted.
    /// - Returns: Self
    @discardableResult
    public func cellDidHighlight(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the highlight was removed from the row at the specified index path.
    /// - Parameter action: The action that handle the highlight was removed from the row at the specified index path.
    /// - Returns: Self
    @discardableResult
    public func cellDidUnhighlight(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didUnhighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    
    /// Sets the action that handle a row is about to be selected.
    /// - Parameter action: The action that handle a row is about to be selected.
    /// - Returns: Self
    @discardableResult
    public func cellWillSelect(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a specified row is about to be deselected.
    /// - Parameter action: The action that handle a specified row is about to be deselected.
    /// - Returns: Self
    @discardableResult
    public func cellWillDeselect(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a row is selected.
    /// - Parameter action: The action that handle a row is selected.
    /// - Returns: Self
    @discardableResult
    public func cellSelected(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func cellDeselected(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate for the editing style of a row at a particular location in a list.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func editingStyle(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:editingStyleForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Changes the default title of the delete-confirmation button.
    /// - Parameter action: The default title of the delete-confirmation button.
    /// - Returns: Self
    @discardableResult
    public func titleForDeleteConfirmationButton(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> String?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate for the actions to display in response to a swipe in the specified row.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS, introduced: 8.0, deprecated: 13.0)
    @discardableResult
    public func editActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> [ListRowAction]?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:editActionsForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the aciton that returns the swipe actions to display on the leading edge of the row.
    /// - Parameter action: The aciton that returns the swipe actions to display on the leading edge of the row.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func leadingSwipeActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the aciton that returns the swipe actions to display on the trailing edge of the row.
    /// - Parameter action: The aciton that returns the swipe actions to display on the trailing edge of the row.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func trailingSwipeActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate whether the background of the specified row should be indented while the list is in editing mode.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func shouldIndentWhileEditingRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldIndentWhileEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the list is about to go into editing mode.
    /// - Parameter action: The action that handle the list is about to go into editing mode.
    /// - Returns: Self
    @discardableResult
    public func willBeginEditingRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willBeginEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the list has left editing mode.
    /// - Parameter action: The action that handle the list has left editing mode.
    /// - Returns: Self
    @discardableResult
    public func didEndEditingRow(_ action: @escaping (_ data: D?, _ indexPath: IndexPath?) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didEndEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            } else {
                action(nil, nil)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate to return a new index path to retarget a proposed move of a row.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func targetIndexPathForMove(_ action: @escaping (_ sourceData: D, _ proposedDestinationData: D, _ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4,
                let sourceData = paramter?[0] as? D,
                let destinationData = paramter?[1] as? D,
                let sourceIndexPath = paramter?[2] as? IndexPath,
                let proposedDestinationIndexPath  = paramter?[3] as? IndexPath{
                return action(sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate to return the level of indentation for a row in a given section.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func indentationLevel(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Int) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:indentationLevelForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate if the editing menu should be shown for a certain row.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func shouldShowMenu(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldShowMenuForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate if the editing menu should omit the Copy or Paste command for a given row.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func canPerformAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:canPerformAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let act = paramter?[0] as? Selector,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4,let sender_ = paramter?[3]{
                    sender = sender_
                }
                return action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle perform a copy or paste operation on the content of a given row.
    /// - Parameter action: The action that handle perform a copy or paste operation on the content of a given row.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func performAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:performAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let act = paramter?[0] as? Selector,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4 ,let sender_ = paramter?[3]{
                    sender = sender_
                }
                action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate whether the cell at the specified index path is itself focusable.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func canFocusRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:canFocusRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate whether the focus update specified by the context is allowed to occur.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func shouldUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldUpdateFocusIn:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let context = paramter?[0] as? UITableViewFocusUpdateContext {
                return action(context)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a focus update specified by the context has just occurred.
    /// - Parameter action: The action that handle a focus update specified by the context has just occurred.
    /// - Returns: Self
    @discardableResult
    public func didUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didUpdateFocusIn:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let context = paramter?[0] as? UITableViewFocusUpdateContext,
                let coordinator = paramter?[1] as? UIFocusAnimationCoordinator{
                action(context, coordinator)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate for the list’s index path for the preferred focused view.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func indexPathForPreferredFocusedView(_ action: @escaping () -> IndexPath?) -> Self {
        let sel = #selector(TableNode<D>.indexPathForPreferredFocusedView(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            return action()
        })
        return self
    }
    
    /// Called to let you fine tune the spring-loading behavior of the rows in a table.
    /// - Parameter action: The aciton that handle fine tune the spring-loading behavior of the rows in a table.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func shouldSpringLoadRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldSpringLoadRowAt:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let data = paramter?[0] as? D,
                let indexPath = paramter?[1] as? IndexPath,
                let context = paramter?[2] as? UISpringLoadedInteractionContext{
                return action(data, indexPath, context)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate whether the user can use a two-finger pan gesture to select multiple items in a list.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func shouldBeginMultipleSelectionInteraction(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the user starts using a two-finger pan gesture to select multiple rows in a list.
    /// - Parameter action: The action that handle the user starts using a two-finger pan gesture to select multiple rows in a list.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func didBeginMultipleSelectionInteraction(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:didBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the user stops using a two-finger pan gesture to select multiple rows in a list.
    /// - Parameter action: The action that handle the user stops using a two-finger pan gesture to select multiple rows in a list.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func didEndMultipleSelectionInteraction(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableViewDidEndMultipleSelectionInteraction(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            action()
            return nil
        })
        return self
    }
    
    /// Sets the aciton that returns a context menu configuration for the row at a point.
    /// - Parameter action: The aciton that returns a context menu configuration for the row at a point.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func contextMenuConfiguration(_ action: @escaping (_ data: D, _ indexPath: IndexPath, _ point: CGPoint) -> UIContextMenuConfiguration?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:contextMenuConfigurationForRowAt:point:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 ,
               let data = paramter?[0] as? D,
               let indexPath = paramter?[1] as? IndexPath,
               let point = paramter?[2] as? CGPoint{
                return action(data, indexPath, point)
            }
            return nil
        })
        return self
    }
    
    /// Sets the aciton that returns a view to override the default preview the list created.
    /// - Parameter action: The aciton that returns a view to override the default preview the list created.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func previewForHighlightingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:previewForHighlightingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration: UIContextMenuConfiguration = paramter?[0] as? UIContextMenuConfiguration{
                return action(configuration)
            }
            return nil
        })
        return self
    }
    
    /// Sets the aciton that returns the destination view when dismissing a context menu.
    /// - Parameter action: The aciton that returns the destination view when dismissing a context menu.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func previewForDismissingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:previewForDismissingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                return action(configuration)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a user triggers a commit by tapping the preview.
    /// - Parameter action: The action that handle a user triggers a commit by tapping the preview.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func willPerformPreviewAction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionCommitAnimating) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willPerformPreviewActionForMenuWith:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let configuration = paramter?[0] as? UIContextMenuConfiguration,
               let animator = paramter?[1] as? UIContextMenuInteractionCommitAnimating{
        
                action(configuration, animator)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a context menu will appear.
    /// - Parameter action: The action that handle a context menu will appear.
    /// - Returns: Self
    @available(iOS 14.0, *)
    @discardableResult
    public func willDisplayContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willDisplayContextMenu:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2,let animator_ = paramter?[1] as? UIContextMenuInteractionAnimating {
                    animator = animator_
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a context menu will disappear.
    /// - Parameter action: The action that handle a context menu will disappear.
    /// - Returns: Self
    @available(iOS 14.0, *)
    @discardableResult
    public func willEndContextMenuInteraction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(TableNode<D>.tableView(_:willEndContextMenuInteraction:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2,let animator_ = paramter?[1] as? UIContextMenuInteractionAnimating {
                    animator = animator_
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }
}
