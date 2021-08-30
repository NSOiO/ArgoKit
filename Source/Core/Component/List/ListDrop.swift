//
//  ListDrop.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation
extension  List{
    
    /// A Boolean value indicating whether the table view is currently tracking a drop session.
    /// - Returns: YES if table view is currently tracking a drop session.
    @available(iOS 11.0, *)
    public func hasActiveDrop() -> Bool {
        if let tableView = self.nodeView() as? UITableView{
            return tableView.hasActiveDrop
        }
        return false
    }
    
    /// Incorporates the dropped data into your data structures and updates the table.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func performDropWith(_ action:@escaping (UICollectionViewDropCoordinator) -> Void) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:performDropWith:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let coordinator = paramter.first as? UICollectionViewDropCoordinator{
               action(coordinator)
            }
            return nil
        })
        return self
    }

    
    /// Asks your delegate whether it can accept the specified type of data.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func canHandle(_ action:@escaping (UIDropSession) -> Bool) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:canHandle:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDropSession{
               return action(session)
            }
            return nil
        })
        return self
    }

    /// Called when dragged content enters the table view's bounds rectangle.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidEnter(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:dropSessionDidEnter:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDropSession{
               action(session)
            }
            return nil
        })
        return self
    }

    /// Proposes how to handle a drop at the specified location in the table view.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidUpdate(_ action:@escaping (UIDropSession,IndexPath) -> UICollectionViewDropProposal) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:dropSessionDidUpdate:withDestinationIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 2,
               let session = paramter.first as? UIDropSession,
               let indexPath = paramter.last as? IndexPath{
                return action(session,indexPath)
            }
            return nil
        })
        return self
    }

    /// Called when dragged content exits the table view's bounds rectangle.
    /// - Parameter action:
    /// - Returns: Self
    func dropSessionDidExit(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:dropSessionDidExit:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDropSession{
               action(session)
            }
            return nil
        })
        return self
    }

    /// Called to notify you when the drag operation ends.
    /// - Parameter action:
    /// - Returns: Self
    func dropSessionDidEnd(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:dropSessionDidEnd:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let session = paramter.first as? UIDropSession{
               action(session)
            }
            return nil
        })
        return self
    }

    /// Returns custom information about how to display the row at the specified location during the drop.
    /// - Parameter action:
    /// - Returns: Self
    func dropPreviewParametersForItemAt(_ action:@escaping (IndexPath) -> UIDragPreviewParameters?) -> Self{
        let sel = #selector(TableNode<D>.tableView(_:dropPreviewParametersForRowAt:))
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
}
