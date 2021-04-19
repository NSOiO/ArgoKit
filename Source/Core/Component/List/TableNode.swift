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
    lazy var registedReuseIdSet = Set<String>()
    var cellCache:NSHashTable<ListCell> = NSHashTable<ListCell>.weakObjects()
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
    var hitTestAction:(()->())?
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !oldFrame.equalTo(self.frame) {
            if let action = reLayoutAction {
                action(self.bounds)
            }
            oldFrame = self.frame
        }
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
    
    var pDataSourceHelper: DataSourceHelper<D> = DataSourceHelper<D>()
    var pSectionHeaderSourceHelper:DataSourceHelper<D> = DataSourceHelper<D>()
    var pSectionFooterSourceHelper :DataSourceHelper<D> = DataSourceHelper<D>()
    
    var needLoadNodes: NSMutableArray = NSMutableArray()
    var scrollToToping: Bool = false
    
    public var style: UITableView.Style = .plain
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    public weak var tableView: UITableView?
    var headerNodeObservation:NSKeyValueObservation?
    var footerNodeObservation:NSKeyValueObservation?
    private func addFooterNodeObservation(_ obserNode:ArgoKitNode?){
        guard let obserNode = obserNode else {
            if let _ = footerNodeObservation {
                footerNodeObservation?.invalidate()
                footerNodeObservation = nil
            }
            return
        }
        if let _ = footerNodeObservation {
            footerNodeObservation?.invalidate()
            footerNodeObservation = nil
        }
        footerNodeObservation = obserNode.observe(\ArgoKitNode.frame, options: [.new, .old], changeHandler: {[weak self] (node, change) in
            if let `self` = self{
                self.addNodeObservation(change)
            }
        })
    }
    private func addHeaderNodeObservation(_ obserNode:ArgoKitNode?){
        guard let obserNode = obserNode else {
            if let _ = headerNodeObservation {
                headerNodeObservation?.invalidate()
                headerNodeObservation = nil
            }
            return
        }
        if let _ = headerNodeObservation {
            headerNodeObservation?.invalidate()
            headerNodeObservation = nil
        }
        headerNodeObservation = obserNode.observe(\ArgoKitNode.frame, options: [.new, .old], changeHandler: {[weak self] (node, change) in
            if let `self` = self{
                self.addNodeObservation(change)
            }
        })
    }
    private func addNodeObservation(_ change:NSKeyValueObservedChange<CGRect>){
        if let old = change.oldValue,
           let new = change.newValue{
            if !new.equalTo(old) {
                self.tableView?.reloadData()
           }
        }
    }
    public var tableHeaderNode: ArgoKitNode?{
        didSet{
            if let tableView = self.tableView {
                if let tableHeaderNode_ = tableHeaderNode {
                    tableHeaderNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
                    tableView.tableHeaderView = tableHeaderNode_.view
                    addHeaderNodeObservation(tableHeaderNode_)
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
                    addFooterNodeObservation(tableFooterNode_)
                }else{
                    tableView.tableFooterView = nil
                }
                tableView.reloadData()
            }
        }
    }
    public var estimatedRowHeight:CGFloat = UITableView.automaticDimension{
        didSet{
            if let tableView = self.tableView {
                tableView.estimatedRowHeight = estimatedRowHeight
            }
        }
    }
    public var sectionIndexTitles: [String]?
    
    
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
                cellNodes.append(contentsOf: self.pDataSourceHelper.cellNodeCache)
                cellNodes.append(contentsOf: self.pSectionHeaderSourceHelper.cellNodeCache)
                cellNodes.append(contentsOf: self.pSectionFooterSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(cellNodes, frame: frame)
            }
        }
        
        if estimatedRowHeight != UITableView.automaticDimension{
            tableView.estimatedRowHeight = estimatedRowHeight
        }
        
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
            addHeaderNodeObservation(tableHeaderNode_)
        }
        if let tableFooterNode_ = tableFooterNode {
            tableFooterNode_.applyLayout(size: CGSize(width: frame.size.width, height: CGFloat.nan))
            tableView.tableFooterView = tableFooterNode_.view
            addFooterNodeObservation(tableFooterNode_)
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
    
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        if let tableNode =  node as? TableNode,
           let tableView = view as? TableView {
            self.pDataSourceHelper = tableNode.dataSourceHelper
            self.pSectionHeaderSourceHelper = tableNode.sectionHeaderSourceHelper
            self.pSectionFooterSourceHelper = tableNode.sectionFooterSourceHelper
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.pDataSourceHelper.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.pDataSourceHelper.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.pDataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kCellReuseIdentifier
        if let tableView_ = tableView as? TableView,
           !tableView_.registedReuseIdSet.contains(identifier) {
            tableView.register(ListCell.self, forCellReuseIdentifier: identifier)
            tableView_.registedReuseIdSet.insert(identifier)
        }
        var isReuedCell = false
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ListCell
        if let tableView_ = tableView as? TableView{
            if tableView_.cellCache.contains(cell) {
                isReuedCell = true
            }else{
                isReuedCell = false
                tableView_.cellCache.add(cell)
            }
        }
        
        let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section)
        cell.sourceData = sourceData
        if let node = self.pDataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.selectionStyle = selectionStyle
            
            // FIX:处理插入数据是node被绑定到多个cell上
            if !isReuedCell && node.containView() {
                if  let sourceData_ = sourceData as? ArgoKitIdentifiable  {
                    sourceData_.argokit_linkNode  = nil
                    self.pDataSourceHelper.rowHeight(sourceData_, maxWidth: cell.frame.width)
                    if let node = self.pDataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section){
                        cell.linkCellNode(node,isReused:isReuedCell)
                    }
                }
            }else{
                cell.linkCellNode(node,isReused:isReuedCell)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:canEditRowAt:))
        if let result = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool {
            return result
        }
        return false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:commit:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [editingStyle, data, indexPath])
        if editingStyle == .delete {
            self.pDataSourceHelper.deleteRow(indexPath,with:.automatic)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceData = self.pDataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) else {
            return
        }
        guard let destinationData = self.pDataSourceHelper.dataForRow(destinationIndexPath.row, at: destinationIndexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:moveRowAt:to:))
        self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, destinationIndexPath])
        self.pDataSourceHelper.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:prefetchRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:cancelPrefetchingForRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let node = self.pDataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (cellNode, _) in
                print("cellNode:\(cellNode),height:\(cellNode.size)")
                self?.reloadRowsHeight()
            }
        }
        guard let listCell = cell as? ListCell, let data = listCell.sourceData else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplay:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let node = self.pSectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadSections([section], with: .none)
            }
        }
        guard let data = self.pSectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let node = self.pSectionFooterSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadSections([section], with: .none)
            }
        }
        guard let data = self.pSectionFooterSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let listCell = cell as? ListCell, let data = listCell.sourceData else {
            return
        }
        if let node = self.pDataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
        }
        let sel = #selector(self.tableView(_:didEndDisplaying:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
        listCell.sourceData = nil
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let data = self.pSectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        if let node = self.pSectionFooterSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
        }
        let sel = #selector(self.tableView(_:didEndDisplayingHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard let data = self.pSectionFooterSourceHelper.dataForRow(section, at: 0)  else {
            return
        }
        if let node = self.pSectionFooterSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
        }
        let sel = #selector(self.tableView(_:didEndDisplayingFooterView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return 0.0
        }
        let sel = #selector(self.tableView(_:heightForRowAt:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? CGFloat,
           height > 0{
            return height
        }
        let height = self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
        if height.isNaN {
            return 44
        }
        return self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.pSectionHeaderSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.pSectionFooterSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let identifier = "Header" + (self.pSectionHeaderSourceHelper.reuseIdForRow(section, at: 0) ?? kHeaderReuseIdentifier)
        if let tableView_ = tableView as? TableView,
            !tableView_.registedReuseIdSet.contains(identifier) {
            tableView.register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            tableView_.registedReuseIdSet.insert(identifier)
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HeaderFooterView
        if let node = sectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            header.linkCellNode(node)
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let identifier = "Footer" + (self.pSectionFooterSourceHelper.reuseIdForRow(section, at: 0) ?? kFooterReuseIdentifier)
        if let tableView_ = tableView as? TableView,
           !tableView_.registedReuseIdSet.contains(identifier) {
            tableView.register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            tableView_.registedReuseIdSet.insert(identifier)
        }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HeaderFooterView
        if let node = sectionFooterSourceHelper.nodeForRow(section, at: 0) {
            footer.linkCellNode(node)
        }
        return footer
    }
    

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldHighlightRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didHighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didUnhighlightRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return indexPath
        }
        let sel = #selector(self.tableView(_:willSelectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return indexPath
        }
        let sel = #selector(self.tableView(_:willDeselectRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? IndexPath ?? indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didSelectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:didDeselectRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return .delete
        }
        let sel = #selector(self.tableView(_:editingStyleForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UITableViewCell.EditingStyle ?? .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return "Delete"
        }
        let sel = #selector(self.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? String ?? "Delete"
    }

    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.tableView(_:editActionsForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? [UITableViewRowAction]
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.count != 2 {
            return nil
        }
        guard let dataSource = self.pDataSourceHelper.dataSource() else {
            return nil
        }
        
        if dataSource.count <= 0{
            return nil
        }
        
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let key:String = "argokit_tableView_leadingSwipe"
        return self.sendAction(withObj:key, paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.count != 2 {
            return nil
        }
        guard let dataSource = self.pDataSourceHelper.dataSource() else {
            return nil
        }
        if dataSource.count <= 0{
            return nil
        }
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let key:String = "argokit_tableView_trailingSwipe"
        return self.sendAction(withObj: key, paramter: [data, indexPath]) as? UISwipeActionsConfiguration
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldIndentWhileEditingRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? true
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:willBeginEditingRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let sel = #selector(self.tableView(_:didEndEditingRowAt:))
        if indexPath != nil {
            guard let data = self.pDataSourceHelper.dataForRow(indexPath!.row, at: indexPath!.section) else {
                return
            }
            self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath!])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: nil)
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let sourceData = self.pDataSourceHelper.dataForRow(sourceIndexPath.row, at: sourceIndexPath.section) else {
            return proposedDestinationIndexPath
        }
        guard let destinationData = self.pDataSourceHelper.dataForRow(proposedDestinationIndexPath.row, at: proposedDestinationIndexPath.section) else {
            return proposedDestinationIndexPath
        }
        let sel = #selector(self.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, destinationData, sourceIndexPath, proposedDestinationIndexPath]) as? IndexPath ?? proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return 0
        }
        let sel = #selector(self.tableView(_:indentationLevelForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Int ?? 0
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:shouldShowMenuForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS, introduced: 5.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return true
        }
        let sel = #selector(self.tableView(_:shouldSpringLoadRowAt:with:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath, context]) as? Bool ?? true
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.tableView(_:shouldBeginMultipleSelectionInteractionAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
    }
    
