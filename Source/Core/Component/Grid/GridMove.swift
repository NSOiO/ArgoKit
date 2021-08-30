//
//  GridMove.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation
extension Grid{
    /// Asks your data source object whether the specified item can be moved to another location in the collection view.
    /// - Parameter action: The action that handle the specified item is about to be move in the grid.
    /// - Returns: Self
    @discardableResult
    public func canMoveItem(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:canMoveItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 2,
               let data = paramter.first as? D ,
               let indexPath = paramter.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate for the index path to use when moving an item.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    public func targetIndexPathForMove(_ action: @escaping ( _ targetIndexPathForMoveFromItemAt: IndexPath, _ toProposedIndexPath: IndexPath) -> IndexPath) -> Self {
        let sel = #selector(gridNode?.collectionView(_:targetIndexPathForMoveFromItemAt:toProposedIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 2,
               let targetIndexPath = paramter.first as? IndexPath,
               let toIndexPath = paramter.last as? IndexPath{
                return action(targetIndexPath, toIndexPath)
            }
            return nil
        })
        return self
    }
    
    /// Gives the delegate an opportunity to customize the content offset for layout changes and animated updates
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    public func targetContentOffsetForProposedContentOffset(_ action: @escaping ( _ targetContentOffsetForProposedContentOffset: CGPoint) -> CGPoint) -> Self {
        let sel = #selector(gridNode?.collectionView(_:targetContentOffsetForProposedContentOffset:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if let paramter = paramter,
               paramter.count >= 1,
               let point = paramter.first as? CGPoint{
                return action(point)
            }
            return nil
        })
        return self
    }
}
