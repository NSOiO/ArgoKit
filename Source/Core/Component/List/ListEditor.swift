//
//  ListEditor.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation
extension List{
    /// A Boolean value that determines whether the table view is in editing mode.
    /// - Parameters:
    ///   - editing: true to enter editing mode; false to leave it. The default value is false.
    /// - Returns: Self
    @discardableResult
    public func setEditing(_ editing:@escaping @autoclosure () -> Bool) -> Self {
        return self.bindCallback({ [tabelView = self.nodeView() as? UITableView]  in
            tabelView?.isEditing = editing()
        }, forKey: #function)
    }
    
    /// A Boolean value that determines whether the table view is in editing mode.
    /// - Returns: default is NO
    public func isEditing() -> Bool {
        if let tabelView = self.nodeView() as? UITableView{
            return tabelView.isEditing
        }
        return false
    }
    
    /// Toggles the list into and out of editing mode.
    /// - Parameters:
    ///   - editing: true to enter editing mode; false to leave it. The default value is false.
    ///   - animated: true to animate the transition to editing mode; false to make the transition immediate.
    /// - Returns: Self
    @discardableResult
    public func setEditing(_ editing:@escaping @autoclosure () -> Bool, animated: @escaping @autoclosure () ->Bool) -> Self {
        return self.bindCallback({ [tabelView = self.nodeView() as? UITableView]  in
            tabelView?.setEditing(editing(), animated: animated())
        }, forKey: #function)
    }
    
    /// Sets a Boolean value that determines whether users can select cells while the list is in editing mode.
    /// - Parameter value: A Boolean value that determines whether users can select cells while the list is in editing mode.
    /// - Returns: Self
    @discardableResult
    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelectionDuringEditing),value)
        return self
    }
    
    /// Gets a Boolean value that determines whether users can select cells while the list is in editing mode.
    /// - Returns: default is NO.
    public func allowsSelectionDuringEditing() -> Bool {
        if let tabelView = self.nodeView() as? UITableView{
            return tabelView.allowsSelectionDuringEditing
        }
        return false
    }
    
    /// Sets a Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Parameter value: A Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Returns: Self
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    /// Gets a Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Returns: default is NO.
    public func allowsMultipleSelectionDuringEditing() -> Bool {
        if let tabelView = self.nodeView() as? UITableView{
            return tabelView.allowsMultipleSelectionDuringEditing
        }
        return false
    }
}
