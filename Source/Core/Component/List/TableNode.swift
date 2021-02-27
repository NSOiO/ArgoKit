//
//  ArgoKitTableNode.swift
//  ArgoKitfont
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

fileprivate let kCellReuseIdentifier = "ArgoKitListCell"
fileprivate let kHeaderReuseIdentifier = "ArgoKitListHeaderView"
fileprivate let kFooterReuseIdentifier = "ArgoKitListFooterView"
class TableView:UITableView{
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
    var hitTestAction:(()->())?
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            if let action = reLayoutAction {
                action(self.bounds)
            }
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitTestAction = hitTestAction {
            hitTestAction()
        }
        return super.hitTest(point, with: event)
    }
}

class TableNode<D>: ArgoKitScrollViewNode,
                    UITableViewDelegate,
                    UITableViewDataSource,
                    UITableViewDataSourcePrefetching,
                    DataSourceReloadNode {
    
    deinit {
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
    
    lazy var dataSourcePrefetchHelper:DataSourcePrefetchHelper<D> = DataSourcePrefetchHelper<D>()
    
    lazy var dataSourceHelper: DataSourceHelper<D> = {[weak self] in
        let _dataSourceHelper = DataSourceHelper<D>()
        _dataSourceHelper._rootNode = self
        _dataSourceHelper.dataSourceType = .body
        return _dataSourceHelper
    }()
    
    lazy var sectionHeaderSourceHelper:DataSourceHelper<D> = {[weak self] in
        let _dataSourceHelper = DataSourceHelper<D>()
        _dataSourceHelper._rootNode = self
        _dataSourceHelper.dataSourceType = .header
        return _dataSourceHelper
    }()
    lazy var sectionFooterSourceHelper :DataSourceHelper<D> = {[weak self] in
        let _dataSourceHelper = DataSourceHelper<D>()
        _dataSourceHelper._rootNode = self
        _dataSourceHelper.dataSourceType = .footer
        return _dataSourceHelper
    }()
    
    var needLoadNodes: NSMutableArray = NSMutableArray()
    var scrollToToping: Bool = false
    
    public var style: UITableView.Style = .plain
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    public weak var tableView: UITableView?
    public var tableHeaderNode: ArgoKitNode?{
        didSet{
            if let tableView = self.tableView {
                if let tableHeaderNode_ = tableHeaderNode {
                    tableHeaderNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
                    tableView.tableHeaderView = tableHeaderNode_.view
                }else{
                    tableView.tableHeaderView = nil
                }
                tableView.reloadData()
            }
        }
    }
    public var tableFooterNode: ArgoKitNode?{
        didSet{
            if let tableView = self.tableView {
                if let tableFooterNode_ = tableFooterNode {
                    tableFooterNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
                    tableView.tableFooterView = tableFooterNode_.view
                }else{
                    tableView.tableFooterView = nil
                }
                tableView.reloadData()
            }
        }
    }
    public var sectionIndexTitles: [String]?
    
    public var estimatedHeight:CGFloat = -1.0
    
    public var maxWith:CGFloat = UIScreen.main.bounds.width
    
    var observation:NSKeyValueObservation?
        
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let tableView = TableView(frame: frame, style: style)
        maxWith = frame.width
        self.tableView = tableView
        if defaultViewHeight == 0 {
            defaultViewHeight = frame.height
            defaultFlexGrow = self.flexGrow()
        }
       
        tableView.reLayoutAction = { [weak self] frame in
            if let `self` = self {
                var cellNodes:[Any] = []
                cellNodes.append(contentsOf: self.dataSourceHelper.cellNodeCache)
                cellNodes.append(contentsOf: self.sectionHeaderSourceHelper.cellNodeCache)
                cellNodes.append(contentsOf: self.sectionFooterSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(cellNodes, frame: frame)
            }
        }
//        tableView.hitTestAction = {[weak self] in
//            self?._hitTest()
//        }
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        if let tableHeaderNode_ = tableHeaderNode {
            tableHeaderNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
            tableView.tableHeaderView = tableHeaderNode_.view
        }
        if let tableFooterNode_ = tableFooterNode {
            tableFooterNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
            tableView.tableFooterView = tableFooterNode_.view
        }
        tableView.separatorStyle = .none;
        if let preview = ArgoKitInstance.listPreviewService() {
            preview.register(table: tableView, coordinator: self)
        }
        
        observation = tableView.observe(\TableView.contentSize, options: [.new, .old], changeHandler: {[weak self] (tableview, change) in
            if let `self` = self,
               let old = change.oldValue,
               let new = change.newValue{
                if !new.equalTo(old) {
                    self.setContentSizeViewHeight(new.height)
               }
            }
        })

        return tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataSourceHelper.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataSourceHelper.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.dataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kCellReuseIdentifier
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(ListCell.self, forCellReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ListCell
        if needLoadNodes.count > 0 && needLoadNodes.index(of: indexPath) == NSNotFound {
            return cell
        }
        if scrollToToping {
            return cell
        }
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.selectionStyle = selectionStyle
            cell.linkCellNode(node)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:canEditRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool {
            return result
        }
        return false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:canMoveRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool {
            return result
        }
        return false
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:commit:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [editingStyle, data, indexPath])
        if editingStyle == .delete {
            self.dataSourceHelper.deleteRow(indexPath,with:.automatic)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceData = self.dataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) else {
            return
        }
        guard let destinationData = self.dataSourceHelper.dataForRow(destinationIndexPath.row, at: destinationIndexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:moveRowAt:to:))
        self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, destinationIndexPath])
        self.dataSourceHelper.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let prefetchModel:DataSourcePrefetchModel<D> = DataSourcePrefetchModel<D>(self.dataSourceHelper,indexPaths:indexPaths)
