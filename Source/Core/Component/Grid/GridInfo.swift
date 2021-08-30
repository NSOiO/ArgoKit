//
//  GridInfo.swift
//  ArgoKit
//
//  Created by Bruce on 2021/6/15.
//

import Foundation
extension Grid{
    /// The number of sections displayed by the collection view.
    /// - Returns: The number of sections displayed by the collection view.
    public func numberOfSections()->Int {
        if let view = self.nodeView() as? UICollectionView {
            return view.numberOfSections
        }
        return 0
    }

    
    /// Fetches the count of items in the specified section.
    /// - Parameter section: The index of the section for which you want a count of the items.
    /// - Returns: The number of items in the specified section.
    public func numberOfItems(inSection section: Int) -> Int{
        if let view = self.nodeView() as? UICollectionView {
            return view.numberOfItems(inSection: section)
        }
        return 0
    }

    
    /// Gets the layout information for the item at the specified index path.
    /// Use this method to retrieve the layout information for a particular item. You should always use this method instead of querying the layout object directly.
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The layout attributes for the item or nil if no item exists at the specified path.
    public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        if let view = self.nodeView() as? UICollectionView {
            return view.layoutAttributesForItem(at: indexPath)
        }
        return nil
    }

    
    /// Gets the layout information for the specified supplementary view.
    /// Use this method to retrieve the layout information for a particular supplementary view. You should always use this method instead of querying the layout object directly.
    /// - Parameters:
    ///   - kind: A string specifying the kind of supplementary view whose layout attributes you want. Layout classes are responsible for defining the kinds of supplementary views they support.
    ///   - indexPath: The index path of the supplementary view. The interpretation of this value depends on how the layout implements the view. For example, a view associated with a section might contain just a section value.
    /// - Returns: The layout attributes of the supplementary view or nil if the specified supplementary view does not exist.
    public func layoutAttributesForSupplementaryElement(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        if let view = self.nodeView() as? UICollectionView {
            return view.layoutAttributesForSupplementaryElement(ofKind: kind,at: indexPath)
        }
        return nil
    }

    
    /// Gets the index path of the item at the specified point in the collection view.
    /// This method relies on the layout information provided by the associated layout object to determine which item contains the point.
    /// - Parameter point: A point in the collection view’s coordinate system.
    /// - Returns: The index path of the item at the specified point or nil if no item was found at the specified point.
    public func indexPathForItem(at point: CGPoint) -> IndexPath?{
        if let view = self.nodeView() as? UICollectionView {
            return view.indexPathForItem(at: point)
        }
        return nil
    }

    
    /// Gets the index path of the specified cell.
    /// - Parameter cell: The cell object whose index path you want.
    /// - Returns: The index path of the cell or nil if the specified cell is not in the collection view.
    public func indexPath(for cell: UICollectionViewCell) -> IndexPath?{
        if let view = self.nodeView() as? UICollectionView {
            return view.indexPath(for: cell)
        }
        return nil
    }
    
    /// The grid tuples that contain models and cells that are visible in the grid.
    /// - Returns: The return value of this function is an array containing tuples that contain viewmodes and cells, each representing a visible viewmode in the grid.
    public func visibleModelCells() -> [(D,UICollectionViewCell)] {
        return self.gridNode?.visibleModelCells() ?? []
    }

    /// The grid models that are visible in the grid.
    /// - Returns: value of this function is an array containing viewmodel objects, each representing a visible viewmode in the grid.
    public func visibleModels() -> [D] {
        return self.gridNode?.visibleModels() ?? []
    }
    

    /// Gets the visible cell object at the specified index path.
    /// - Parameter indexPath: The index path that specifies the section and item number of the cell.
    /// - Returns: the visible cell object at the specified index path.
    public func gridCellforItem(_ indexPath:IndexPath) -> UICollectionViewCell? {
        return self.gridNode?.gridCellforItem(indexPath)
    }
    
    
    /// An array of the visible items in the collection view.
    /// The value of this property is an unsorted array of NSIndexPath objects, each of which corresponds to a visible cell in the collection view. This array does not include any supplementary views that are currently visible. If there are no visible items, the value of this property is an empty array.
    /// - Returns: An array of the visible items in the collection view.
    public func indexPathsForVisibleItems() -> [IndexPath] {
        if let view = self.nodeView() as? UICollectionView {
            return view.indexPathsForVisibleItems
        }
        return []
    }
    
    /// The index paths for the selected items.
    /// The value of this property is an array of NSIndexPath objects, each of which corresponds to a single selected item. If there are no selected items, the value of this property is nil.
    /// - Returns: The index paths for the selected items.
    
    public func indexPathsForSelectedItems() -> [IndexPath]? {
        if let girdView = self.nodeView() as? UICollectionView {
            return girdView.indexPathsForSelectedItems
        }
        return nil
    }

    
    /// Gets the supplementary view at the specified index path.
    /// - Parameters:
    ///   - elementKind: The kind of supplementary view to locate. This value is defined by the layout object. This parameter must not be nil.
    ///   - indexPath: The index path of the supplementary view. This parameter must not be nil.
    /// - Returns: The specified supplementary view, or nil if the view could not be found.
    @available(iOS 9.0, *)
    public func supplementaryView(forElementKind elementKind: String, at indexPath: IndexPath) -> UICollectionReusableView?{
        if let view = self.nodeView() as? UICollectionView {
            return view.supplementaryView(forElementKind: elementKind, at: indexPath)
        }
        return nil
    }

    
    /// Gets an array of the visible supplementary views of the specified kind.
    /// - Parameter elementKind: The kind of supplementary view to locate. This value is defined by the layout object. This parameter must not be nil.
    /// - Returns: An array of the visible supplementary views. If no supplementary views are visible, the returned array is empty.
    @available(iOS 9.0, *)
    public func visibleSupplementaryViews(ofKind elementKind: String) -> [UICollectionReusableView]{
        if let view = self.nodeView() as? UICollectionView {
            return view.visibleSupplementaryViews(ofKind: elementKind)
        }
        return []
    }
    
    /// Gets the index paths of all visible supplementary views of the specified type.
    /// - Parameter elementKind: The kind of supplementary view to locate. This value is defined by the layout object. This parameter must not be nil.
    /// - Returns: An array of NSIndexPath objects, each of which corresponds to a visible supplementary view in the collection view. If there are no visible supplementary views, this method returns an empty array.
    @available(iOS 9.0, *)
    public func indexPathsForVisibleSupplementaryElements(ofKind elementKind: String) -> [IndexPath]{
        if let view = self.nodeView() as? UICollectionView {
            return view.indexPathsForVisibleSupplementaryElements(ofKind: elementKind)
        }
        return []
    }
    
    /// A Boolean value that indicates whether the collection view contains drop placeholders or is reordering its items as part of handling a drop.
    ///When the value of this property is true, avoid making any significant changes to the collection view. Specifically, do not reload the collection view's data, as doing so deletes all placeholders and recreates items from the data source.
    /// - Returns: YES if the collection view is reordering or has drop placeholders.
    public func hasUncommittedUpdates() -> Bool {
        if let view = self.nodeView() as? UICollectionView {
            return view.hasUncommittedUpdates
        }
        return false
    }

}

