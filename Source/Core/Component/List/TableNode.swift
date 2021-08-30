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
class TableView:UITableView{
    lazy var registedReuseIdSet = Set<String>()
    var cellCache:NSHashTable<ListCell> = NSHashTable<ListCell>.weakObjects()
    var headerFooterCache:NSHashTable<HeaderFooterView> = NSHashTable<HeaderFooterView>.weakObjects()
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
    var hitTestAction:(()->())?
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        if !oldFrame.equalTo(self.frame) {
//            if let action = reLayoutAction {
//                action(self.bounds)
//            }
//            oldFrame = self.frame
//        }
//    }
}

class TableNode<D>: ArgoKitScrollViewNode,
                    UITableViewDelegate,
                    UITableViewDataSource,
                    UITableViewDataSourcePrefetching,
                    UITableViewDragDelegate,
                    UITableViewDropDelegate,
                    DataSourceReloadNode {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        self.pDataSourceHelper.removeAll()
        if let  _ = self.pDataSourceHelper.nodeSourceList{
            self.pDataSourceHelper.nodeSourceList?.clear()
        }
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
    
    var _closeAnimation:Bool = false
    public func setCloseAnimation(_ animation:Bool){
        _closeAnimation = animation
    }
    
    var _relayoutList:Bool = false
    public func setRelayoutList(_ layout:Bool){
        _relayoutList = layout
    }
    
    private var _removeCacheNode:Bool = true
    public func setRemoveNode(_ remove:Bool){
        _removeCacheNode = remove
    }
    public var style: UITableView.Style = .plain
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    public weak var tableView: UITableView?
    public weak var nodeTableView: TableView?{
        get{
            if let tableView = self.nodeView() as? TableView{
               return tableView
            }
            return nil
        }
    }
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
                    tableView.tableHeaderView?.removeFromSuperview()
                    tableView.tableHeaderView = nil
                }
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
                    tableView.tableFooterView?.removeFromSuperview()
                    tableView.tableFooterView = nil
                }
            }
        }
    }
    
    private var maxRowHeight:CGFloat = 100
    
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
    
    var dragInteractionEnabled:Bool = false
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let tableView = TableView(frame: frame, style: style)
        maxWith = frame.width
        self.tableView = tableView
        if defaultViewHeight == 0 {
            defaultViewHeight = frame.height
            defaultFlexGrow = self.flexGrow()
        }
        
        self.pDataSourceHelper = self.dataSourceHelper
        self.pSectionHeaderSourceHelper = self.sectionHeaderSourceHelper
        self.pSectionFooterSourceHelper = self.sectionFooterSourceHelper
        
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
        if self.dragInteractionEnabled == true{
            tableView.dragInteractionEnabled = self.dragInteractionEnabled
            tableView.dragDelegate = self
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
                if !(new.equalTo(old)){
                    self.setContentSizeViewHeight(new.height)
                }else{
                    if self._relayoutList  && new.height > 0{
                       self.setContentSizeViewHeight(new.height)
                       self._relayoutList = false
                    }
                }
            }
        })

        return tableView
    }
    
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        if let tableNode =  node as? TableNode,
           let tableView = view as? TableView {
            self._relayoutList = tableNode._relayoutList
            if !self.isEqual(tableNode){
                tableNode._relayoutList = false
            }
            self.reusedNode = tableNode
            self.pDataSourceHelper = tableNode.dataSourceHelper
            self.pSectionHeaderSourceHelper = tableNode.sectionHeaderSourceHelper
            self.pSectionFooterSourceHelper = tableNode.sectionFooterSourceHelper
            tableView.reloadData()
        }
    }
    
    
    // MARK: ----  UITableViewDataSource Methods
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
        cell.selectionStyle = selectionStyle
        

        
        if let tableView_ = tableView as? TableView{
            if tableView_.cellCache.contains(cell) {
                isReuedCell = true
            }else{
                isReuedCell = false
                tableView_.cellCache.add(cell)
            }
        }
        
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else{
            return cell
        }
        let sel = #selector(self.tableView(_:cellForRowAt:))
        if let backgroudColor = self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, indexPath]) as? UIColor{
            cell.backgroundColor = backgroudColor
            cell.contentView.backgroundColor = backgroudColor
        }
        cell.sourceData = sourceData
        if let node = self.pDataSourceHelper.nodeForData(sourceData){
            self.pDataSourceHelper.updateCellHeightForRow(node, maxWidth: tableView.frame.width)
            if let cellData =  sourceData as? ArgoKitIdentifiable{
                cellData.argokit_cellHeight = node.size.height
                if cellData.argokit_cellHeight > maxRowHeight {
                    maxRowHeight = cellData.argokit_cellHeight
                }
            }
            // FIX:处理插入数据是node被绑定到多个cell上
            if !isReuedCell && node.containView() {
                if  let sourceData_ = sourceData as? ArgoKitIdentifiable  {
                    sourceData_.argokit_linkNode  = nil
                    self.pDataSourceHelper.rowHeight(sourceData_, maxWidth: cell.frame.width)
                    if let node = self.pDataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section){
                        if _removeCacheNode {
                            if cell.reusedCellNode != node {
                                self.pDataSourceHelper.removeNode(cell.reusedCellNode)
                                cell.reusedCellNode = node
                            }
                        }
                        cell.linkCellNode(node,isReused:isReuedCell)
                    }
                }
            }else{
                if _removeCacheNode {
                    if cell.reusedCellNode != node {
                        self.pDataSourceHelper.removeNode(cell.reusedCellNode)
                        cell.reusedCellNode = node
                    }
                }
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

    // MARK: ---  UITableViewDataSourcePrefetching methods
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:prefetchRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.tableView(_:cancelPrefetchingForRowsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    
    
    // MARK: --- UITableViewDelegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        if let node = self.pDataSourceHelper.nodeForData(sourceData,true) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            if let sourceData_ =  sourceData as? ArgoKitIdentifiable{
                node.sourceData = sourceData_
            }
            node.observeFrameChanged {[weak self,_indexPath = indexPath] (cellNode, _) in
                if let cellData = cellNode.sourceData{
                    cellData.argokit_cellHeight = cellNode.size.height
                }
                self?.reloadRowsHeight(_indexPath)
            }
        }
        
        guard let listCell = cell as? ListCell,
              let data = listCell.sourceData else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplay:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? ArgoKitIdentifiable{
            ArgoKitReusedLayoutHelper.removeLayoutNode(data.argokit_linkNode)
            if _removeCacheNode {
                data.argokit_linkNode = nil
            }
        }
        
        guard let listCell = cell as? ListCell,
              let data = listCell.sourceData as? ArgoKitIdentifiable else {
            return
        }
        let sel = #selector(self.tableView(_:didEndDisplaying:forRowAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
        listCell.sourceData = nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let node = self.pSectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadData()
            }
        }
        guard let data = self.pSectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayHeaderView:forSection:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, section])
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

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let node = self.pSectionFooterSourceHelper.nodeForRow(section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadData()
            }
        }
        guard let data = self.pSectionFooterSourceHelper.dataForRow(section, at: 0) else {
            return
        }
        let sel = #selector(self.tableView(_:willDisplayFooterView:forSection:))
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
            if height > maxRowHeight {
                maxRowHeight = height
            }
            return height
        }
        
        if let cellData = data as? ArgoKitIdentifiable,
           cellData.argokit_cellHeight.isNaN == false,
           cellData.argokit_cellHeight > 0{
            if cellData.argokit_cellHeight > maxRowHeight {
                maxRowHeight = cellData.argokit_cellHeight
            }
            return cellData.argokit_cellHeight
        }
        let height = self.pDataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: tableView.frame.width)
        if height.isNaN {
            return 44
        }
        if height > maxRowHeight {
            maxRowHeight = height
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let data = self.pDataSourceHelper.dataForRow(section, at: 0) else {
            return 0.0
        }
        let sel = #selector(self.tableView(_:heightForHeaderInSection:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, section]) as? CGFloat,
           height > 0{
            return height
        }
        
        return self.pSectionHeaderSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let data = self.pDataSourceHelper.dataForRow(section, at: 0) else {
            return 0.0
        }
        let sel = #selector(self.tableView(_:heightForFooterInSection:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, section]) as? CGFloat,
           height > 0{
            return height
        }
        return self.pSectionFooterSourceHelper.rowHeight(section, at: 0, maxWidth: tableView.frame.width)
    }
    
    // MARK: --- estimatedHeightForXXX
    @available(iOS 7.0, *)
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        let sel = #selector(self.tableView(_:estimatedHeightForRowAt:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? CGFloat{
            return height
        }
        
        if let cellData = data as? ArgoKitIdentifiable,
           cellData.argokit_cellHeight.isNaN == false,
           cellData.argokit_cellHeight > 0{
            return cellData.argokit_cellHeight
        }
        if maxRowHeight > estimatedRowHeight {
            return maxRowHeight
        }
        
        return estimatedRowHeight
    }

    @available(iOS 7.0, *)
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat{
        guard let data = self.pSectionHeaderSourceHelper.dataForRow(section, at: 0) else {
            return UITableView.automaticDimension
        }
        let sel = #selector(self.tableView(_:estimatedHeightForHeaderInSection:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, section]) as? CGFloat{
            return height
        }
        return UITableView.automaticDimension
    }

    @available(iOS 7.0, *)
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat{
        guard let data = self.pSectionFooterSourceHelper.dataForRow(section, at: 0) else {
            return UITableView.automaticDimension
        }
        let sel = #selector(self.tableView(_:estimatedHeightForFooterInSection:))
        if let height = self.sendAction(withObj: String(_sel: sel), paramter: [data, section]) as? CGFloat{
            return height
        }
        return UITableView.automaticDimension
    }
    
    
    // MARK: --- viewForXXX
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let identifier = "Header" + (self.pSectionHeaderSourceHelper.reuseIdForRow(section, at: 0) ?? kHeaderReuseIdentifier)
        if let tableView_ = tableView as? TableView,
            !tableView_.registedReuseIdSet.contains(identifier) {
            tableView.register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: identifier)
            tableView_.registedReuseIdSet.insert(identifier)
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HeaderFooterView
        var isReuedHeader = false
        if let tableView_ = tableView as? TableView{
            if tableView_.headerFooterCache.contains(header) {
                isReuedHeader = true
            }else{
                isReuedHeader = false
                tableView_.headerFooterCache.add(header)
            }
        }
        if let node = pSectionHeaderSourceHelper.nodeForRow(section, at: 0) {
            let sourceData = self.pSectionHeaderSourceHelper.dataForRow(section, at: 0)
            // FIX:处理插入数据是node被绑定到多个footerView上
            if !isReuedHeader && (node.containView()) {
                if  let sourceData_ = sourceData as? ArgoKitIdentifiable  {
                    sourceData_.argokit_linkNode  = nil
                    self.pSectionHeaderSourceHelper.rowHeight(sourceData_, maxWidth: tableView.frame.width)
                    if let node = self.pSectionHeaderSourceHelper.nodeForRow(section ,at: 0){
                        header.linkCellNode(node,isReused:isReuedHeader)
                        return header
                    }
                }
            }
            header.linkCellNode(node,isReused:isReuedHeader)
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
        var isReuedFooter = false
        if let tableView_ = tableView as? TableView{
            if tableView_.headerFooterCache.contains(footer) {
                isReuedFooter = true
            }else{
                isReuedFooter = false
                tableView_.headerFooterCache.add(footer)
            }
        }
        if let node = pSectionFooterSourceHelper.nodeForRow(section, at: 0) {
            let sourceData = self.pSectionFooterSourceHelper.dataForRow(section, at: 0)
            // FIX:处理插入数据是node被绑定到多个footerView上
            if !isReuedFooter && (node.containView()) {
                if  let sourceData_ = sourceData as? ArgoKitIdentifiable  {
                    sourceData_.argokit_linkNode  = nil
                    self.pSectionFooterSourceHelper.rowHeight(sourceData_, maxWidth: tableView.frame.width)
                    if let node = self.pSectionFooterSourceHelper.nodeForRow(section ,at: 0){
                        footer.linkCellNode(node,isReused:isReuedFooter)
                        return footer
                    }
                }
            }
            footer.linkCellNode(node,isReused:isReuedFooter)
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.tableView(_:accessoryButtonTappedForRowWith:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
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
        if indexPath.count != 2 {
            return .delete
        }
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return .delete
        }
        let sel = #selector(self.tableView(_:editingStyleForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? UITableViewCell.EditingStyle ?? .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if indexPath.count != 2 {
            return nil
        }
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return "Delete"
        }
        let sel = #selector(self.tableView(_:titleForDeleteConfirmationButtonForRowAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? String ?? "Delete"
    }

    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.count != 2 {
            return nil
        }
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
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    override func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let models:[(D,UITableViewCell)] = self.visibleModelCells()
        let sel = #selector(self.scrollViewDidEndScroll(_:))
        self.sendAction(withObj: String(_sel: sel), paramter: [models,scrollView])
    }
    
    
    
    //MARK: --- UITableViewDragDelegate Methods ---
    
    // Provide items to begin a drag associated with a given index path.
    // You can use -[session locationInView:] to do additional hit testing if desired.
    // If an empty array is returned a drag session will not begin.
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        let sel = #selector(self.tableView(_:itemsForBeginning:at:))
        if let items = self.sendAction(withObj: String(_sel: sel), paramter: [session,indexPath]) as? [UIDragItem]{
            return items
        }
        return []
    }

    
    // Called to request items to add to an existing drag session in response to the add item gesture.
    // You can use the provided point (in the table view's coordinate space) to do additional hit testing if desired.
    // If not implemented, or if an empty array is returned, no items will be added to the drag and the gesture
    // will be handled normally.
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]{
        let sel = #selector(self.tableView(_:itemsForAddingTo:at:point:))
        if let items = self.sendAction(withObj: String(_sel: sel), paramter: [session,indexPath,point]) as? [UIDragItem]{
            return items
        }
        return []
    }

    
    // Allows customization of the preview used for the row when it is lifted or if the drag cancels.
    // If not implemented or if nil is returned, the entire cell will be used for the preview.
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters?{
        let sel = #selector(self.tableView(_:dragPreviewParametersForRowAt:))
        if let parameter = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UIDragPreviewParameters{
            return parameter
        }
        return nil
    }

    
    // Called after the lift animation has completed to signal the start of a drag session.
    // This call will always be balanced with a corresponding call to -tableView:dragSessionDidEnd:
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession){
        let sel = #selector(self.tableView(_:dragSessionWillBegin:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    // Called to signal the end of the drag session.
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession){
        let sel = #selector(self.tableView(_:dragSessionDidEnd:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    // Controls whether move operations are allowed for the drag session.
    // If not implemented, defaults to YES.
    func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool{
        let sel = #selector(self.tableView(_:dragSessionAllowsMoveOperation:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return true
    }

    
    // Controls whether the drag session is restricted to the source application.
    // If not implemented, defaults to NO.
    func tableView(_ tableView: UITableView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool{
        let sel = #selector(self.tableView(_:dragSessionIsRestrictedToDraggingApplication:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return false
    }
    
    
    //MARK: --- UITableViewDropDelegate Methods ---
    
    // Called when the user initiates the drop.
    // Use the drop coordinator to access the items in the drop and the final destination index path and proposal for the drop,
    // as well as specify how you wish to animate each item to its final position.
    // If your implementation of this method does nothing, default drop animations will be supplied and the table view will
    // revert back to its initial state before the drop session entered.
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator){
        let sel = #selector(self.tableView(_:performDropWith:))
        self.sendAction(withObj: String(_sel: sel), paramter: [coordinator])
    }

    
    // If NO is returned no further delegate methods will be called for this drop session.
    // If not implemented, a default value of YES is assumed.
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool{
        let sel = #selector(self.tableView(_:canHandle:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return true
    }

    
    // Called when the drop session begins tracking in the table view's coordinate space.
    func tableView(_ tableView: UITableView, dropSessionDidEnter session: UIDropSession){
        let sel = #selector(self.tableView(_:dropSessionDidEnter:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
        
    }

    
    // Called frequently while the drop session being tracked inside the table view's coordinate space.
    // When the drop is at the end of a section, the destination index path passed will be for a row that does not yet exist (equal
    // to the number of rows in that section), where an inserted row would append to the end of the section.
    // The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
    // Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
    // You may perform your own hit testing via -[session locationInView:]
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal{
        let sel = #selector(self.tableView(_:dropSessionDidUpdate:withDestinationIndexPath:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session,destinationIndexPath ?? IndexPath(item: 0, section: 0)]) as? UITableViewDropProposal{
            return ret
        }
        return UITableViewDropProposal(operation: UIDropOperation.cancel)
    }

    
    // Called when the drop session is no longer being tracked inside the table view's coordinate space.
    func tableView(_ tableView: UITableView, dropSessionDidExit session: UIDropSession){
        let sel = #selector(self.tableView(_:dropSessionDidExit:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    // Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession){
        let sel = #selector(self.tableView(_:dropSessionDidEnd:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    // Allows customization of the preview used when dropping to a newly inserted row.
    // If not implemented or if nil is returned, the entire cell will be used for the preview.
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters?{
        let sel = #selector(self.tableView(_:dropPreviewParametersForRowAt:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UIDragPreviewParameters{
            return ret
        }
        return nil
    }
}