//        prefetchModel.width = tableView.bounds.width
//        dataSourcePrefetchHelper.addPrefetchModel(prefetchModel)
        let sel = #selector(self.tableView(_:prefetchRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:cancelPrefetchingForRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplay:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let node = self.sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        guard let data = self.sectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let node = self.sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        guard let data = self.sectionFooterSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.removeObservingFrameChanged()
        }
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didEndDisplaying:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let node = self.sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            node.removeObservingFrameChanged()
        }
        guard let data = self.sectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:didEndDisplayingHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let node = self.sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            node.removeObservingFrameChanged()
        }
        guard let data = self.sectionFooterSourceHelper.dataForRow(section, at: 0)  else {
            return
        }
        let sel = #selector(self.tableView(_:didEndDisplayingFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if estimatedHeight <= 0 {
//            estimatedHeight = self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
//        }
//        if estimatedHeight <= 100 {
//            return 100
//        }
//        return estimatedHeight
//    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionHeaderSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionFooterSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let identifier = "Header" + (self.sectionHeaderSourceHelper.reuseIdForRow(section, at: 0) ?? kHeaderReuseIdentifier)
        if !self.sectionHeaderSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            self.sectionHeaderSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HeaderFooterView
        if let node = sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            header.linkCellNode(node)
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let identifier = "Footer" + (self.sectionFooterSourceHelper.reuseIdForRow(section, at: 0) ?? kFooterReuseIdentifier)
        if !self.sectionFooterSourceHelper.registedReuseIdSet.contains(identifier) {
            tableView.register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            self.sectionFooterSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HeaderFooterView
        if let node = sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            footer.linkCellNode(node)
        }
        return footer
    }
    

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldHighlightRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didHighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didUnhighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return indexPath
        }
        let sel = #selector(self.tableView(_:willSelectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return indexPath
        }
        let sel = #selector(self.tableView(_:willDeselectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didSelectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didDeselectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return .delete
        }
        let sel = #selector(self.tableView(_:editingStyleForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UITableViewCell.EditingStyle ?? .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return "Delete"
        }
        let sel = #selector(self.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? String ?? "Delete"
    }

    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.tableView(_:editActionsForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? [UITableViewRowAction]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.tableView(_:leadingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.tableView(_:trailingSwipeActionsConfigurationForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldIndentWhileEditingRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:willBeginEditingRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let sel = #selector(self.tableView(_:didEndEditingRowAt:))
        if indexPath != nil {
            guard let data = self.dataSourceHelper.dataForRow(indexPath!.row, at: indexPath!.section) else {
                return
            }
            self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath!])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: nil)
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let sourceData = self.dataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) else {
            return proposedDestinationIndexPath
        }
        guard let destinationData = self.dataSourceHelper.dataForRow(proposedDestinationIndexPath.row, at: proposedDestinationIndexPath.section) else {
            return proposedDestinationIndexPath
        }
        let sel = #selector(self.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath]) as? IndexPath ?? proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return 0
        }
        let sel = #selector(self.tableView(_:indentationLevelForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Int ?? 0
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:shouldShowMenuForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:canPerformAction:forRowAt:withSender:))
        if let s_sender = sender {
            return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender]) as? Bool ?? false
        }
        return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:performAction:forRowAt:withSender:))
        if let s_sender = sender {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath])
        }
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
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
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldSpringLoadRowAt:with:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath, context]) as? Bool ?? true
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
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
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
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
    
    
    override func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let models:[(D,UITableViewCell)] = self.visibleModelCells()
        let sel = #selector(self.scrollViewDidEndScroll(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [models,scrollView])
        self._scrollViewDidEndScroll(scrollView)
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self._scrollViewShouldScrollToTop(scrollView)
        return super.scrollViewShouldScrollToTop(scrollView)
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        super.scrollViewDidScrollToTop(scrollView)
        self._scrollViewDidScrollToTop(scrollView)
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDecelerating(scrollView)
        self._scrollViewDidEndScroll(scrollView)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDragging(scrollView)
        self._scrollViewWillBeginDragging(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        super.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        self._scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

extension TableNode{
    public func visibleModelCells() -> [(D,UITableViewCell)] {
        var models:[(D,UITableViewCell)] = []
        if let tableView = self.tableView{
            let cells = tableView.visibleCells
            for cell in cells {
                if let indexPath = tableView.indexPath(for: cell){
                    if let model = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
                        models.append((model,cell))
                    }
                }
            }
        }

        return models
    }
    
    public func visibleModels() -> [D] {
        var models:[D] = []
        if let tableView = self.tableView{
            let cells = tableView.visibleCells
            for cell in cells {
                if let indexPath = tableView.indexPath(for: cell){
                    if let model = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
                        models.append(model)
                    }
                }
            }
        }
        return models
    }
}

