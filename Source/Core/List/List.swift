//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class List : ScrollView {
    
    private var tableNode: ArgoKitTableNode {
        pNode as! ArgoKitTableNode
    }
    
    private init(style: UITableView.Style?) {
        super.init()
        tableNode.style = style ?? .plain
    }
    
    public convenience init(style: UITableView.Style? = .plain, @ArgoKitListBuilder content: () -> View) {
        self.init(style: style)
        let container = content()
        if let nodes = container.type.viewNodes() {
            tableNode.dataSourceHelper.nodeList = [nodes]
        }
    }

    public convenience init<T>(_ style: UITableView.Style? = .plain, data: [T], @ArgoKitListBuilder rowContent: @escaping (T) -> View) where T : ArgoKitIdentifiable {
        self.init(style: style)
        tableNode.dataSourceHelper.dataList = [data]
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    public convenience init<T>(_ style: UITableView.Style? = .plain, sectionData: [[T]], @ArgoKitListBuilder rowContent: @escaping (T) -> View) where T : ArgoKitIdentifiable {
        self.init(style: style)
        tableNode.dataSourceHelper.dataList = sectionData
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    override func createNode() {
        pNode = ArgoKitTableNode(viewClass: UITableView.self)
    }
}

extension List {
    
    public func estimatedRowHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedRowHeight),value)
        return self
    }

    public func estimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedSectionHeaderHeight),value)
        return self
    }
    
    public func estimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UITableView.estimatedSectionFooterHeight),value)
        return self
    }

    public func separatorInset(_ value: UIEdgeInsets) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInset),value)
        return self
    }

    @available(iOS 11.0, *)
    public func separatorInsetReference(_ value: UITableView.SeparatorInsetReference) -> Self {
        addAttribute(#selector(setter:UITableView.separatorInsetReference),value.rawValue)
        return self
    }

    public func backgroundView(_ value: UIView?) -> Self {
        addAttribute(#selector(setter:UITableView.backgroundView),value)
        return self
    }
    
    public func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToRow(at:at:animated:)),indexPath, scrollPosition.rawValue, animated)
        return self
    }

    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.scrollToNearestSelectedRow(at:animated:)), scrollPosition.rawValue, animated)
        return self
    }
    
    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        tableNode.reloadSections(sections, with: animation)
        return self
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        tableNode.reloadRows(at: indexPaths, with: animation)
        return self
    }
    
    public func setEditing(_ editing: Bool, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.setEditing(_:animated:)), editing, animated)
        return self
    }

    public func allowsSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelection),value)
        return self
    }

    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsSelectionDuringEditing),value)
        return self
    }
    
    public func allowsMultipleSelection(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelection),value)
        return self
    }

    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.allowsMultipleSelectionDuringEditing),value)
        return self
    }
    
    public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> Self {
        addAttribute(#selector(UITableView.selectRow(at:animated:scrollPosition:)), indexPath, animated, scrollPosition.rawValue)
        return self
    }

    public func deselectRow(at indexPath: IndexPath, animated: Bool) -> Self {
        addAttribute(#selector(UITableView.deselectRow(at:animated:)), indexPath, animated)
        return self
    }

    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexMinimumDisplayRowCount),value)
        return self
    }

    public func sectionIndexColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexColor),value)
        return self
    }

    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexBackgroundColor),value)
        return self
    }

    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.sectionIndexTrackingBackgroundColor),value)
        return self
    }

    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        addAttribute(#selector(setter:UITableView.separatorStyle),value.rawValue)
        return self
    }

    public func separatorColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorColor),value)
        return self
    }
    
    @available(iOS 8.0, *)
    public func separatorEffect(_ value: UIVisualEffect?) -> Self {
        addAttribute(#selector(setter:UITableView.separatorEffect),value)
        return self
    }

    @available(iOS 9.0, *)
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.cellLayoutMarginsFollowReadableWidth),value)
        return self
    }

    @available(iOS 11.0, *)
    public func insetsContentViewsToSafeArea(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.insetsContentViewsToSafeArea),value)
        return self
    }
    
    public func tableHeaderView(@ArgoKitViewBuilder headerContent: () -> View) -> Self {
        let container = headerContent()
        tableNode.tableHeaderNode = container.type.viewNode()
        return self
    }
    
    public func tableFooterView(@ArgoKitViewBuilder footerContent: () -> View) -> Self {
        let container = footerContent()
        tableNode.tableFooterNode = container.type.viewNode()
        return self
    }
    
    public func sectionHeader<T>(_ data: [T], @ArgoKitListBuilder headerContent: @escaping (T) -> View) -> Self where T : ArgoKitIdentifiable {
        tableNode.sectionHeaderSourceHelper.dataList = [data]
        tableNode.sectionHeaderSourceHelper.buildNodeFunc = { item in
            return headerContent(item as! T)
        }
        return self
    }
    
    public func sectionFooter<T>(_ data: [T], @ArgoKitListBuilder footerContent: @escaping (T) -> View) -> Self where T : ArgoKitIdentifiable {
        tableNode.sectionFooterSourceHelper.dataList = [data]
        tableNode.sectionFooterSourceHelper.buildNodeFunc = { item in
            return footerContent(item as! T)
        }
        return self
    }
    
    @available(iOS 9.0, *)
    public func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.remembersLastFocusedIndexPath),value)
        return self
    }

    @available(iOS 14.0, *)
    public func selectionFollowsFocus(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.selectionFollowsFocus),value)
        return self
    }
    
    @available(iOS 11.0, *)
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UITableView.dragInteractionEnabled),value)
        return self
    }
}

