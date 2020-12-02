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

class ArgoKitTableNode: ArgoKitScrollViewNode, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.zero
    }
    lazy var dataSourceHelper = ArgoKitDataSourceHelper()
    lazy var sectionHeaderSourceHelper = ArgoKitDataSourceHelper()
    lazy var sectionFooterSourceHelper = ArgoKitDataSourceHelper()
    
    public var style: UITableView.Style = .plain
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var tableView: UITableView? {
        
        if let tableView = self.view as? UITableView {
            return tableView
        }
        return nil
    }
    
    public var tableHeaderNode: ArgoKitNode?
    public var tableFooterNode: ArgoKitNode?
    
    public var titlesForHeaderInSection: [Int: String]?
    public var titlesForFooterInSection: [Int: String]?
    public var titlesForSection: [String]?
        
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let tableView = UITableView(frame: frame, style: style)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        if tableHeaderNode != nil {
            tableHeaderNode?.applyLayout()
            tableView.tableHeaderView = tableHeaderNode?.view
        }
        if tableFooterNode != nil {
            tableFooterNode?.applyLayout()
            tableView.tableFooterView = tableFooterNode?.view
        }
        tableView.separatorStyle = .none;
        return tableView
    }
}

extension ArgoKitTableNode {
    
    public func reloadData() {
        self.tableView?.reloadData()
    }
    
    public func reloadData(data:[[Any]], sectionHeaderData: [Any]? = nil, sectionFooterData: [Any]? = nil) {
        self.dataSourceHelper.dataList = data
        if sectionHeaderData != nil {
            self.sectionHeaderSourceHelper.dataList = [sectionHeaderData!]
        }
        if sectionFooterData != nil {
            self.sectionFooterSourceHelper.dataList = [sectionFooterData!]
        }
        self.tableView?.reloadData()
    }
    
    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.tableView?.reloadSections(sections, with: animation)
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.tableView?.reloadRows(at: indexPaths, with: animation)
    }
    
    public func appendSections(_ data: [[Any]], sectionHeaderData: [Any]? = nil, sectionFooterData: [Any]? = nil, with animation: UITableView.RowAnimation) {
        
        let start = self.dataSourceHelper.dataList?.count ?? 0
        let end = start + data.count
        for data in data {
            self.dataSourceHelper.appendSection(data)
        }
        if sectionHeaderData != nil {
            for data in sectionHeaderData! {
                self.sectionHeaderSourceHelper.appendRow(rowData: data, at: 0)
            }
        }
        if sectionFooterData != nil {
            for data in sectionFooterData! {
                self.sectionFooterSourceHelper.appendRow(rowData: data, at: 0)
            }
        }
        self.tableView?.insertSections(IndexSet(start..<end), with: animation)
    }
    
    public func insertSections(_ sectionData: [[Any]], sectionHeaderData: [Any]? = nil, sectionFooterData: [Any]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation) {
                
        for (index, value) in sections.enumerated() {
            self.dataSourceHelper.insertSection(data: sectionData[index], section: value)
            
            if sectionHeaderData != nil {
                self.sectionHeaderSourceHelper.insertRow(rowData: sectionHeaderData![index], row: value, at: 0)
            }
            if sectionFooterData != nil {
                self.sectionFooterSourceHelper.insertRow(rowData: sectionFooterData![index], row: value, at: 0)
            }
        }

        self.tableView?.insertSections(sections, with: animation)
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        
        for index in sections {
            self.dataSourceHelper.deleteSection(index)
        }
        self.tableView?.deleteSections(sections, with: animation)
    }
    
    public func moveSection(_ section: Int, toSection newSection: Int) {
        
        self.dataSourceHelper.moveSection(section, toSection: newSection)
        self.tableView?.moveSection(section, toSection: newSection)
    }
    
    public func appendRows(_ rowData: [Any], at section: Int = 0, with animation: UITableView.RowAnimation) {
        
        var start = 0
        if section > self.dataSourceHelper.dataList?.count ?? 0 {
            start = self.dataSourceHelper.dataList?.count ?? 0
        } else {
            start = self.dataSourceHelper.dataList?[section].count ?? 0
        }
        var indesPaths = [IndexPath]()
        for (index, data) in rowData.enumerated() {
            indesPaths.append(IndexPath(row: start + index, section: section))
            self.dataSourceHelper.appendRow(rowData: data, at: section)
        }
        self.tableView?.insertRows(at: indesPaths, with: animation)
    }
    
    public func insertRows(_ rowData: [Any], at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {

        for (index, indexPath) in indexPaths.enumerated() {
            self.dataSourceHelper.insertRow(rowData: rowData[index], row: indexPath.row, at: indexPath.section)
        }
        self.tableView?.insertRows(at: indexPaths, with: animation)
    }
    
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        
        for indexPath in indexPaths {
            self.dataSourceHelper.deleteRow(indexPath.row, at: indexPath.section)
        }
        self.tableView?.deleteRows(at: indexPaths, with: animation)
    }
    
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        
        self.dataSourceHelper.moveRow(at: indexPath, to: newIndexPath)
        self.tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
    
    public func reloadRowsHeight() {
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}