extension TableNode {
    
    public func reloadData() {
        if let tableView = self.tableView {
            tableView.reloadData()
        }
    }
    
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.insertSections(sections, with: animation)
        }
    }

    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.deleteSections(sections, with: animation)
        }
    }

    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.reloadSections(sections, with: animation)
        }
    }

    public func moveSection(_ section: Int, toSection newSection: Int) {
        if let tableView = self.tableView {
            tableView.moveSection(section, toSection: newSection)
        }
    }

    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.insertRows(at:indexPaths, with: animation)
        }
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.deleteRows(at:indexPaths, with: animation)
        }
    }
    
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.deleteRows(at:[indexPath],with: animation)
        }
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.tableView {
            tableView.reloadRows(at:indexPaths, with: animation)
        }
    }

    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        if let tableView = self.tableView {
            tableView.moveRow(at:indexPath, to: newIndexPath)
        }
    }

    public func reloadRowsHeight() {
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
    func removeNode(_ node:Any?){
        dataSourceHelper.removeNode(node)
        sectionHeaderSourceHelper.removeNode(node)
        sectionFooterSourceHelper.removeNode(node)
    }
    func removeAll(){
        dataSourceHelper.removeAll()
        sectionHeaderSourceHelper.removeAll()
        sectionFooterSourceHelper.removeAll()
    }
}