extension List {
    
    public func titlesForHeaderInSection(_ value: [Int:String]?) -> Self {
        tableNode.titlesForHeaderInSection = value;
        return self
    }
    
    public func titlesForFooterInSection(_ value: [Int:String]?) -> Self {
        tableNode.titlesForFooterInSection = value;
        return self
    }
    
    public func canEditRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canEditRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return true
        })
        return self
    }
    
    public func canMoveRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canMoveRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return true
        })
        return self
    }
    
    public func titlesForSection(_ value: [String]?) -> Self {
        tableNode.titlesForSection = value;
        return self
    }
    
    public func commitEditingStyleForRowAtIndexPath(_ action: @escaping (_ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:commit:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let editingStyle: UITableViewCell.EditingStyle = paramter![0] as! UITableViewCell.EditingStyle
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(editingStyle, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func moveRowAtIndexPathToIndexPath(_ action: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:moveRowAt:to:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let sourceIndexPath: IndexPath = paramter![0] as! IndexPath
                let destinationIndexPath: IndexPath = paramter![1] as! IndexPath
                action(sourceIndexPath, destinationIndexPath)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    public func prefetchRowsAtIndexPaths(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:prefetchRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPaths: [IndexPath] = paramter![0] as! [IndexPath]
                action(indexPaths)
            }
            return nil
        })
        return self
    }
    
    public func cancelPrefetchingForRowsAtIndexPaths(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:cancelPrefetchingForRowsAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPaths: [IndexPath] = paramter![0] as! [IndexPath]
                action(indexPaths)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    public func willDisplayCellForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplay:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func willDisplayHeaderViewForSection(_ action: @escaping (_ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplayHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let section: Int = paramter![0] as! Int
                action(section)
            }
            return nil
        })
        return self
    }

    public func willDisplayFooterViewForSection(_ action: @escaping (_ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplayFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let section: Int = paramter![0] as! Int
                action(section)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingCellForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplaying:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingHeaderViewForSection(_ action: @escaping (_ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplayingHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let section: Int = paramter![0] as! Int
                action(section)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingFooterViewForSection(_ action: @escaping (_ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplayingFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let section: Int = paramter![0] as! Int
                action(section)
            }
            return nil
        })
        return self
    }
    
    public func shouldHighlightRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return true
        })
        return self
    }

    public func didHighlightRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func didUnhighlightRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didUnhighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func willSelectRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    public func willDeselectRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    public func didSelectRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func didDeselectRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }
    
    public func editingStyleForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> UITableViewCell.EditingStyle) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:editingStyleForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return UITableViewCell.EditingStyle.delete
        })
        return self
    }

    public func titleForDeleteConfirmationButtonForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> String?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }
    
    @available(iOS, introduced: 8.0, deprecated: 13.0)
    public func editActionsForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> [UITableViewRowAction]?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:editActionsForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 11.0, *)
    public func leadingSwipeActionsConfigurationForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 11.0, *)
    public func trailingSwipeActionsConfigurationForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    public func shouldIndentWhileEditingRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldIndentWhileEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    public func willBeginEditingRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willBeginEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    public func didEndEditingRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            } else {
                action(nil)
            }
            return nil
        })
        return self
    }

    public func targetIndexPathForMoveFromRowAtIndexPathToProposedIndexPath(_ action: @escaping (_ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let sourceIndexPath: IndexPath = paramter![0] as! IndexPath
                let proposedDestinationIndexPath: IndexPath = paramter![1] as! IndexPath
                return action(sourceIndexPath, proposedDestinationIndexPath)
            }
            return nil
        })
        return self
    }

    public func indentationLevelForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Int) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:indentationLevelForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func shouldShowMenuForRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldShowMenuForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func canPerformActionForRowAtIndexPathWithSender(_ action: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canPerformAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let act: Selector = paramter![0] as! Selector
                let indexPath: IndexPath = paramter![1] as! IndexPath
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 3 {
                    sender = paramter![2]
                }
                return action(act, indexPath, sender)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func performActionForRowAtIndexPathWithSender(_ action: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:performAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let act: Selector = paramter![0] as! Selector
                let indexPath: IndexPath = paramter![1] as! IndexPath
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 3 {
                    sender = paramter![2]
                }
                action(act, indexPath, sender)
            }
            return nil
        })
        return self
    }

    public func canFocusRowAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canFocusRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    public func shouldUpdateFocusInContext(_ action: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldUpdateFocusIn:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let context: UITableViewFocusUpdateContext = paramter![0] as! UITableViewFocusUpdateContext
                return action(context)
            }
            return nil
        })
        return self
    }

    public func didUpdateFocusInContextWithCoordinator(_ action: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didUpdateFocusIn:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let context: UITableViewFocusUpdateContext = paramter![0] as! UITableViewFocusUpdateContext
                let coordinator: UIFocusAnimationCoordinator = paramter![1] as! UIFocusAnimationCoordinator
                action(context, coordinator)
            }
            return nil
        })
        return self
    }

    public func indexPathForPreferredFocusedView(_ action: @escaping () -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode.indexPathForPreferredFocusedView(in:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            return action()
        })
        return self
    }

    @available(iOS 11.0, *)
    public func shouldSpringLoadRowAtIndexPathWithContext(_ action: @escaping (_ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldSpringLoadRowAt:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let context: UISpringLoadedInteractionContext = paramter![0] as! UISpringLoadedInteractionContext
                return action(context)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func shouldBeginMultipleSelectionInteractionAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                return action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func didBeginMultipleSelectionInteractionAtIndexPath(_ action: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func didEndMultipleSelectionInteraction(_ action: @escaping () -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableViewDidEndMultipleSelectionInteraction(_:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            action()
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func contextMenuConfigurationForRowAtIndexPathWithPoint(_ action: @escaping (_ indexPath: IndexPath, _ point: CGPoint) -> UIContextMenuConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:contextMenuConfigurationForRowAt:point:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                let point: CGPoint = paramter![1] as! CGPoint
                return action(indexPath, point)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func previewForHighlightingContextMenuWithConfiguration(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:previewForHighlightingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let configuration: UIContextMenuConfiguration = paramter![0] as! UIContextMenuConfiguration
                return action(configuration)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func previewForDismissingContextMenuWithConfiguration(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:previewForDismissingContextMenuWithConfiguration:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let configuration: UIContextMenuConfiguration = paramter![0] as! UIContextMenuConfiguration
                return action(configuration)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func willPerformPreviewActionForMenuWithConfigurationAndAnimator(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionCommitAnimating) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willPerformPreviewActionForMenuWith:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let configuration: UIContextMenuConfiguration = paramter![0] as! UIContextMenuConfiguration
                let animator: UIContextMenuInteractionCommitAnimating = paramter![1] as! UIContextMenuInteractionCommitAnimating
                action(configuration, animator)
            }
            return nil
        })
        return self
    }

    @available(iOS 14.0, *)
    public func willDisplayContextMenuWithConfigurationAndAnimator(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplayContextMenu:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let configuration: UIContextMenuConfiguration = paramter![0] as! UIContextMenuConfiguration
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2 {
                    animator = paramter![1] as? UIContextMenuInteractionAnimating
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }

    @available(iOS 14.0, *)
    public func willEndContextMenuInteractionWithConfigurationAndAnimator(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willEndContextMenuInteraction:animator:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 1 {
                let configuration: UIContextMenuConfiguration = paramter![0] as! UIContextMenuConfiguration
                var animator: UIContextMenuInteractionAnimating? = nil
                if paramter?.count ?? 0 >= 2 {
                    animator = paramter![1] as? UIContextMenuInteractionAnimating
                }
                action(configuration, animator)
            }
            return nil
        })
        return self
    }
}
