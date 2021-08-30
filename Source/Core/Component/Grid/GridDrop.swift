//
//  GridDrop.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/15.
//

import Foundation
extension Grid{
    /// ells your delegate to incorporate the drop data into the collection view.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func performDropWith(_ action:@escaping (UICollectionViewDropCoordinator) -> Void) -> Self{
        let sel = #selector(gridNode?.collectionView(_:performDropWith:))
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
    
    /// Asks your delegate whether the collection view can accept a drop with the specified type of data.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func canHandle(_ action:@escaping (UIDropSession) -> Bool) -> Self{
        let sel = #selector(gridNode?.collectionView(_:canHandle:))
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

    /// Notifies you when dragged content enters the collection view’s bounds rectangle.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidEnter(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(gridNode?.collectionView(_:dropSessionDidEnter:))
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

    /// Tells your delegate that the position of the dragged data over the collection view changed.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidUpdate(_ action:@escaping (UIDropSession,IndexPath) -> UICollectionViewDropProposal) -> Self{
        let sel = #selector(gridNode?.collectionView(_:dropSessionDidUpdate:withDestinationIndexPath:))
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

    /// Notifies you when dragged content exits the table view’s bounds rectangle.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidExit(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(gridNode?.collectionView(_:dropSessionDidExit:))
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

    
    /// Notifies you when the drag operation ends.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dropSessionDidEnd(_ action:@escaping (UIDropSession) -> Void) -> Self{
        let sel = #selector(gridNode?.collectionView(_:dropSessionDidEnd:))
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

    /// Returns custom information about how to display the item at the specified location during the drop.
    /// - Parameter action:
    /// - Returns: Self
    func dropPreviewParametersForItemAt(_ action:@escaping (IndexPath) -> UIDragPreviewParameters?) -> Self{
        let sel = #selector(gridNode?.collectionView(_:dropPreviewParametersForItemAt:))
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