extension TableNode{
    func createNodeFromData(_ data: Any,helper:Any) {
        if let datasource = helper as? DataSource<DataList<D>> {

            if datasource.type == .body {
                dataSourceHelper.rowHeight(data, maxWidth: maxWith)
            }
            if datasource.type == .header {
                sectionHeaderSourceHelper.rowHeight(data, maxWidth: maxWith)
            }

            if datasource.type == .footer {
                sectionFooterSourceHelper.rowHeight(data, maxWidth:maxWith)
            }
        }

        if let datasource = helper as? DataSource<SectionDataList<D>> {

            if datasource.type == .body {
                dataSourceHelper.rowHeight(data, maxWidth: maxWith)
            }
            if datasource.type == .header {
                sectionHeaderSourceHelper.rowHeight(data, maxWidth: maxWith)
            }

            if datasource.type == .footer {
                sectionFooterSourceHelper.rowHeight(data, maxWidth:maxWith)
            }
        }
    }
}


extension TableNode{
    func loadCellContent(){
        if scrollToToping {
            return
        }
        if let tableView = self.view as? UITableView,
           let rows = tableView.indexPathsForVisibleRows,
           rows.count > 0{
            if tableView.visibleCells.count > 0{
                for cell in tableView.visibleCells {
                    if let cell_ = cell as? ListCell,let indexPath = tableView.indexPath(for: cell_) {
                        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
                            cell_.linkCellNode(node)
                        }
                    }
                }
            }
            
        }
    }
    
    func _hitTest(){
        if !scrollToToping {
            needLoadNodes .removeAllObjects()
            self.loadCellContent()
        }
    }
    func _scrollViewShouldScrollToTop(_ scrollView: UIScrollView) {
        scrollToToping = true
    }
    
    func _scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        scrollToToping = false
        self.loadCellContent()
    }
    
    func _scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollToToping = false
        self.loadCellContent()
    }
    
    func _scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        needLoadNodes.removeAllObjects()
    }
    func _scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        print("_scrollViewWillEndDragging")
        if let tableView = scrollView as? UITableView,let dataSource = self.dataSourceHelper.dataSourceList?.dataSource {
            let indexPathInPoint = tableView.indexPathForRow(at: CGPoint(x: 0, y: targetContentOffset.pointee.y))
            let cellInPoint = tableView.indexPathsForVisibleRows?.first
            let skipCount = 8
            if let cip = cellInPoint,
               let ip = indexPathInPoint,
               labs(cip.row - ip.row) > skipCount{
                if let temp = tableView.indexPathsForRows(in: CGRect(x: 0, y: targetContentOffset.pointee.y, width: tableView.frame.width, height: tableView.frame.height)){
                    var arr:[IndexPath] = []
                    arr.append(contentsOf: temp)
                    if velocity.y < 0,let indexPath = temp.last {
                        if indexPath.row + 3 < dataSource.count {
                            arr.append(IndexPath(row: indexPath.row + 1, section: indexPath.section))
                            arr.append(IndexPath(row: indexPath.row + 2, section: indexPath.section))
                            arr.append(IndexPath(row: indexPath.row + 3, section: indexPath.section))
                        }
                       
                    }else if velocity.y >= 0,let indexPath = temp.first{
                        if indexPath.row > 3 {
                            arr.append(IndexPath(row: indexPath.row - 3, section: indexPath.section))
                            arr.append(IndexPath(row: indexPath.row - 2, section: indexPath.section))
                            arr.append(IndexPath(row: indexPath.row - 1, section: indexPath.section))
                        }
                    }
                    needLoadNodes.addObjects(from: arr)
                }
            }
        }
        
    }
}
