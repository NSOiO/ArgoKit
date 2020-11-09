//
//  ArgoKitTableNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

fileprivate let kCellReuseIdentifier = "ArgoKitListCell"
fileprivate let kHeaderReuseIdentifier = "ArgoKitListHeaderView"
fileprivate let kFooterReuseIdentifier = "ArgoKitListFooterView"

class ArgoKitTableNode: ArgoKitNode, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    lazy var dataSourceHelper = ArgoKitDataSourceHelper()
    lazy var sectionHeaderSourceHelper = ArgoKitDataSourceHelper()
    lazy var sectionFooterSourceHelper = ArgoKitDataSourceHelper()
    
    public var tableView: UITableView? {
        
        if let tableView = self.view as? UITableView {
            return tableView
        }
        return nil
    }
    
    public var tableHeaderNode: ArgoKitNode? {
        didSet {
            tableHeaderNode?.applyLayout()
            self.tableView?.tableHeaderView = tableHeaderNode?.view
        }
    }
    
    public var tableFooterNode: ArgoKitNode? {
        didSet {
            tableFooterNode?.applyLayout()
            self.tableView?.tableFooterView = tableFooterNode?.view
        }
    }
    
    public var titlesForHeaderInSection: [Int: String]?
    public var titlesForFooterInSection: [Int: String]?
    public var titlesForSection: [String]?
    
    override init(view: UIView) {
        super.init(view: view)
        if let tableView = view as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
            if #available(iOS 10.0, *) {
                tableView.prefetchDataSource = self
            }
//            tableView.register(ArgoKitListCell.self, forCellReuseIdentifier: kCellReuseIdentifier)
            tableView.register(ArgoKitListHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: kHeaderReuseIdentifier)
            tableView.register(ArgoKitListHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: kFooterReuseIdentifier)
        }
    }
}

extension ArgoKitTableNode {
    
    open func reloadData() {
        self.dataSourceHelper.removeAllCache()
        self.tableView?.reloadData()
    }
}

extension ArgoKitTableNode {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataSourceHelper.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataSourceHelper.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ArgoKitListCell? = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier) as? ArgoKitListCell
        var size = CGSize.zero
        if cell != nil{
            if let node = self.dataSourceHelper.nodeForRowAtSection(indexPath.row, at: indexPath.section) {
                ArgoKitNodeViewModifier.reuseNodeViewAttribute(cell?.contentNode?.childs as! [ArgoKitNode], reuse: [node])
            }
        }else{
            cell = ArgoKitListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: kCellReuseIdentifier)
            if let node = self.dataSourceHelper.nodeForRowAtSection(indexPath.row, at: indexPath.section) {
                cell?.linkCellNode(node)
            }
        }
        size = cell?.contentNode?.applyLayout(size: CGSize(width: tableView.frame.size.height,height: CGFloat(Float.nan))) ?? CGSize.zero
        let cacheKey = NSString(format: "cache_%d_%d", indexPath.section, indexPath.row)
        let height = self.dataSourceHelper.nodeCellCahe?.object(forKey: cacheKey)
        if height == nil{
            size = cell?.contentNode?.size ?? CGSize.zero
            let num = NSNumber(value: Float(size.height))
            self.dataSourceHelper.nodeCellCahe?.setObject(num, forKey: cacheKey)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlesForHeaderInSection?[section]
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titlesForFooterInSection?[section]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:canEditRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool {
            return result
        }
        return true
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:canMoveRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool {
            return result
        }
        return true
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titlesForSection
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:commit:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [editingStyle, indexPath])
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sel = #selector(self.tableView(_:moveRowAt:to:))
        self.sendAction(withObj: String(_sel: sel), paramter: [sourceIndexPath, destinationIndexPath])
    }
}

extension ArgoKitTableNode {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:prefetchRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:cancelPrefetchingForRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
}

