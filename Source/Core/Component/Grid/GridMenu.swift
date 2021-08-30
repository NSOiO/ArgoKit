//
//  GridMenu.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/16.
//

import Foundation
extension Grid {
    /// Sets a context menu configuration for the item at a point.
    /// - Parameters:
    ///   - title: The title of the menu action
    ///   - menuActions: Returns a context menu configuration for the item at a point.
    /// - Returns: Self
    @available(iOS 13.0, *)
    public func contextMenuConfiguration(title:String,
                                         menuActions: @escaping (_ data: D, _ indexPath: IndexPath)->[UIAction]?)->Self{
        gridNode?.actionTitle = title
        let sel = #selector(gridNode?.collectionView(_:contextMenuConfigurationForItemAt:point:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath = paramter?[1] as? IndexPath{
               return menuActions(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the destination view when dismissing a context menu.
    /// - Parameter content: Returns the destination view when dismissing a context menu.
    /// - Returns: Self
    @available(iOS 13.0, *)
    public func previewForDismissingContextMenu(_ content: @escaping ()->View)->Self{
        let sel = #selector(gridNode?.collectionView(_:previewForDismissingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            return content()
        })
        return self
    }
}
