//
//  GridModifers.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation

extension Grid {
    
    /// Sets a Boolean value that controls whether users enable move item.
    /// - Parameter value: A Boolean value that controls whether users enable move item.
    /// - Returns: Self
    @discardableResult
    public func enableMoveItem(_ value:Bool) -> Self {
        gridNode?.enableMoveItem(value)
        return self
    }
    
    /// Scrolls the grid contents until the specified item is visible.
    /// - Parameters:
    ///   - indexPath: The index path of the item to scroll into view.
    ///   - scrollposition: An option that specifies where the item should be positioned when scrolling finishes. For a list of possible values, see UICollectionView.ScrollPosition.
    ///   - animated: Specify true to animate the scrolling behavior or false to adjust the scroll view’s visible content immediately.
    /// - Returns: Self
    @discardableResult
    public func scrollToItem(indexPath: IndexPath, scrollposition: UICollectionView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(ArgoKitGridView.scrollToItem(at:at:animated:)),indexPath,scrollposition.rawValue,animated)
        return self
    }
    
    /// Scrolls a specific area of the content so that it is visible in the receiver.
    /// - Parameters:
    ///   - rect: A rectangle defining an area of the content view. The rectangle should be in the coordinate space of the scroll view.
    ///   - animated: true if the scrolling should be animated, false if it should be immediate.
    /// - Returns: Self
    @discardableResult
    public func scrollToItem(rect: CGRect, animated: Bool) -> Self {
        addAttribute(#selector(ArgoKitGridView.scrollRectToVisible(_:animated:)),rect,animated  )
        return self
    }
    
    /// Sets a Boolean value that indicates whether users can select items in the grid.
    /// - Parameter value: A Boolean value that indicates whether users can select items in the grid.
    /// - Returns: Self
    @discardableResult
    public func allowsSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelection),value)
        return self
    }
    
    public func allowsSelection() -> Bool {
        if let girdView = self.nodeView() as? UICollectionView {
            return girdView.allowsSelection
        }
        return true
    }
    
    /// Sets a Boolean value that determines whether users can select more than one item in the grid.
    /// - Parameter value: A Boolean value that determines whether users can select more than one item in the grid.
    /// - Returns: Self
    @discardableResult
    public func allowsMultipleSelection(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelection),value)
        return self
    }
    
    public func allowsMultipleSelection() -> Bool {
        if let girdView = self.nodeView() as? UICollectionView {
            return girdView.allowsMultipleSelection
        }
        return false
    }
    
    @discardableResult
    public func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) -> Self{
        if let girdView = self.nodeView() as? UICollectionView {
            girdView.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
        return self
    }

    @discardableResult
    public func deselectItem(at indexPath: IndexPath, animated: Bool) -> Self{
        if let girdView = self.nodeView() as? UICollectionView {
            girdView.deselectItem(at: indexPath, animated: animated)
        }
        return self
    }
    
    /// Sets a Boolean value that determines whether the grid is in editing mode.
    /// - Parameter value: A Boolean value that determines whether the grid is in editing mode.
    /// - Returns: Self
    @discardableResult
    @available(iOS 14.0, *)
    public func editing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.isEditing),value)
        return self
    }
    
    // Editing
    
    /* Controls the editing state for the receiver.
     */
    @available(iOS 14.0, *)
    public func isEditing() -> Bool{
        if let view = self.nodeView() as? UICollectionView {
           return view.isEditing
        }
        return false
    }
    
    /// Sets a Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
    /// - Parameter value: A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
    /// - Returns: Self
    @discardableResult
    public func bounceVertical(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceVertical),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    /// - Parameter value: A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
    /// - Returns: Self
    @discardableResult
    public func bounceHorizontal (_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.alwaysBounceHorizontal),value)
        return self
    }
    
    ///  To enable intra-app drags on iPhone, set this to YES.
    ///  You can also force drags to be disabled for this collection view by setting this to NO.
    ///  By default, For iPad this will return YES and iPhone will return NO.
    /// - Returns: Self
    @discardableResult
    public func dragInteractionEnabled (_ value:Bool) -> Self {
        gridNode?.dragInteractionEnabled = value
        addAttribute(#selector(setter:ArgoKitGridView.dragInteractionEnabled),value)
        return self
    }
    
    ///  Reordering cadence affects how easily reordering occurs while dragging around a reorder-capable drop destination.
    ///  Default is UICollectionViewReorderingCadenceImmediate.
    /// - Returns: Self
    @discardableResult
    public func reorderingCadence (_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.reorderingCadence),value)
        return self
    }
    
}

