//
//  ListRowAction.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/17.
//

import Foundation

@available(iOS, introduced: 8.0, deprecated: 13.0, message: "Use ListContextualAction and related APIs instead.")
public class ListRowAction: UITableViewRowAction {
    
    @discardableResult
    public func title(_ value: String?) -> Self {
        title = value
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        backgroundColor = value
        return self
    }
    
    @discardableResult
    public func backgroundEffect(_ value: UIVisualEffect?) -> Self {
        backgroundEffect = value
        return self
    }
}

@available(iOS 11.0, *)
public class ListContextualAction : UIContextualAction {

    @discardableResult
    public func title(_ value: String?) -> Self {
        title = value
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        backgroundColor = value
        return self
    }
    
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        image = value
        return self
    }
}

@available(iOS 11.0, *)
public class  ListSwipeActionsConfiguration: UISwipeActionsConfiguration {
    
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