extension ArgoKitTableNode {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataSourceHelper.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataSourceHelper.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = self.dataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kCellReuseIdentifier
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(ArgoKitListCell.self, forCellReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ArgoKitListCell
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.selectionStyle = selectionStyle
            cell.linkCellNode(node)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titlesForHeaderInSection?[section]
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titlesForFooterInSection?[section]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:canEditRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool {
            return result
        }
        return false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:canMoveRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool {
            return result
        }
        return false
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titlesForSection
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:commit:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [editingStyle, data, indexPath])
        if editingStyle == .delete {
            self.dataSourceHelper.deleteRow(indexPath.row, at: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceData = self.dataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) ?? NSNull()
        let destinationData = self.dataSourceHelper.dataForRow(destinationIndexPath.row, at: destinationIndexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:moveRowAt:to:))
        self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, destinationIndexPath])
        self.dataSourceHelper.moveRow(at: sourceIndexPath, to: destinationIndexPath)
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
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:willDisplay:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let node = self.sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        let data = self.sectionHeaderSourceHelper.dataForRow(section, at: 0)
        let sel = #selector(self.tableView(_:willDisplayHeaderView:forSection:))
        if data != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [data!, section])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [section])
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let node = self.sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        let data = self.sectionFooterSourceHelper.dataForRow(section, at: 0)
        let sel = #selector(self.tableView(_:willDisplayFooterView:forSection:))
        if data != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [data!, section])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [section])
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.removeObservingFrameChanged()
        }
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didEndDisplaying:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let node = self.sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            node.removeObservingFrameChanged()
        }
        let data = self.sectionHeaderSourceHelper.dataForRow(section, at: 0)
        let sel = #selector(self.tableView(_:didEndDisplayingHeaderView:forSection:))
        if data != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [data!, section])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [section])
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let node = self.sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            node.removeObservingFrameChanged()
        }
        let data = self.sectionFooterSourceHelper.dataForRow(section, at: 0)
        let sel = #selector(self.tableView(_:didEndDisplayingFooterView:forSection:))
        if data != nil {
            self.sendAction(withObj: String(_sel: sel), paramter: [data!, section])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [section])
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionHeaderSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionFooterSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let identifier = "Header" + (self.sectionHeaderSourceHelper.reuseIdForRow(section, at: 0) ?? kHeaderReuseIdentifier)
        if !self.sectionHeaderSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(ArgoKitListHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            self.sectionHeaderSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! ArgoKitListHeaderFooterView
        if let node = sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            header.linkCellNode(node)
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let identifier = "Footer" + (self.sectionFooterSourceHelper.reuseIdForRow(section, at: 0) ?? kFooterReuseIdentifier)
        if !self.sectionFooterSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(ArgoKitListHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            self.sectionFooterSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! ArgoKitListHeaderFooterView
        if let node = sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            footer.linkCellNode(node)
        }
        return footer
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:shouldHighlightRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didHighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didUnhighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:willSelectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:willDeselectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didSelectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didDeselectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:editingStyleForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UITableViewCell.EditingStyle ?? .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? String ?? "Delete"
    }

    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:editActionsForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? [UITableViewRowAction]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:shouldIndentWhileEditingRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:willBeginEditingRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let sel = #selector(self.tableView(_:didEndEditingRowAt:))
        if indexPath != nil {
            let data = self.dataSourceHelper.dataForRow(indexPath!.row, at: indexPath!.section) ?? NSNull()
            self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath!])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: nil)
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sourceData = self.dataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) ?? NSNull()
        let destinationData = self.dataSourceHelper.dataForRow(proposedDestinationIndexPath.row, at: proposedDestinationIndexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath]) as? IndexPath ?? proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:indentationLevelForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Int ?? 0
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:shouldShowMenuForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:canPerformAction:forRowAt:withSender:))
        if let s_sender = sender {
            return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender]) as? Bool ?? false
        }
        return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:performAction:forRowAt:withSender:))
        if let s_sender = sender {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath])
        }
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:canFocusRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
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
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:shouldSpringLoadRowAt:with:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath, context]) as? Bool ?? true
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:didBeginMultipleSelectionInteractionAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    @available(iOS 13.0, *)
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        let sel = #selector(self.tableViewDidEndMultipleSelectionInteraction(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: nil)
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) ?? NSNull()
        let sel = #selector(self.tableView(_:contextMenuConfigurationForRowAt:point:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath, point]) as? UIContextMenuConfiguration
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