//    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        self._scrollViewShouldScrollToTop(scrollView)
//        return super.scrollViewShouldScrollToTop(scrollView)
//    }
//
//    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        super.scrollViewDidScrollToTop(scrollView)
//        self._scrollViewDidScrollToTop(scrollView)
//    }
//
//    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        super.scrollViewWillBeginDecelerating(scrollView)
//        self._scrollViewDidEndScroll(scrollView)
//    }
//
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        super.scrollViewWillBeginDragging(scrollView)
//        self._scrollViewWillBeginDragging(scrollView)
//    }
//
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        super.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//        self._scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//    }
}

extension TableNode{
    public func visibleModelCells() -> [(D,UITableViewCell)] {
        var models:[(D,UITableViewCell)] = []
        if let tableView = self.tableView{
            var cells:[UITableViewCell] = []
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            cells = tableView.visibleCells
            CATransaction.commit()
            for cell in cells {
                if let indexPath = tableView.indexPath(for: cell){
                    if let model = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
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
            var cells:[UITableViewCell] = []
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            cells = tableView.visibleCells
            CATransaction.commit()
            for cell in cells {
                if let indexPath = tableView.indexPath(for: cell){
                    if let model = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
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
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
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
    func createNodeFromData(_ data: Any,helper:Any)->CGFloat {
        if let datasource = helper as? DataSource<DataList<D>> {

            if datasource.type == .body {
                return pDataSourceHelper.rowHeight(data, maxWidth: maxWith)
            }
            if datasource.type == .header {
                return pSectionHeaderSourceHelper.rowHeight(data, maxWidth: maxWith)
            }

            if datasource.type == .footer {
                return pSectionFooterSourceHelper.rowHeight(data, maxWidth:maxWith)
            }
        }

        if let datasource = helper as? DataSource<SectionDataList<D>> {

            if datasource.type == .body {
                return dataSourceHelper.rowHeight(data, maxWidth: maxWith)
            }
            if datasource.type == .header {
                return sectionHeaderSourceHelper.rowHeight(data, maxWidth: maxWith)
            }

            if datasource.type == .footer {
                return sectionFooterSourceHelper.rowHeight(data, maxWidth:maxWith)
            }
        }
        return 0
    }
}
