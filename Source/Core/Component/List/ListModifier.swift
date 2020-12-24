//
//  ListModifier.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/24.
//

import Foundation
extension List {
    
    @discardableResult
    public func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        tableNode.selectionStyle = value
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedRowHeight),value)
        return self
    }

    @discardableResult
    public func estimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedSectionHeaderHeight),value)
        return self
    }
    
    @discardableResult
    public func estimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedSectionFooterHeight),value)
        return self
    }

    @discardableResult
    public func separatorInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInset),value)
        return self
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func separatorInsetReference(_ value: UITableView.SeparatorInsetReference) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInsetReference),value.rawValue)
        return self
    }

    @discardableResult
    public func backgroundView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITableView.backgroundView),value)
        return self
    }
    
    @discardableResult
    public func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToRow(at:at:animated:)),indexPath, scrollPosition.rawValue, animated)
        return self
    }

    @discardableResult
    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToNearestSelectedRow(at:animated:)), scrollPosition.rawValue, animated)
        return self
    }
    
    @discardableResult
    public func setEditing(_ editing: Bool, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.setEditing(_:animated:)), editing, animated)
        return self
    }

    @discardableResult
    public func allowsSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelection),value)
        return self
    }

    @discardableResult
    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelectionDuringEditing),value)
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelection),value)
        return self
    }

    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    @discardableResult
    public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> Self {
        addAttribute(#selector(UITableView.selectRow(at:animated:scrollPosition:)), indexPath, animated, scrollPosition.rawValue)
        return self
    }

    @discardableResult
    public func deselectRow(at indexPath: IndexPath, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.deselectRow(at:animated:)), indexPath, animated)
        return self
    }

    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexMinimumDisplayRowCount),value)
        return self
    }

    @discardableResult
    public func sectionIndexColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexColor),value)
        return self
    }

    @discardableResult
    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexBackgroundColor),value)
        return self
    }

    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexTrackingBackgroundColor),value)
        return self
    }

    @discardableResult
    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        addAttribute(#selector(setter:UITableView.separatorStyle),value.rawValue)
        return self
    }

    @discardableResult
    public func separatorColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorColor),value)
        return self
    }
    
    @available(iOS 8.0, *)
    @discardableResult
    public func separatorEffect(_ value: UIVisualEffect?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorEffect),value)
        return self
    }

    @available(iOS 9.0, *)
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.cellLayoutMarginsFollowReadableWidth),value)
        return self
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.insetsContentViewsToSafeArea),value)
        return self
    }
    
  
    
    @available(iOS 9.0, *)
    @discardableResult
    public func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.remembersLastFocusedIndexPath),value)
        return self
    }

    @available(iOS 14.0, *)
    @discardableResult
    public func selectionFollowsFocus(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.selectionFollowsFocus),value)
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.dragInteractionEnabled),value)
        return self
    }
}



extension List {
        
