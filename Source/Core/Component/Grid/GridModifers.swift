//
//  GridModifers.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
extension Grid{
    public func allowsSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelection),value)
        return self
    }
    
    public func allowsMultipleSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelection),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func editing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.isEditing),value)
        return self
    }

    
    @available(iOS 14.0, *)
    public func allowsSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelectionDuringEditing),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func  allowsMultipleSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func selectionFollowsFocus(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.selectionFollowsFocus),value)
        return self
    }
    
    public func bounceVertical(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceVertical),value)
        return self
    }
    public func bounceHorizontal (_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceHorizontal),value)
        return self
    }

}
// MARK: action observer
extension Grid{
    @discardableResult
    public func cellSelected(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) ->Self {
        let sel = #selector(ArgoKitGridNode.collectionView(_:didSelectItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let data: D = paramter![0] as! D
                let indexPath: IndexPath = paramter![1] as! IndexPath
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func cellDeselected(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) ->Self {
        let sel = #selector(ArgoKitGridNode.collectionView(_:didDeselectItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let data: D = paramter![0] as! D
                let indexPath: IndexPath = paramter![1] as! IndexPath
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func cellWillAppear(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(ArgoKitGridNode.collectionView(_:willDisplay:forItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let data: D = paramter![0] as! D
                let indexPath: IndexPath = paramter![1] as! IndexPath
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func cellDidDisappear(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(ArgoKitGridNode.collectionView(_:didEndDisplaying:forItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let data: D = paramter![0] as! D
                let indexPath: IndexPath = paramter![1] as! IndexPath
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func cellDidHighlight(_ function:@escaping () -> UIColor) -> Self{
        let sel = #selector(ArgoKitGridNode.collectionView(_:didHighlightItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return function()
        })
        return self
    }
    
    public func cellDidUnhighlight(_ function:@escaping () -> UIColor) -> Self{
        let sel = #selector(ArgoKitGridNode.collectionView(_:didUnhighlightItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return function()
        })
        return self
    }
}