// MARK: action observer
extension Grid {
    /// Setshe cell’s background color.
    /// - Parameter action:
    /// - Returns: Self
    @discardableResult
    public func cellBackgroudColor(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> UIColor) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:cellForItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    /// Sets the action that handle the item at the specified index path was selected.
    /// - Parameter action: The action that handle the item at the specified index path was selected.
    /// - Returns: Self
    @discardableResult
    public func cellItemWith(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> CGFloat) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:layout:sizeForItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the item at the specified index path was selected.
    /// - Parameter action: The action that handle the item at the specified index path was selected.
    /// - Returns: Self
    @discardableResult
    public func cellSelected(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:didSelectItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the item at the specified path was deselected.
    /// - Parameter action: The action that handle the item at the specified path was deselected.
    /// - Returns: Self
    @discardableResult
    public func cellDeselected(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:didDeselectItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath: IndexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified cell is about to be displayed in the grid.
    /// - Parameter action: The action that handle the specified cell is about to be displayed in the grid.
    /// - Returns: Self
    public func cellWillAppear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:willDisplay:forItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified cell was removed from the grid.
    /// - Parameter action: The action that handle the specified cell was removed from the grid.
    /// - Returns: Self
    public func cellDidDisappear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:didEndDisplaying:forItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?.first as? D,
                   let indexPath = paramter?.last as? IndexPath {
                    action(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified header view is about to be displayed in the grid.
    /// - Parameter action: The action that handle the specified cell is about to be displayed in the grid.
    /// - Returns: Self
    public func headerWillAppear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:willDisplayHeaderData:at:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?[0] as? D,
               let indexPath = paramter?[1] as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified header view was removed from the grid.
    /// - Parameter action: The action that handle the specified cell was removed from the grid.
    /// - Returns: Self
    public func headerDidDisappear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:didEndDisplayingHeaderData:at:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?[0] as? D,
                   let indexPath = paramter?[1] as? IndexPath{
                    action(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified footer view is about to be displayed in the grid.
    /// - Parameter action: The action that handle the specified cell is about to be displayed in the grid.
    /// - Returns: Self
    public func footerWillAppear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:willDisplayFooterData:at:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?[0] as? D,
               let indexPath = paramter?[1] as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the specified footer view was removed from the grid.
    /// - Parameter action: The action that handle the specified cell was removed from the grid.
    /// - Returns: Self
    public func footerDidDisappear(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self{
        let sel = #selector(GridNode<D>.collectionView(_:didEndDisplayingFooterData:at:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?.first as? D,
                   let indexPath = paramter?.last as? IndexPath{
                    action(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the item at the specified index path was highlighted.
    /// - Parameter action: The action that handle the item at the specified index path was highlighted.
    /// - Returns: Self
    public func cellDidHighlight(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> UIColor?) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:didHighlightItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?.first as? D,
                   let indexPath = paramter?.last as? IndexPath{
                    return action(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle the highlight was removed from the item at the specified index path.
    /// - Parameter action: The action that handle the highlight was removed from the item at the specified index path.
    /// - Returns: Self
    public func cellDidUnhighlight(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> UIColor?) -> Self {
        let sel = #selector(GridNode<D>.collectionView(_:didUnhighlightItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                if let data = paramter?.first as? D,
                   let indexPath = paramter?.last as? IndexPath{
                    return action(data, indexPath)
                }
            }
            return nil
        })
        return self
    }
}

extension Grid {
    
    /// Asks the delegate if an action menu should be displayed for the specified item.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func shouldShowMenu(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:shouldShowMenuForItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: {(obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D ,
               let indexPath = paramter?[1] as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate if it can perform the specified action on an item in the grid.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func canPerformAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
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
                return action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle perform the specified action on an item in the grid.
    /// - Parameter action: The action that handle perform the specified action on an item in the grid.
    /// - Returns: Self
    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func performAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
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
                return action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }
}

extension Grid {
    
    /// Asks the data source to return the titles for the index items to display for the grid.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func indexTitles(_ action: @escaping () -> [String]?) -> Self{
        let sel = #selector(gridNode?.indexTitles(for:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
    
    /// Asks the data source to return the index path of a grid item that corresponds to one of your index entries.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func indexPathForIndexTitle(_ action: @escaping (_ title: String, _ index: Int) -> IndexPath) -> Self{
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
extension Grid{
    /// Asks the delegate if it can perform the specified action on an item in the grid.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func itemsCancelPrefetching(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(gridNode?.collectionView(_:cancelPrefetchingForItemsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if let count = paramter?.count,
               count >= 1,
               let _indexPaths = paramter?.first as? [IndexPath]{
                action(_indexPaths)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle perform the specified action on an item in the grid.
    /// - Parameter action: The action that handle perform the specified action on an item in the grid.
    /// - Returns: Self
    @discardableResult
    public func itemsPrefetch(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        if let gridNode = self.gridNode {
            gridNode.isPrefetchingEnabled = true
            let sel = #selector(gridNode.collectionView(_:prefetchItemsAt:))
            node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
                if let count = paramter?.count,
                   count >= 1,
                   let _indexPaths = paramter?.first as? [IndexPath]{
                    action(_indexPaths)
                }
                return nil
            })
        }
        
        return self
    }
}

extension Grid{
    @available(iOS 11.0, *)
    func shouldSpringLoadItemAt(_ action: @escaping (_ data: D, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self{
        let sel = #selector(gridNode?.collectionView(_:shouldSpringLoadItemAt:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if let paramter = paramter,
                paramter.count >= 3,
               let data = paramter.first as? D,
               let indexPath = paramter[1] as? IndexPath,
               let context = paramter.last as? UISpringLoadedInteractionContext{
                return action(data,indexPath,context)
            }
            return nil
        })
        return self
    }
}

extension Grid{
    /// Asks the delegate whether the cell at the specified index path is itself focusable.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func cellCanFocus(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:canFocusItemAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate whether the focus update specified by the context is allowed to occur.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func shouldUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        let sel = #selector(gridNode?.collectionView(_:shouldUpdateFocusIn:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let context = paramter?[0] as? UITableViewFocusUpdateContext {
                return action(context)
            }
            return nil
        })
        return self
    }
    
    /// Sets the action that handle a focus update specified by the context has just occurred.
    /// - Parameter action: The action that handle a focus update specified by the context has just occurred.
    /// - Returns: Self
    @discardableResult
    public func didUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        let sel = #selector(gridNode?.collectionView(_:didUpdateFocusIn:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2,
                let context = paramter?[0] as? UITableViewFocusUpdateContext,
                let coordinator = paramter?[1] as? UIFocusAnimationCoordinator{
                action(context, coordinator)
            }
            return nil
        })
        return self
    }
    
    /// Asks the delegate for the list’s index path for the preferred focused view.
    /// - Parameter action: Result of the ask.
    /// - Returns: Self
    @discardableResult
    public func indexPathForPreferredFocusedView(_ action: @escaping () -> IndexPath?) -> Self {
        let sel = #selector(gridNode?.indexPathForPreferredFocusedView(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            return action()
        })
        return self
    }
}
