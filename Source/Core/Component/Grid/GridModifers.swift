//
//  GridModifers.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
extension Grid{
    @discardableResult
    public func enableMoveItem(_ value:Bool) -> Self {
        gridNode?.enableMoveItem(value)
        return self
    }
    
    @discardableResult
    public func allowsSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelection),value)
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelection),value)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func editing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.isEditing),value)
        return self
    }

    @discardableResult
    @available(iOS 14.0, *)
    public func allowsSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelectionDuringEditing),value)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func  allowsMultipleSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    public func selectionFollowsFocus(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.selectionFollowsFocus),value)
        return self
    }
    
    @discardableResult
    public func bounceVertical(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceVertical),value)
        return self
    }
    
    @discardableResult
    public func bounceHorizontal (_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceHorizontal),value)
        return self
    }

}
// MARK: action observer
extension Grid{
    @discardableResult
    public func cellSelected(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) ->Self {
        let sel = #selector(GridNode.collectionView(_:didSelectItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func cellDeselected(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) ->Self {
        let sel = #selector(GridNode.collectionView(_:didDeselectItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func cellWillAppear(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode.collectionView(_:willDisplay:forItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                function(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func cellDidDisappear(_ function:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode.collectionView(_:didEndDisplaying:forItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?.first as? D,let indexPath = paramter?.last as? IndexPath {
                    function(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
    
    public func cellDidHighlight(_ function:@escaping () -> UIColor) -> Self{
        let sel = #selector(GridNode.collectionView(_:didHighlightItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return function()
        })
        return self
    }
    
    public func cellDidUnhighlight(_ function:@escaping () -> UIColor) -> Self{
        let sel = #selector(GridNode.collectionView(_:didUnhighlightItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return function()
        })
        return self
    }
}


extension Grid{
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func shouldShowMenu(_ function: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:shouldShowMenuForItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath = paramter?[1] as? IndexPath{
                return function(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func canPerformAction(_ function: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:canPerformAction:forItemAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3,
               let act = paramter?.first as? Selector,
               let data = paramter?[1] as? D,
               let indexPath: IndexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4,let sender_ =  paramter?[3]{
                    sender = sender_
                }
                return function(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func performAction(_ function: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        let sel = #selector(gridNode?.collectionView(_:performAction:forItemAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3 ,
               let act = paramter?.first as? Selector,
               let data = paramter?[1] as? D,
               let indexPath: IndexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4,let sender_ =  paramter?[3]{
                    sender = sender_
                }
                return function(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }
}

extension Grid{
    func indexTitles(_ action: @escaping () -> [String]?) -> Self{
        let sel = #selector(gridNode?.indexTitles(for:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    func indexPathForIndexTitle(_ action: @escaping (_ title: String, _ index: Int) -> IndexPath) -> Self{
        let sel = #selector(gridNode?.collectionView(_:indexPathForIndexTitle:at:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let title = paramter?.first as? String,
               let index = paramter?.last as?Int{
                return action(title, index)
            }
            return nil
        })
        return self
    }
}
