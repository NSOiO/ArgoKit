//
//  ListRowAction.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

/// A single action to present when the user swipes horizontally in a list row.
@available(iOS, introduced: 8.0, deprecated: 13.0, message: "Use ListContextualAction and related APIs instead.")
public class ListRowAction: UITableViewRowAction {
    
    /// Sets the title of the action button.
    /// - Parameter value: The title of the action button.
    /// - Returns: Self
    @discardableResult
    public func title(_ value: String?) -> Self {
        title = value
        return self
    }
    
    /// Sets the background color of the action button.
    /// - Parameter value: The background color of the action button.
    /// - Returns: Self
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        backgroundColor = value
        return self
    }
    
    /// Sets the visual effect to apply to the button.
    /// - Parameter value: The visual effect to apply to the button.
    /// - Returns: Self
    @discardableResult
    public func backgroundEffect(_ value: UIVisualEffect?) -> Self {
        backgroundEffect = value
        return self
    }
}

/// An action to display when the user swipes a list row.
@available(iOS 11.0, *)
public class ListContextualAction : UIContextualAction {
    
    /// Sets the title displayed on the action button.
    /// - Parameter value: The title displayed on the action button.
    /// - Returns: Self
    @discardableResult
    public func title(_ value: String?) -> Self {
        title = value
        return self
    }
    
    /// Sets the background color of the action button.
    /// - Parameter value: The background color of the action button.
    /// - Returns: Self
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        backgroundColor = value
        return self
    }
    
    /// Sets the image to display in the action button.
    /// - Parameter value: The image to display in the action button.
    /// - Returns: Self
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        image = value
        return self
    }
}

/// The set of actions to perform when swiping on rows of a list.
@available(iOS 11.0, *)
public class  ListSwipeActionsConfiguration: UISwipeActionsConfiguration {
    
    /// Sets a Boolean value indicating whether a full swipe automatically performs the first action.
    /// - Parameter value: A Boolean value indicating whether a full swipe automatically performs the first action.
    /// - Returns: Self
    @discardableResult
    public func performsFirstActionWithFullSwipe(_ value: Bool) -> Self {
        performsFirstActionWithFullSwipe = value
        return self
    }
}

@available(iOS 11.0, *)
public extension Array where Element == ListContextualAction {
    
    func swipeActionsConfiguration() -> ListSwipeActionsConfiguration {
        return ListSwipeActionsConfiguration(actions: self)
    }
}