    @discardableResult
    public func canEditRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:canEditRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath
               {
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    @discardableResult
    public func canMoveRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:canMoveRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    @discardableResult
    public func sectionIndexTitles(_ value: [String]?) -> Self {
        tableNode.sectionIndexTitles = value;
        return self
    }
    
    @discardableResult
    public func commitEditingRow(_ action: @escaping (_ editingStyle: UITableViewCell.EditingStyle, _ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:commit:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 3,
                let editingStyle = paramter?[0] as? UITableViewCell.EditingStyle,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath {
                action(editingStyle, data, indexPath)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func moveRow(_ action: @escaping (_ sourceData: D, _ destinationData: D, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:moveRowAt:to:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4,
                let sourceData: D = paramter?[0] as? D,
                let destinationData: D = paramter?[1] as? D,
                let sourceIndexPath: IndexPath = paramter?[2] as? IndexPath,
                let destinationIndexPath: IndexPath = paramter?[3] as? IndexPath{
                action(sourceData, destinationData, sourceIndexPath, destinationIndexPath)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    @discardableResult
    public func prefetchRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:prefetchRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let indexPaths = paramter?[0] as? [IndexPath] {
                action(indexPaths)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func cancelPrefetchingRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:cancelPrefetchingForRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
                let indexPaths = paramter?[0] as? [IndexPath]
            {
                action(indexPaths)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    @discardableResult
    public func willDisplayRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willDisplay:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func willDisplayHeaderView(_ action: @escaping (_ data: ArgoKitIdentifiable, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willDisplayHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? ArgoKitIdentifiable,
               let section = paramter?.last as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func willDisplayFooterView(_ action: @escaping (_ data: ArgoKitIdentifiable, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willDisplayFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? ArgoKitIdentifiable,
                let section = paramter?[1] as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didEndDisplayingRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didEndDisplaying:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didEndDisplayingHeaderView(_ action: @escaping (_ data: ArgoKitIdentifiable, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didEndDisplayingHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? ArgoKitIdentifiable,
                let section = paramter?[1] as? Int {
                action(data, section)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didEndDisplayingFooterView(_ action: @escaping (_ data: ArgoKitIdentifiable, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didEndDisplayingFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
                let data = paramter?[0] as? ArgoKitIdentifiable,
                let section = paramter?[1] as? Int{
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    @discardableResult
    public func shouldHighlightRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return true
        })
        return self
    }

    @discardableResult
    public func didHighlightRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didUnhighlightRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didUnhighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func willSelectRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func willDeselectRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath {
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didSelectRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didDeselectRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didDeselectRowAt:))
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
    
    @discardableResult
    public func editingStyle(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:editingStyleForRowAt:))
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

    @discardableResult
    public func titleForDeleteConfirmationButton(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> String?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
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
    
    @available(iOS, introduced: 8.0, deprecated: 13.0)
    @discardableResult
    public func editActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> [ListRowAction]?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:editActionsForRowAt:))
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

    @available(iOS 11.0, *)
    @discardableResult
    public func leadingSwipeActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
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

    @available(iOS 11.0, *)
    @discardableResult
    public func trailingSwipeActions(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
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

    @discardableResult
    public func shouldIndentWhileEditingRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldIndentWhileEditingRowAt:))
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

    @discardableResult
    public func willBeginEditingRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willBeginEditingRowAt:))
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

    @discardableResult
    public func didEndEditingRow(_ action: @escaping (_ data: D?, _ indexPath: IndexPath?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didEndEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 ,
               let data = paramter?.first as? D,
               let indexPath = paramter?.last as? IndexPath{
                return action(data, indexPath)
            } else {
                action(nil, nil)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func targetIndexPathForMove(_ action: @escaping (_ sourceData: D, _ proposedDestinationData: D, _ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4,
                let sourceData = paramter?[0] as? D,
                let destinationData = paramter?[1] as? D,
                let sourceIndexPath = paramter?[2] as? IndexPath,
                let proposedDestinationIndexPath  = paramter?[3] as? IndexPath{
                return action(sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func indentationLevel(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Int) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:indentationLevelForRowAt:))
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

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func shouldShowMenu(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldShowMenuForRowAt:))
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

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func canPerformAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:canPerformAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let act = paramter?[0] as? Selector,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4,let sender_ = paramter?[3]{
                    sender = sender_
                }
                return action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    @discardableResult
    public func performAction(_ action: @escaping (_ action: Selector, _ data: D, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:performAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let act = paramter?[0] as? Selector,
                let data = paramter?[1] as? D,
                let indexPath = paramter?[2] as? IndexPath{
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4 ,let sender_ = paramter?[3]{
                    sender = sender_
                }
                action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func canFocusRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:canFocusRowAt:))
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

    @discardableResult
    public func shouldUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldUpdateFocusIn:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let context = paramter?[0] as? UITableViewFocusUpdateContext {
                return action(context)
            }
            return nil
        })
        return self
    }

    @discardableResult
    public func didUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didUpdateFocusIn:with:))
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

    @discardableResult
    public func indexPathForPreferredFocusedView(_ action: @escaping () -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.indexPathForPreferredFocusedView(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            return action()
        })
        return self
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func shouldSpringLoadRow(_ action: @escaping (_ data: D, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldSpringLoadRowAt:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3,
                let data = paramter?[0] as? D,
                let indexPath = paramter?[1] as? IndexPath,
                let context = paramter?[2] as? UISpringLoadedInteractionContext{
                return action(data, indexPath, context)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func shouldBeginMultipleSelectionInteraction(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
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

    @available(iOS 13.0, *)
    @discardableResult
    public func didBeginMultipleSelectionInteraction(_ action: @escaping (_ data: D, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:didBeginMultipleSelectionInteractionAt:))
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

    @available(iOS 13.0, *)
    @discardableResult
    public func didEndMultipleSelectionInteraction(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableViewDidEndMultipleSelectionInteraction(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            action()
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func contextMenuConfiguration(_ action: @escaping (_ data: D, _ indexPath: IndexPath, _ point: CGPoint) -> UIContextMenuConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:contextMenuConfigurationForRowAt:point:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 ,
               let data = paramter?[0] as? D,
               let indexPath = paramter?[1] as? IndexPath,
               let point = paramter?[2] as? CGPoint{
                return action(data, indexPath, point)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func previewForHighlightingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:previewForHighlightingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration: UIContextMenuConfiguration = paramter?[0] as? UIContextMenuConfiguration{
                return action(configuration)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func previewForDismissingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:previewForDismissingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                return action(configuration)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    @discardableResult
    public func willPerformPreviewAction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionCommitAnimating) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willPerformPreviewActionForMenuWith:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2,
               let configuration = paramter?[0] as? UIContextMenuConfiguration,
               let animator = paramter?[1] as? UIContextMenuInteractionCommitAnimating{
        
                action(configuration, animator)
            }
            return nil
        })
        return self
    }

    @available(iOS 14.0, *)
    @discardableResult
    public func willDisplayContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willDisplayContextMenu:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2,let animator_ = paramter?[1] as? UIContextMenuInteractionAnimating {
                    animator = animator_
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }

    @available(iOS 14.0, *)
    @discardableResult
    public func willEndContextMenuInteraction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode<D>.tableView(_:willEndContextMenuInteraction:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1,
               let configuration = paramter?[0] as? UIContextMenuConfiguration{
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2,let animator_ = paramter?[1] as? UIContextMenuInteractionAnimating {
                    animator = animator_
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }
}
