//
//  ListDrag.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation
extension List{
    
    /// Sets A Boolean value indicating whether the list supports drags and drops between apps.
    /// - Parameter value: A Boolean value indicating whether the list supports drags and drops between apps.
    /// - Returns: Self
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        tableNode.dragInteractionEnabled = value
        return self
    }
    
    /// A Boolean value indicating whether rows were lifted from the table view and have not yet been dropped.
    /// - Returns: YES if a drag session is currently active. A drag session begins after rows are "lifted" from the table view.
    @available(iOS 11.0, *)
    public func hasActiveDrag() -> Bool {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.hasActiveDrag
        }
        return false
    }
    
    
    
    /// Provides the initial set of items (if any) to drag.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    
    func itemsForBeginning(_ action:@escaping (UIDragSession,IndexPath) -> [UIDragItem]) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:itemsForBeginning:at:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let count = paramter?.count,
               count >= 2,
               let session = paramter?.first as? UIDragSession,
               let indexPath = paramter?.last as? IndexPath{
                return action(session,indexPath)
            }
           return nil
        })
        return self
    }

    /// Adds the specified items to an existing drag session.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func itemsForAddingTo(_ action:@escaping (UIDragSession, IndexPath,CGPoint) -> [UIDragItem] ) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:itemsForAddingTo:at:point:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 3,
               let session = paramter.first as? UIDragSession,
               let indexPath = paramter[1] as? IndexPath,
               let point = paramter.last as? CGPoint{
                return action(session,indexPath,point)
            }
            return nil
        })
        return self
    }

    /// Returns custom information about how to display the row at the specified location during the drag.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragPreviewParametersForItemAt(_ action:@escaping (IndexPath)->UIDragPreviewParameters?) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:dragPreviewParametersForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let indexPath = paramter.first as? IndexPath{
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    /// Signals the start of a drag operation involving content from the specified table view.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionWillBegin(_ action:@escaping (UIDragSession)->Void) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:dragSessionWillBegin:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDragSession{
               action(session)
            }
            return nil
        })
        return self
    }

    /// Signals the end of a drag operation involving content from the specified table view
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionDidEnd(_ action:@escaping (UIDragSession)->Void) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:dragSessionDidEnd:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDragSession{
               action(session)
            }
            return nil
        })
        return self
    }

    /// Returns a Boolean value indicating whether your app supports a move operation for the dragged content.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionAllowsMoveOperation(_ action:@escaping (UIDragSession)->Bool) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:dragSessionAllowsMoveOperation:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDragSession{
                return action(session)
            }
            return nil
        })
        return self
    }

    /// Returns a Boolean value indicating whether the dragged content must be dropped in the same app.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionIsRestrictedToDraggingApplication(_ action:@escaping (UIDragSession)->Void) -> Self{
        tableNode.dragInteractionEnabled = true
        let sel = #selector(TableNode<D>.tableView(_:dragSessionIsRestrictedToDraggingApplication:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDragSession{
               action(session)
            }
            return nil
        })
        return self
    }
}
