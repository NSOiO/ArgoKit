//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class List<T>: ScrollView where T : ArgoKitIdentifiable {
    
    private var tableNode: ArgoKitTableNode {
        pNode as! ArgoKitTableNode
    }
    
    private init(style: UITableView.Style?) {
        super.init()
        tableNode.style = style ?? .plain
    }
    
    public convenience init(style: UITableView.Style? = .plain, @ArgoKitListBuilder content: @escaping () -> View) {
        self.init(style: style)
        let container = content()
        if let nodes = container.type.viewNodes() {
            tableNode.dataSourceHelper.dataList = [nodes]
        }
    }

    public convenience init(_ style: UITableView.Style? = .plain, data: [T], @ArgoKitListBuilder rowContent: @escaping (T) -> View) {
        self.init(style: style)
        tableNode.dataSourceHelper.dataList = [data]
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    public convenience init(_ style: UITableView.Style? = .plain, sectionData: [[T]], @ArgoKitListBuilder rowContent: @escaping (T) -> View) {
        self.init(style: style)
        tableNode.dataSourceHelper.dataList = sectionData
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    override func createNode() {
        pNode = ArgoKitTableNode(viewClass: UITableView.self)
        pNode?.flexGrow(1.0)
    }
}

extension List {
    
    public func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        tableNode.selectionStyle = value
        return self
    }
    
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
    
    public func tableHeaderView(@ArgoKitViewBuilder headerContent: @escaping () -> View) -> Self {
        let container = headerContent()
        tableNode.tableHeaderNode = container.type.viewNode()
        return self
    }
    
    public func tableFooterView(@ArgoKitViewBuilder footerContent: @escaping () -> View) -> Self {
        let container = footerContent()
        tableNode.tableFooterNode = container.type.viewNode()
        return self
    }
    
    public func sectionHeader(_ data: [T], @ArgoKitListBuilder headerContent: @escaping (T) -> View) -> Self {
        tableNode.sectionHeaderSourceHelper.dataList = [data]
        tableNode.sectionHeaderSourceHelper.buildNodeFunc = { item in
            return headerContent(item as! T)
        }
        return self
    }
    
    public func sectionFooter(_ data: [T], @ArgoKitListBuilder footerContent: @escaping (T) -> View) -> Self {
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
    
    public func reloadData() {
        tableNode.reloadData()
    }
    
    public func reloadData(data:[T], sectionHeaderData: T? = nil, sectionFooterData: T? = nil) {
        tableNode.reloadData(data: [data], sectionHeaderData: (sectionHeaderData != nil) ? [sectionHeaderData!] : nil, sectionFooterData: (sectionFooterData != nil) ? [sectionFooterData!] : nil)
    }
    
    public func reloadData(sectionData:[[T]], sectionHeaderData: [T]? = nil, sectionFooterData: [T]? = nil) {
        tableNode.reloadData(data: sectionData, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData)
    }
    
    public func appendSections(_ data: [[T]], sectionHeaderData: [T]? = nil, sectionFooterData: [T]? = nil, with animation: UITableView.RowAnimation) {
        tableNode.appendSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, with: animation)
    }
    
    public func insertSections(_ data: [[T]], sectionHeaderData: [T]? = nil, sectionFooterData: [T]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableNode.insertSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, at: sections, with: animation)
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableNode.deleteSections(sections, with: animation)
    }
    
    public func moveSection(_ section: Int, toSection newSection: Int) {
        tableNode.moveSection(section, toSection: newSection)
    }
    
    public func appendRows(_ rowData: [T], at section: Int = 0, with animation: UITableView.RowAnimation) {
        tableNode.appendRows(rowData, at: section, with: animation)
    }
    
    public func insertRows(_ rowData: [T], at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableNode.insertRows(rowData, at: indexPaths, with: animation)
    }
    
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableNode.deleteRows(at: indexPaths, with: animation)
    }
        
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableNode.moveRow(at: indexPath, to: newIndexPath)
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
    
    public func canEditRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canEditRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    public func canMoveRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canMoveRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return true
        })
        return self
    }
    
    public func titlesForSection(_ value: [String]?) -> Self {
        tableNode.titlesForSection = value;
        return self
    }
    
    public func commitEditingRow(_ action: @escaping (_ editingStyle: UITableViewCell.EditingStyle, _ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:commit:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let editingStyle: UITableViewCell.EditingStyle = paramter![0] as! UITableViewCell.EditingStyle
                let data: T? = paramter![1] as? T
                let indexPath: IndexPath = paramter![2] as! IndexPath
                action(editingStyle, data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func moveRow(_ action: @escaping (_ sourceData: T?, _ destinationData: T?, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:moveRowAt:to:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4 {
                let sourceData: T? = paramter![0] as? T
                let destinationData: T? = paramter![1] as? T
                let sourceIndexPath: IndexPath = paramter![2] as! IndexPath
                let destinationIndexPath: IndexPath = paramter![3] as! IndexPath
                action(sourceData, destinationData, sourceIndexPath, destinationIndexPath)
            }
            return nil
        })
        return self
    }
}

extension List {
    
    public func prefetchRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
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
    
    public func cancelPrefetchingRows(_ action: @escaping (_ indexPaths: [IndexPath]) -> Void) -> Self {
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
    
    public func willDisplayRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplay:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func willDisplayHeaderView(_ action: @escaping (_ data: T, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplayHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T = paramter![0] as! T
                let section: Int = paramter![1] as! Int
                action(data, section)
            }
            return nil
        })
        return self
    }

    public func willDisplayFooterView(_ action: @escaping (_ data: T, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDisplayFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T = paramter![0] as! T
                let section: Int = paramter![1] as! Int
                action(data, section)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplaying:forRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingHeaderView(_ action: @escaping (_ data: T, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplayingHeaderView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T = paramter![0] as! T
                let section: Int = paramter![1] as! Int
                action(data, section)
            }
            return nil
        })
        return self
    }

    public func didEndDisplayingFooterView(_ action: @escaping (_ data: T, _ section: Int) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndDisplayingFooterView:forSection:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T = paramter![0] as! T
                let section: Int = paramter![1] as! Int
                action(data, section)
            }
            return nil
        })
        return self
    }
    
    public func shouldHighlightRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return true
        })
        return self
    }

    public func didHighlightRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didHighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func didUnhighlightRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didUnhighlightRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func willSelectRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func willDeselectRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func didSelectRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didSelectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T = paramter![0] as! T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            } else if paramter?.count ?? 0 >= 1 {
                let indexPath: IndexPath = paramter![0] as! IndexPath
                action(nil, indexPath)
            }
            return nil
        })
        return self
    }

    public func didDeselectRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didDeselectRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    public func editingStyle(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:editingStyleForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func titleForDeleteConfirmationButton(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> String?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }
    
    @available(iOS, introduced: 8.0, deprecated: 13.0)
    public func editActions(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> [ListRowAction]?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:editActionsForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 11.0, *)
    public func leadingSwipeActions(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 11.0, *)
    public func trailingSwipeActions(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> ListSwipeActionsConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func shouldIndentWhileEditingRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldIndentWhileEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func willBeginEditingRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:willBeginEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func didEndEditingRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didEndEditingRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            } else {
                action(nil, nil)
            }
            return nil
        })
        return self
    }

    public func targetIndexPathForMove(_ action: @escaping (_ sourceData: T?, _ proposedDestinationData: T?, _ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 4 {
                let sourceData: T? = paramter![0] as? T
                let destinationData: T? = paramter![1] as? T
                let sourceIndexPath: IndexPath = paramter![2] as! IndexPath
                let proposedDestinationIndexPath: IndexPath = paramter![3] as! IndexPath
                return action(sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath)
            }
            return nil
        })
        return self
    }

    public func indentationLevel(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Int) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:indentationLevelForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func shouldShowMenu(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldShowMenuForRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func canPerformAction(_ action: @escaping (_ action: Selector, _ data: T?, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canPerformAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let act: Selector = paramter![0] as! Selector
                let data: T? = paramter![1] as? T
                let indexPath: IndexPath = paramter![2] as! IndexPath
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4 {
                    sender = paramter![2]
                }
                return action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    public func performAction(_ action: @escaping (_ action: Selector, _ data: T?, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:performAction:forRowAt:withSender:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let act: Selector = paramter![0] as! Selector
                let data: T? = paramter![1] as? T
                let indexPath: IndexPath = paramter![2] as! IndexPath
                var sender: Any? = nil
                if paramter?.count ?? 0 >= 4 {
                    sender = paramter![3]
                }
                action(act, data, indexPath, sender)
            }
            return nil
        })
        return self
    }

    public func canFocusRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:canFocusRowAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    public func shouldUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
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

    public func didUpdateFocus(_ action: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
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
    public func shouldSpringLoadRow(_ action: @escaping (_ data: T?, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldSpringLoadRowAt:with:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                let context: UISpringLoadedInteractionContext = paramter![2] as! UISpringLoadedInteractionContext
                return action(data, indexPath, context)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func shouldBeginMultipleSelectionInteraction(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Bool) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func didBeginMultipleSelectionInteraction(_ action: @escaping (_ data: T?, _ indexPath: IndexPath) -> Void) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:didBeginMultipleSelectionInteractionAt:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 2 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                return action(data, indexPath)
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
    public func contextMenuConfiguration(_ action: @escaping (_ data: T?, _ indexPath: IndexPath, _ point: CGPoint) -> UIContextMenuConfiguration?) -> Self {
        let sel = #selector(ArgoKitTableNode.tableView(_:contextMenuConfigurationForRowAt:point:))
        node?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            
            if paramter?.count ?? 0 >= 3 {
                let data: T? = paramter![0] as? T
                let indexPath: IndexPath = paramter![1] as! IndexPath
                let point: CGPoint = paramter![2] as! CGPoint
                return action(data, indexPath, point)
            }
            return nil
        })
        return self
    }

    @available(iOS 13.0, *)
    public func previewForHighlightingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
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
    public func previewForDismissingContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration) -> UITargetedPreview?) -> Self {
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
    public func willPerformPreviewAction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionCommitAnimating) -> Void) -> Self {
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
    public func willDisplayContextMenu(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
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
    public func willEndContextMenuInteraction(_ action: @escaping (_ configuration: UIContextMenuConfiguration, _ animator: UIContextMenuInteractionAnimating?) -> Void) -> Self {
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