extension ArgoKitTableNode {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:willDisplay:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let sel = #selector(self.tableView(_:willDisplayHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [section])
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let sel = #selector(self.tableView(_:willDisplayFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [section])
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didEndDisplaying:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        let sel = #selector(self.tableView(_:didEndDisplayingHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [section])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        let sel = #selector(self.tableView(_:didEndDisplayingFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [section])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cacheKey = NSString(format: "cache_%d_%d", indexPath.section, indexPath.row)
        if let num:NSNumber =  self.dataSourceHelper.nodeCellCahe?.object(forKey: cacheKey){
            if !num.floatValue.isNaN {
                return CGFloat(num.floatValue)
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = sectionHeaderSourceHelper.nodeForRowAtSection(section, at: 0)?.height() {
            if !height.isNaN {
                return height
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let height = sectionFooterSourceHelper.nodeForRowAtSection(section, at: 0)?.height() {
            if !height.isNaN {
                return height
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderReuseIdentifier) as! ArgoKitListHeaderFooterView
        if let node = sectionHeaderSourceHelper.nodeForRowAtSection(section, at: 0) {
            header.linkCellNode(node)
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: kFooterReuseIdentifier) as! ArgoKitListHeaderFooterView
        if let node = sectionFooterSourceHelper.nodeForRowAtSection(section, at: 0) {
            footer.linkCellNode(node)
        }
        return footer
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:shouldHighlightRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didHighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didUnhighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sel = #selector(self.tableView(_:willSelectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let sel = #selector(self.tableView(_:willDeselectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didSelectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didDeselectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let sel = #selector(self.tableView(_:editingStyleForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UITableViewCell.EditingStyle ?? .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let sel = #selector(self.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? String ?? "Delete"
    }

    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let sel = #selector(self.tableView(_:editActionsForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? [UITableViewRowAction]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sel = #selector(self.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UISwipeActionsConfiguration
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sel = #selector(self.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UISwipeActionsConfiguration
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:shouldIndentWhileEditingRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:willBeginEditingRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let sel = #selector(self.tableView(_:didEndEditingRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: (indexPath != nil) ? [indexPath!] : nil)
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sel = #selector(self.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [sourceIndexPath, proposedDestinationIndexPath]) as? IndexPath ?? proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let sel = #selector(self.tableView(_:indentationLevelForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Int ?? 0
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:shouldShowMenuForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let sel = #selector(self.tableView(_:canPerformAction:forRowAt:withSender:))
        if let s_sender = sender {
            return self.sendAction(withObj: String(_sel: sel), paramter: [action, indexPath, s_sender]) as? Bool ?? false
        }
        return self.sendAction(withObj: String(_sel: sel), paramter: [action, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let sel = #selector(self.tableView(_:performAction:forRowAt:withSender:))
        if let s_sender = sender {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, indexPath, s_sender])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, indexPath])
        }
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:canFocusRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool ?? false
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        let sel = #selector(self.tableView(_:shouldUpdateFocusIn:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [context]) as? Bool ?? false
    }

    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let sel = #selector(self.tableView(_:didUpdateFocusIn:with:))
        self.sendAction(withObj: String(_sel: sel), paramter: [context, coordinator])
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        let sel = #selector(self.indexPathForPreferredFocusedView(in:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? IndexPath
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        let sel = #selector(self.tableView(_:shouldSpringLoadRowAt:with:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath, context]) as? Bool ?? true
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        let sel = #selector(self.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? Bool ?? false
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        let sel = #selector(self.tableView(_:didBeginMultipleSelectionInteractionAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPath])
    }

    @available(iOS 13.0, *)
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        let sel = #selector(self.tableViewDidEndMultipleSelectionInteraction(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: nil)
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let sel = #selector(self.tableView(_:contextMenuConfigurationForRowAt:point:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [indexPath, point]) as? UIContextMenuConfiguration
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let sel = #selector(self.tableView(_:previewForHighlightingContextMenuWithConfiguration:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [configuration]) as? UITargetedPreview
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let sel = #selector(self.tableView(_:previewForDismissingContextMenuWithConfiguration:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [configuration]) as? UITargetedPreview
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let sel = #selector(self.tableView(_:willPerformPreviewActionForMenuWith:animator:))
        self.sendAction(withObj: String(_sel: sel), paramter: [configuration, animator])
    }

    @available(iOS 14.0, *)
    func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        let sel = #selector(self.tableView(_:willDisplayContextMenu:animator:))
        if let s_animator = animator {
            self.sendAction(withObj: String(_sel: sel), paramter: [configuration, s_animator])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [configuration])
        }
    }

    @available(iOS 14.0, *)
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        let sel = #selector(self.tableView(_:willEndContextMenuInteraction:animator:))
        if let s_animator = animator {
            self.sendAction(withObj: String(_sel: sel), paramter: [configuration, s_animator])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [configuration])
        }
    }
}