extension Grid{
    /// Initiates the interactive movement of the item at the specified index path.
    /// - Parameter indexPath: The index path of the item you want to move.
    /// - Returns: true if it is possible to move the item or false if the item is not allowed to move.
    @available(iOS 9.0, *)
    public func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool{
        if let view = self.nodeView() as? UICollectionView {
            return view.beginInteractiveMovementForItem(at: indexPath)
        }
        return true
    }
    
    /// Updates the position of the item within the collection view’s bounds.
    /// - Parameter targetPosition: The position of the item in the collection view’s coordinate system.
    /// - Returns: Self
    @discardableResult
    @available(iOS 9.0, *)
    public func updateInteractiveMovementTargetPosition(_ targetPosition: CGPoint) -> Self{
        if let view = self.nodeView() as? UICollectionView {
            view.updateInteractiveMovementTargetPosition(targetPosition)
        }
        return self
    }
    
    /// Ends interactive movement tracking and moves the target item to its new location.
    /// - Returns: Self
    @discardableResult
    @available(iOS 9.0, *)
    public func endInteractiveMovement() -> Self{
        if let view = self.nodeView() as? UICollectionView {
            view.endInteractiveMovement()
        }
        return self
    }
    
    /// Ends interactive movement tracking and returns the target item to its original location.
    /// - Returns: Self
    @discardableResult
    @available(iOS 9.0, *)
    public func cancelInteractiveMovement() -> Self{
        if let view = self.nodeView() as? UICollectionView {
            view.cancelInteractiveMovement()
        }
        return self
    }

    
    /// A Boolean value that indicates whether the collection view automatically assigns the focus to the item at the last focused index path.
    /// - Returns: Self
    @discardableResult
    @available(iOS 9.0, *)
    public func remembersLastFocusedIndexPath(_ value :Bool) -> Self{
        addAttribute(#selector(setter:ArgoKitGridView.remembersLastFocusedIndexPath),value)
        return self
    }
    
    /// A Boolean value that indicates whether the collection view automatically assigns the focus to the item at the last focused index path.
    /// - Returns: A Boolean value that indicates whether the collection view automatically assigns the focus to the item at the last focused index path.
    @available(iOS 9.0, *)
    public func remembersLastFocusedIndexPath() -> Bool {
        if let view = self.nodeView() as? UICollectionView {
           return view.remembersLastFocusedIndexPath
        }
        return false
    }

    /// A Boolean value that triggers an automatic selection when focus moves to a cell.
    /// - Returns: Self
    @discardableResult
    @available(iOS 14.0, *)
    public func selectionFollowsFocus(_ value :Bool) -> Self{
        addAttribute(#selector(setter:ArgoKitGridView.selectionFollowsFocus),value)
        return self
    }
    
    ///  Boolean value that triggers an automatic selection when focus moves to a cell.
    /// - Returns: value that triggers an automatic selection when focus moves to a cell.
    @available(iOS 14.0, *)
    public func selectionFollowsFocus() -> Bool{
        if let view = self.nodeView() as? UICollectionView {
           return view.selectionFollowsFocus
        }
        return false
    }

    
    /// A Boolean value that indicates whether items were lifted from the collection view and have not yet been dropped.
    /// - Returns: A Boolean value that indicates whether items were lifted from the collection view and have not yet been dropped.
    @available(iOS 11.0, *)
    
    public func  hasActiveDrag() -> Bool {
        if let view = self.nodeView() as? UICollectionView {
           return view.hasActiveDrag
        }
        return false
    }

    
    /// A Boolean value that indicates whether the collection view is currently tracking a drop session.
    /// - Returns: A Boolean value that indicates whether the collection view is currently tracking a drop session.
    @available(iOS 11.0, *)
    public func hasActiveDrop() -> Bool {
        if let view = self.nodeView() as? UICollectionView {
           return view.hasActiveDrop
        }
        return false
    }

    
    /// Sets a Boolean value that determines whether users can select cells while the grid is in editing mode.
    /// - Parameter value: A Boolean value that determines whether users can select cells while the grid is in editing mode.
    /// - Returns: Self
    @discardableResult
    @available(iOS 14.0, *)
    public func allowsSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsSelectionDuringEditing),value)
        return self
    }
    
    /// A Boolean value that determines whether users can select cells while the collection view is in editing mode.
    /// - Returns: he default value is false.
    @available(iOS 14.0, *)
    public func allowsSelectionDuringEditing() -> Bool{
        if let view = self.nodeView() as? UICollectionView {
           return view.allowsSelectionDuringEditing
        }
        return false
    }

    /// Sets a Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Parameter value: A Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Returns: Self
    @discardableResult
    @available(iOS 14.0, *)
    public func  allowsMultipleSelectionDuringEditing(_ value:Bool) -> Self {
        addAttribute(#selector(setter:ArgoKitGridView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    /// A Boolean value that controls whether users can select more than one cell simultaneously in editing mode.
    /// - Returns: The default value is false.
    @available(iOS 14.0, *)
    public func allowsMultipleSelectionDuringEditing() -> Bool{
        if let view = self.nodeView() as? UICollectionView {
           return view.allowsMultipleSelectionDuringEditing
        }
        return false
    }
}
