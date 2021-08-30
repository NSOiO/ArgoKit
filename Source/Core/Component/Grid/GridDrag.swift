//
//  GridDrag.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/15.
//

import Foundation
extension Grid{
    
    /// Provides the initial set of items (if any) to drag.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func itemsForBeginning(_ action:@escaping (UIDragSession,IndexPath) -> [UIDragItem]) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:itemsForBeginning:at:))
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
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:itemsForAddingTo:at:point:))
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

    /// Returns custom information about how to display the item at the specified location during the drag.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    
    func dragPreviewParametersForItemAt(_ action:@escaping (IndexPath)->UIDragPreviewParameters?) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:dragPreviewParametersForItemAt:))
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

    /// Notifies you that a drag session is about to begin for the collection view.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionWillBegin(_ action:@escaping (UIDragSession)->Void) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:dragSessionWillBegin:))
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

    
    /// Notifies you that a drag session ended for the collection view.
    /// - Parameter action:
    /// - Returns: descriptionSelf
    @discardableResult
    
    func dragSessionDidEnd(_ action:@escaping (UIDragSession)->Void) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:dragSessionDidEnd:))
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

    /// Controls whether move operations (see UICollectionViewDropProposal.operation) are allowed for the drag session. If not implemented this will default to YES.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    func dragSessionAllowsMoveOperation(_ action:@escaping (UIDragSession)->Bool) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:dragSessionAllowsMoveOperation:))
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

    
    
    /// Controls whether the drag session is restricted to the source application. If YES the current drag session will not be permitted to drop into another application.If not implemented this will default to NO.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    
    func dragSessionIsRestrictedToDraggingApplication(_ action:@escaping (UIDragSession)->Bool) -> Self{
        gridNode?.dragInteractionEnabled = true
        let sel = #selector(gridNode?.collectionView(_:dragSessionIsRestrictedToDraggingApplication:))
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
}