extension TableNode{
    public func visibleModelCells() -> [(D,UITableViewCell)] {
        var models:[(D,UITableViewCell)] = []
        if let tableView = self.nodeTableView{
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
        if let tableView = self.nodeTableView{
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
        if let tableView = self.nodeTableView {
            tableView.reloadData()
        }
    }
    
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.insertSections(sections, with: animation)
        }
    }

    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.deleteSections(sections, with: animation)
        }
    }

    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.reloadSections(sections, with: animation)
        }
    }

    public func moveSection(_ section: Int, toSection newSection: Int) {
        if let tableView = self.nodeTableView {
            tableView.moveSection(section, toSection: newSection)
        }
    }

    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.insertRows(at:indexPaths, with: animation)
        }
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.deleteRows(at:indexPaths, with: animation)
        }
    }
    
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.deleteRows(at:[indexPath],with: animation)
        }
    }

    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        if let tableView = self.nodeTableView {
            tableView.reloadRows(at:indexPaths, with: animation)
        }
    }

    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        if let tableView = self.nodeTableView {
            tableView.moveRow(at:indexPath, to: newIndexPath)
        }
    }

    public func reloadRowsHeight(_ indexPath:IndexPath? = nil) {
        let isScrolling = RunLoop.current.currentMode == RunLoop.Mode.tracking
        if isScrolling {
            self._reloadRowsHeight(true,indexPath)
            return;
        }
        self._reloadRowsHeight(self._closeAnimation,indexPath)
    }
    private func _reloadRowsHeight(_ closeAnimation:Bool = false,_ indexPath:IndexPath? = nil){
        DispatchQueue.main.async {
            self.__reloadRowsHeight(closeAnimation,indexPath)
        }
    }
    private func __reloadRowsHeight(_ closeAnimation:Bool = false,_ indexPath:IndexPath? = nil) {
        if !canReloadRowsHeight(indexPath) {
            return
        }
        if closeAnimation == true {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.nodeTableView?.beginUpdates()
            if !canReloadRowsHeight(indexPath) {
                return
            }
            self.nodeTableView?.endUpdates()
            CATransaction.commit()
        }else{
            self.nodeTableView?.beginUpdates()
            if !canReloadRowsHeight(indexPath) {
                return
            }
            self.nodeTableView?.endUpdates()
        }
    }
    
    private func canReloadRowsHeight(_ indexPath:IndexPath? = nil) -> Bool{
        if let indexPath_ = indexPath  {
            let sections = self.nodeTableView?.numberOfSections
            let dataSections = self.pDataSourceHelper.dataSource()?.count
            if sections != dataSections {
                return false
            }
            let rows = self.nodeTableView?.numberOfRows(inSection: indexPath_.section)
            if let dataSource =  self.pDataSourceHelper.dataSource(),dataSource.count > indexPath_.section{
                  let dataCount = dataSource[indexPath_.section].count
                  if rows != dataCount {
                    return false
                  }
              }
          }
        return true
    }

    
    func removeNode(_ node:Any?){
        pDataSourceHelper.removeNode(node)
        pSectionHeaderSourceHelper.removeNode(node)
        pSectionFooterSourceHelper.removeNode(node)
    }
    func removeAll(){
        pDataSourceHelper.removeAll()
        pSectionHeaderSourceHelper.removeAll()
        pSectionFooterSourceHelper.removeAll()
    }
}



extension TableNode{
    func createNodeFromData(_ data: Any,helper:Any){
        if let datasource = helper as? DataSource<DataList<D>> {

            if datasource.type == .body {
                pDataSourceHelper.rowHeight(data, maxWidth: maxWith)
            }
            if datasource.type == .header {
                pSectionHeaderSourceHelper.rowHeight(data, maxWidth: maxWith)
            }

            if datasource.type == .footer {
                pSectionFooterSourceHelper.rowHeight(data, maxWidth:maxWith)
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
