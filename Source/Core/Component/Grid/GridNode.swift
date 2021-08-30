//
//  ArgoKitGridNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation

fileprivate let kGridCellReuseIdentifier = "kGridCellReuseIdentifier"
fileprivate let kGridHeaderReuseIdentifier = "kGridHeaderReuseIdentifier"
fileprivate let kGridFooterReuseIdentifier = "kGridFooterReuseIdentifier"

class ArgoKitGridView: UICollectionView {
    lazy var registedReuseIdSet = Set<String>()
    var cellCache:NSHashTable<GridCell> = NSHashTable<GridCell>.weakObjects()
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
//    public override func layoutSubviews() {
//        if !oldFrame.equalTo(self.frame) {
//            if let action = reLayoutAction {
//                action(self.bounds)
//            }
//            oldFrame = self.frame
//        }
//        super.layoutSubviews()
//    }
}

class GridNode<D>: ArgoKitScrollViewNode,
                       UICollectionViewDelegate,
                       UICollectionViewDataSource,
                       UICollectionViewDataSourcePrefetching,
                       UICollectionViewDragDelegate,
                       UICollectionViewDropDelegate,
                       GridDelegateFlowLayout,
                       GridDelegateWaterfallLayout,
                       DataSourceReloadNode
{
    

   
    private var gestures:[UIGestureRecognizer]?
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
    
    lazy var sectionFooterSourceHelper:DataSourceHelper<D> = {[weak self] in
        let _dataSourceHelper = DataSourceHelper<D>()
        _dataSourceHelper._rootNode = self
        _dataSourceHelper.dataSourceType = .footer
        return _dataSourceHelper
    }()
    
    var pDataSourceHelper: DataSourceHelper<D> = DataSourceHelper<D>()
    var pSectionHeaderSourceHelper:DataSourceHelper<D> = DataSourceHelper<D>()
    var pSectionFooterSourceHelper :DataSourceHelper<D> = DataSourceHelper<D>()
    
    // 支持移动重排
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    fileprivate var moveItem = false
    
    // 是否开启预加载
    var isPrefetchingEnabled:Bool = false
    
    // 是否开启拖拽
    var dragInteractionEnabled:Bool = false
    
    public var maxWith:CGFloat = UIScreen.main.bounds.width
    var actionTitle:String?
    var flowLayout = GridFlowLayout()
    var supportWaterfall:Bool = false{
        didSet{
            if supportWaterfall {
                flowLayout = GridWaterfallLayout()
            }
        }
    }
    var observation:NSKeyValueObservation?
    private weak var pGridView_: ArgoKitGridView?
    private weak var pGridView: ArgoKitGridView?{
        set{
            pGridView_ = newValue
        }get{
            if let gridView = self.nodeView() as? ArgoKitGridView{
               return gridView
            }
            return nil
        }
    }
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let gridView = ArgoKitGridView(frame: frame, collectionViewLayout: flowLayout)
        gridView.frame = frame
        maxWith = frame.size.width
        gridView.reLayoutAction = { [weak self] frame in
            if let `self` = self {
                var cellNodes:[Any] = []
                cellNodes.append(contentsOf: self.dataSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(cellNodes, frame: CGRect(x: 0, y: 0, width: self.flowLayout.itemWidth(inSection: 0), height: frame.height))
                
                var headerNodes:[Any] = []
                headerNodes.append(contentsOf: self.sectionHeaderSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(headerNodes, frame: frame)
                
                var footerNodes:[Any] = []
                footerNodes.append(contentsOf: self.sectionFooterSourceHelper.cellNodeCache)
                ArgoKitReusedLayoutHelper.reLayoutNode(footerNodes, frame:frame)
            }
        }
        gridView.backgroundColor = .white
       
        pGridView = gridView
       
        
        gridView.delegate = self
        gridView.dataSource = self
        
        gridView.dragInteractionEnabled = true
   
        
        gridView.dropDelegate = self
        
      
        
        gridView.isPrefetchingEnabled  = self.isPrefetchingEnabled
        if self.isPrefetchingEnabled ==  true {
            gridView.prefetchDataSource = self
        }
        gridView.dragInteractionEnabled = self.dragInteractionEnabled
        if self.dragInteractionEnabled == true {
            gridView.dragDelegate = self
            gridView.reorderingCadence = .immediate
        }
        
        if #available(iOS 11.0, *) {
            gridView.contentInsetAdjustmentBehavior = .never
        }
        
        gridView.alwaysBounceVertical = true
        
        if moveItem && supportWaterfall == false{
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(GridNode.handleLongGesture(_:)))
            gridView.addGestureRecognizer(longPressGesture)
            
        }
        observation = gridView.observe(\ArgoKitGridView.contentSize, options: [.new, .old], changeHandler: {[weak self] (gridView, change) in
            if let `self` = self,
               let old = change.oldValue,
               let new = change.newValue{
                if !new.equalTo(old) {
                    self.setContentSizeViewHeight(new.height)
               }
            }
        })
        self.gestures = gridView.gestureRecognizers
        return gridView
    }
    
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        if let tableNode =  node as? GridNode,
           let collectionView = view as? ArgoKitGridView {
            self.reusedNode = tableNode
            self.pDataSourceHelper = tableNode.dataSourceHelper
            self.pSectionHeaderSourceHelper = tableNode.sectionHeaderSourceHelper
            self.pSectionFooterSourceHelper = tableNode.sectionFooterSourceHelper

            if let gestures_ = collectionView.gestureRecognizers,
               gestures_.count > 0{
                if let gestures = self.gestures{
                    for gesture in gestures {
                        if !gestures_.contains(gesture)  {
                            collectionView.addGestureRecognizer(gesture)
                        }
                    }
                }
            }else{
                if let gestures = self.gestures{
                    for gesture in gestures {
                        collectionView.addGestureRecognizer(gesture)
                    }
                }
            }
            
            collectionView.reloadData()
        }
    }

    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
        
            case UIGestureRecognizer.State.began:
                guard let selectedIndexPath = pGridView?.indexPathForItem(at: gesture.location(in: self.pGridView)) else    {
                    break
                }
                pGridView?.beginInteractiveMovementForItem(at: selectedIndexPath)
                break
            case UIGestureRecognizer.State.changed:
                pGridView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                break
            case UIGestureRecognizer.State.ended:
                pGridView?.endInteractiveMovement()
                break
            default:
                pGridView?.cancelInteractiveMovement()
                break
        }
    }

    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.pDataSourceHelper.numberOfSection()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pDataSourceHelper.numberOfRows(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.pDataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kGridCellReuseIdentifier
        if let collectionView_ = collectionView as? ArgoKitGridView,
           !collectionView_.registedReuseIdSet.contains(identifier) {
            collectionView_.register(GridCell.self, forCellWithReuseIdentifier: identifier)
            collectionView_.registedReuseIdSet.insert(identifier)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GridCell
        var isReuedCell = false
        if let collectionView = collectionView as? ArgoKitGridView{
            if collectionView.cellCache.contains(cell) {
                isReuedCell = true
            }else{
                isReuedCell = false
                collectionView.cellCache.add(cell)
            }
        }
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else{
            return cell
        }
        let sel = #selector(collectionView(_:cellForItemAt:))
        if let backgroudColor = self.sendAction(withObj: String(_sel: sel), paramter: [sourceData, indexPath]) as? UIColor{
            cell.backgroundColor = backgroudColor
            cell.contentView.backgroundColor = backgroudColor
        }
        cell.sourceData = sourceData
        if let node = self.pDataSourceHelper.nodeForData(sourceData) {
            let itemWidth = self.collectionViewItemWidth(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
            self.pDataSourceHelper.updateCellHeightForRow(node, maxWidth: itemWidth)
            if let cellData =  sourceData as? ArgoKitIdentifiable{
                cellData.argokit_cellHeight = node.size.height
            }
            if cell.reusedCellNode != node {
                self.pDataSourceHelper.removeNode(cell.reusedCellNode)
                cell.reusedCellNode = node
            }
            cell.linkCellNode(node,isReused: isReuedCell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else{
            return CGSize.zero
        }
        if let layout = collectionViewLayout as? GridFlowLayout{
            let itemWidth = self.collectionViewItemWidth(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
            var height = layout.itemHeight
            var calculateHeight:CGFloat = 0
            if let cellData = sourceData as? ArgoKitIdentifiable,
               cellData.argokit_cellHeight.isNaN == false,
               cellData.argokit_cellHeight > 0 {
                calculateHeight = cellData.argokit_cellHeight
            }else{
                calculateHeight = self.pDataSourceHelper.rowHeight(sourceData, maxWidth: itemWidth)
            }
            if height == 0{
                height = calculateHeight
            }
            return CGSize(width:itemWidth, height: height)
        }
        return CGSize.zero
    }
    
    func collectionViewItemWidth(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat{
        if let layout = collectionViewLayout as? GridFlowLayout {
            var itemWidth:CGFloat = 0
            if let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section)  {
                let sel = #selector(self.collectionView(_:layout:sizeForItemAt:))
                if let itemWith_ = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? CGFloat,itemWith_ > 0{
                    itemWidth = itemWith_
                }
            }
            if itemWidth <= 0 {
                itemWidth = layout.itemWidth(inSection: indexPath.section)
            }
            return itemWidth
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var dataSourceHelper:DataSourceHelper<D>? = nil
        var reuseIdentifier:String = kGridHeaderReuseIdentifier
        var prefix:String = ""
        if kind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.pSectionHeaderSourceHelper
            prefix = "header"
            reuseIdentifier = kGridHeaderReuseIdentifier
        }else if kind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.pSectionFooterSourceHelper
            prefix = "footer"
            reuseIdentifier = kGridFooterReuseIdentifier
        }
        if let dataSourceHelper = dataSourceHelper {
            let identifier = prefix + (dataSourceHelper.reuseIdForRow(indexPath.section, at: 0) ?? reuseIdentifier)
            if let collectionView_ = collectionView as? ArgoKitGridView,
               !collectionView_.registedReuseIdSet.contains(identifier) {
                collectionView_.register(GridCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
                collectionView_.registedReuseIdSet.insert(identifier)
            }
            
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! GridCell
            if let node = dataSourceHelper.nodeForRow(indexPath.section, at: 0) {
                reusableView.linkCellNode(node)
            }
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if let dataSource = self.pSectionHeaderSourceHelper.dataSource(), dataSource.count == 0 {
            return CGSize(width:0, height: 0)
        }
        var width = collectionView.frame.size.width
        var height = self.pSectionHeaderSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if let layout = collectionViewLayout as? GridFlowLayout{
            if layout.headerHeight > 0 {
                height = layout.headerHeight
            }
            if layout.headerWidth > 0 {
                width = layout.headerWidth
            }
        }
        if height == 0 || width == 0{
            return  CGSize(width:0, height: 0)
        }
        return CGSize(width:width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        if let dataSource = self.pSectionFooterSourceHelper.dataSource(), dataSource.count == 0 {
            return CGSize(width:0, height: 0)
        }
        var width = collectionView.frame.size.width
        var height = self.pSectionFooterSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if collectionViewLayout is GridFlowLayout {
            let layout = collectionViewLayout as! GridFlowLayout
            if layout.footerHeight > 0 {
                height = layout.footerHeight
            }
            
            if layout.footerWidth > 0 {
                width = layout.footerWidth
            }
        }
        if height == 0 || width == 0{
            return CGSize(width:0, height: 0)
        }
        return CGSize(width:width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool{
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(collectionView(_:canMoveItemAt:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? Bool{
            return ret
        }
        return moveItem
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        if var items = self.pDataSourceHelper.sectionDataSourceList?[sourceIndexPath.section]{
            let temp = items.remove(at: sourceIndexPath.item)
            items.insert(temp, at: destinationIndexPath.item)
            self.pDataSourceHelper.sectionDataSourceList?[sourceIndexPath.section] = items
        }
        else if let temp = self.pDataSourceHelper.dataSourceList?[sourceIndexPath.item]{
            self.pDataSourceHelper.dataSourceList?.delete(at: sourceIndexPath)
            self.pDataSourceHelper.dataSourceList?.insert(data: temp, at: destinationIndexPath)
        }
    }

    func indexTitles(for collectionView: UICollectionView) -> [String]?{
        let sel = #selector(self.indexTitles(for:))
        if let titles = self.sendAction(withObj: String(_sel: sel), paramter: nil) as? [String]{
            return titles
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath{
        let sel = #selector(self.collectionView(_:indexPathForIndexTitle:at:))
        if let indexPath = self.sendAction(withObj: String(_sel: sel), paramter: [title,index]) as? IndexPath{
            return indexPath
        }
        return IndexPath(index: 0)
    }
    
    // MARK: - UICollectionViewDelegate Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didSelectItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didDeselectItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    // MARK: - UICollectionViewDelegate Highlight
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool{
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didHighlightItemAt:))
        if let color = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didUnhighlightItemAt:))
        if  let color = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }
    }
    
    // MARK: - UICollectionViewDelegate Display
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        if let node = self.pDataSourceHelper.nodeForData(sourceData,true){
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            
            if let sourceData_ =  sourceData as? ArgoKitIdentifiable{
                node.sourceData = sourceData_
            }
            
            node.observeFrameChanged {[weak self,indexPath_ = indexPath] (cellNode, _) in
                if let cellData = cellNode.sourceData{
                    cellData.argokit_cellHeight = cellNode.size.height
                }
                self?.reloadRowsHeight(indexPath_)
            }
        }
        
        guard let gridCell = cell as? GridCell,
              let data = gridCell.sourceData as? ArgoKitIdentifiable else {
            return
        }
        let sel = #selector(self.collectionView(_:willDisplay:forItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        guard let sourceData = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? ArgoKitIdentifiable else {
            return
        }
        
        if let node = sourceData.argokit_linkNode{
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
            sourceData.argokit_linkNode = nil
        }
        
        guard let gridCell = cell as? GridCell,
              let data = gridCell.sourceData as? ArgoKitIdentifiable else {
            return
        }
        
        let sel = #selector(self.collectionView(_:didEndDisplaying:forItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
        gridCell.sourceData = nil
    }

    
    // MARK: - HEADER OR FOOTER
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath){
        var dataSourceHelper:DataSourceHelper<D>? = nil
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.pSectionHeaderSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.pSectionFooterSourceHelper
        }
        if let node = dataSourceHelper?.nodeForRow(indexPath.section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadData()
            }
        }
        guard let data = dataSourceHelper?.dataForRow(indexPath.section, at: 0) else {
            return
        }
        if let node = self.pDataSourceHelper.nodeForRow(indexPath.section, at: 0) {
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
        }
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            self.collectionView(collectionView,willDisplayHeaderData: data,at: indexPath)
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            self.collectionView(collectionView,willDisplayFooterData: data,at: indexPath)
        }
    }
    
    @objc @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplayHeaderData data: Any, at indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:willDisplayHeaderData:at:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }
    
    @objc @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplayFooterData data: Any, at indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:willDisplayFooterData:at:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }
    
    
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath){
        var dataSourceHelper:DataSourceHelper<D>? = nil
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.pSectionHeaderSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.pSectionFooterSourceHelper
        }
        guard let data = dataSourceHelper?.dataForRow(indexPath.section, at: 0) else {
            return
        }
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            self.collectionView(collectionView,didEndDisplayingHeaderData: data,at: indexPath)
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            self.collectionView(collectionView,didEndDisplayingFooterData: data,at: indexPath)
        }
    }
    
    @objc @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView,  didEndDisplayingHeaderData data: Any, at indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:didEndDisplayingHeaderData:at:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }
    
    @objc @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingFooterData data: Any, at indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:didEndDisplayingFooterData:at:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    // MARK: - UICollectionViewDelegate Menu
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.collectionView(_:shouldShowMenuForItemAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.collectionView(_:canPerformAction:forItemAt:withSender:))
        if let s_sender = sender {
            return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender]) as? Bool ?? false
        }
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:performAction:forItemAt:withSender:))
        if let s_sender = sender {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath])
        }
    }
    
    
    @available(iOS 9.0, *)
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath{
        let sel = #selector(collectionView(_:targetIndexPathForMoveFromItemAt:toProposedIndexPath:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [originalIndexPath, proposedIndexPath]) as? IndexPath{
            return ret
        }
        return IndexPath(row: 0, section: 0)
    }

    
    @available(iOS 9.0, *)
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint{
        let sel = #selector(collectionView(_:targetContentOffsetForProposedContentOffset:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [proposedContentOffset]) as? CGPoint{
            return ret
        }
        return CGPoint.zero
    }
    
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool{
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(collectionView(_:shouldSpringLoadItemAt:with:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath,context]) as? Bool{
            return ret
        }
        return false
    }
    

    
    // MARK: --- Menu ---
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.collectionView(_:contextMenuConfigurationForItemAt:point:))
        if let children = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath, point])  as? [UIAction]{
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
                var actionTitle = "Actions"
                if let title = self?.actionTitle{
                    actionTitle = title
                }
               return UIMenu(title: actionTitle, children:children)
            }
        }
        return nil
    }

    /**
     * @abstract Called when the interaction is about to dismiss. Return a UITargetedPreview describing the desired dismissal target.
     * The interaction will animate the presented menu to the target. Use this to customize the dismissal animation.
     *
     * @param collectionView  This UICollectionView.
     * @param configuration   The configuration of the menu displayed by this interaction.
     */
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        let sel = #selector(self.collectionView(_:previewForDismissingContextMenuWithConfiguration:))
        if let view = self.sendAction(withObj: String(_sel: sel), paramter:nil)  as? View{
        
            if let containerView = self.view {
                view.applyLayout(size:CGSize(width: containerView.frame.size.width,height: CGFloat.nan))
                if let showView = view.node?.view {
                    let previewTarget = UIPreviewTarget(container: containerView, center: containerView.center)
                    let previewParams = UIPreviewParameters()
                    previewParams.backgroundColor = .clear
                    return UITargetedPreview(view: showView, parameters: previewParams, target: previewTarget)
                }
            }
        }
        return nil
    }

    
    /**
     * @abstract Called when the interaction is about to "commit" in response to the user tapping the preview.
     *
     * @param collectionView  This UICollectionView.
     * @param configuration   Configuration of the currently displayed menu.
     * @param animator        Commit animator. Add animations to this object to run them alongside the commit transition.
     */
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating){
        
    }

    
    /**
     * @abstract Called when the collection view is about to display a menu.
     *
     * @param collectionView  This UICollectionView.
     * @param configuration   The configuration of the menu about to be displayed.
     * @param animator        Appearance animator. Add animations to run them alongside the appearance transition.
     */
    @available(iOS 13.2, *)
    func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?){
        
    }

    
    /**
     * @abstract Called when the collection view's context menu interaction is about to end.
     *
     * @param collectionView  This UICollectionView.
     * @param configuration   Ending configuration.
     * @param animator        Disappearance animator. Add animations to run them alongside the disappearance transition.
     */
    @available(iOS 13.2, *)
    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?){
        
    }
    
    // MARK: --- Focus ---
    @available(iOS 9.0, *)
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool{
        guard let data = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(collectionView(_:canFocusItemAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }

    @available(iOS 9.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool{
        let sel = #selector(collectionView(_:shouldUpdateFocusIn:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [context]) as? Bool ?? false
    }

    @available(iOS 9.0, *)
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator){
        let sel = #selector(collectionView(_:didUpdateFocusIn:with:))
        self.sendAction(withObj: String(_sel: sel), paramter: [context, coordinator])
    }

    @available(iOS 9.0, *)
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath?{
        let sel = #selector(self.indexPathForPreferredFocusedView(in:))
        return self.sendAction(withObj: String(_sel: sel), paramter: nil) as? IndexPath
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let sel = #selector(self.collectionView(_:layout:insetForSectionAt:))
        if let sectionInset = self.sendAction(withObj: String(_sel: sel), paramter: [section]) as? UIEdgeInsets {
            return sectionInset
        }
        
        if let layout =  collectionViewLayout as? GridFlowLayout{
            return layout.sectionInset
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }

    func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        let sel = #selector(self.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        if let interitemSpacing = self.sendAction(withObj: String(_sel: sel), paramter: [section]) as? CGFloat {
            return interitemSpacing
        }
        
        if let layout =  collectionViewLayout as? GridFlowLayout{
            return layout.minimumInteritemSpacing
        }
        return  0
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        let sel = #selector(self.collectionView(_:layout:minimumLineSpacingForSectionAt:))
        if let lineSpacing = self.sendAction(withObj: String(_sel: sel), paramter: [section]) as? CGFloat {
            return lineSpacing
        }
        
        if let layout =  collectionViewLayout as? GridFlowLayout{
            return layout.minimumLineSpacing
        }
        return  0
    }


    @objc func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: UICollectionViewLayout,
                                       columnCountFor section: Int) -> Int{
        let sel = #selector(self.collectionView(_:layout:columnCountFor:))
        if let columnCount = self.sendAction(withObj: String(_sel: sel), paramter: [section]) as? Int {
            return columnCount
        }
        if let layout =  collectionViewLayout as? GridFlowLayout{
            return layout.columnCount
        }
        return 1
    }
    
    
    // MARK: --- UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let sel = #selector(self.collectionView(_:prefetchItemsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]){
        let sel = #selector(self.collectionView(_:cancelPrefetchingForItemsAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [indexPaths])
    }
    
    
    // MARK: ---- UICollectionViewDragDelegate
    
    
    /* Provide items to begin a drag associated with a given indexPath.
     * If an empty array is returned a drag session will not begin.
     */
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        let sel = #selector(self.collectionView(_:itemsForBeginning:at:))
        if let items = self.sendAction(withObj: String(_sel: sel), paramter: [session,indexPath]) as? [UIDragItem]{
            return items
        }
        return []
    }

    
    /* Called to request items to add to an existing drag session in response to the add item gesture.
     * You can use the provided point (in the collection view's coordinate space) to do additional hit testing if desired.
     * If not implemented, or if an empty array is returned, no items will be added to the drag and the gesture
     * will be handled normally.
     */
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]{
        let sel = #selector(self.collectionView(_:itemsForAddingTo:at:point:))
        if let items = self.sendAction(withObj: String(_sel: sel), paramter: [session,indexPath,point]) as? [UIDragItem]{
            return items
        }
        return []
    }

    
    /* Allows customization of the preview used for the item being lifted from or cancelling back to the collection view.
     * If not implemented or if nil is returned, the entire cell will be used for the preview.
     */
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?{
        let sel = #selector(self.collectionView(_:dragPreviewParametersForItemAt:))
        if let parameter = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UIDragPreviewParameters{
            return parameter
        }
        return nil
    }

    
    /* Called after the lift animation has completed to signal the start of a drag session.
     * This call will always be balanced with a corresponding call to -collectionView:dragSessionDidEnd:
     */
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession){
        let sel = #selector(self.collectionView(_:dragSessionWillBegin:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    /* Called to signal the end of the drag session.
     */
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession){
        let sel = #selector(self.collectionView(_:dragSessionDidEnd:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    /* Controls whether move operations (see UICollectionViewDropProposal.operation) are allowed for the drag session.
     * If not implemented this will default to YES.
     */
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool{
        let sel = #selector(self.collectionView(_:dragSessionAllowsMoveOperation:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return true
    }

    
    /* Controls whether the drag session is restricted to the source application.
     * If YES the current drag session will not be permitted to drop into another application.
     * If not implemented this will default to NO.
     */
    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool{
        let sel = #selector(self.collectionView(_:dragSessionIsRestrictedToDraggingApplication:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return false
    }
    
    
    // MARK: ---- UICollectionViewDropDelegate
    
    /* Called when the user initiates the drop.
     * Use the dropCoordinator to specify how you wish to animate the dropSession's items into their final position as
     * well as update the collection view's data source with data retrieved from the dropped items.
     * If the supplied method does nothing, default drop animations will be supplied and the collection view will
     * revert back to its initial pre-drop session state.
     */
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator){
        let sel = #selector(self.collectionView(_:performDropWith:))
        self.sendAction(withObj: String(_sel: sel), paramter: [coordinator])
    }

    
    /* If NO is returned no further delegate methods will be called for this drop session.
     * If not implemented, a default value of YES is assumed.
     */
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool{
        let sel = #selector(self.collectionView(_:canHandle:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session]) as? Bool{
            return ret
        }
        return true
    }

    
    /* Called when the drop session begins tracking in the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession){
        let sel = #selector(self.collectionView(_:dropSessionDidEnter:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    /* Called frequently while the drop session being tracked inside the collection view's coordinate space.
     * When the drop is at the end of a section, the destination index path passed will be for a item that does not yet exist (equal
     * to the number of items in that section), where an inserted item would append to the end of the section.
     * The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
     * Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
     * You may perform your own hit testing via -[UIDropSession locationInView]
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal{
        let sel = #selector(self.collectionView(_:dropSessionDidUpdate:withDestinationIndexPath:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [session,destinationIndexPath ?? IndexPath(item: 0, section: 0)]) as? UICollectionViewDropProposal{
            return ret
        }
        return UICollectionViewDropProposal(operation: UIDropOperation.cancel)
    }

    
    /* Called when the drop session is no longer being tracked inside the collection view's coordinate space.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession){
        let sel = #selector(self.collectionView(_:dropSessionDidExit:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    /* Called when the drop session completed, regardless of outcome. Useful for performing any cleanup.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession){
        let sel = #selector(self.collectionView(_:dropSessionDidEnd:))
        self.sendAction(withObj: String(_sel: sel), paramter: [session])
    }

    
    /* Allows customization of the preview used for the item being dropped.
     * If not implemented or if nil is returned, the entire cell will be used for the preview.
     *
     * This will be called as needed when animating drops via -[UICollectionViewDropCoordinator dropItem:toItemAtIndexPath:]
     * (to customize placeholder drops, please see UICollectionViewDropPlaceholder.previewParametersProvider)
     */
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?{
        let sel = #selector(self.collectionView(_:dropPreviewParametersForItemAt:))
        if let ret = self.sendAction(withObj: String(_sel: sel), paramter: [indexPath]) as? UIDragPreviewParameters{
            return ret
        }
        return nil
    }
    
}
extension GridNode{
    public func visibleModelCells() -> [(D,UICollectionViewCell)] {
        var models:[(D,UICollectionViewCell)] = []
        if let pGridView = self.pGridView{
            let cells = pGridView.visibleCells
            for cell in cells {
                if let indexPath = pGridView.indexPath(for: cell){
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
        if let pGridView = self.pGridView{
            let cells = pGridView.visibleCells
            for cell in cells {
                if let indexPath = pGridView.indexPath(for: cell){
                    if let model = self.pDataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
                        models.append(model)
                    }
                }
            }
        }
        return models
    }
    
    public func gridCellforItem(_ indexPath:IndexPath) -> UICollectionViewCell?{
        if let pGridView = self.pGridView{
            let cell = pGridView.cellForItem(at: indexPath)
            return cell
        }
        return nil
    }
}

// MARK: - reload data
extension GridNode {
    
    public func reloadData(){
        self.pGridView?.reloadData()
    }
    
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pGridView?.insertSections(sections)
    }
    
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pGridView?.deleteSections(sections)
    }
    
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pGridView?.reloadSections(sections)
    }
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pGridView?.insertItems(at: indexPaths)
    }
    
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pGridView?.deleteItems(at:indexPaths)
    }
    
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.pGridView?.deleteItems(at:[indexPath])
    }

    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pGridView?.reloadItems(at: indexPaths)
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        self.pGridView?.moveItem(at:indexPath,to: newIndexPath)
    }
    
    
    
    public func insertItems(at indexPaths: [IndexPath]){
        self.pGridView?.insertItems(at: indexPaths)
    }
    public func reloadItems(at indexPaths: [IndexPath]){
        self.pGridView?.reloadItems(at: indexPaths)
    }
    
    public func reloadSections(_ sections:IndexSet){
        self.pGridView?.reloadSections(sections)
    }
    
    
    func insertSections(_ sections: IndexSet){
        self.pGridView?.insertSections(sections)
    }

    func deleteSections(_ sections: IndexSet){
        self.pGridView?.deleteSections(sections)
    }

    open func moveSection(_ section: Int, toSection newSection: Int){
        self.pGridView?.moveSection(section,toSection: newSection)
    }

    open func deleteItems(at indexPaths: [IndexPath]){
        self.pGridView?.deleteItems(at:indexPaths)
    }

    open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath){
        self.pGridView?.moveItem(at:indexPath,to: newIndexPath)
    }
    
    public func scrollToItem(indexPath: IndexPath,scrollposition:UICollectionView.ScrollPosition,animated:Bool) {
        pGridView?.scrollToItem(at: indexPath, at: scrollposition, animated: animated)
    }
    
    public func reloadRowsHeight(_ indexPath:IndexPath? = nil) {
        if let gridView = self.pGridView{
            if !self.canReloadRowsHeight(indexPath){
                return
            }
            gridView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    private func canReloadRowsHeight(_ indexPath:IndexPath? = nil) -> Bool{
        if let indexPath_ = indexPath  {
            let sections = self.pGridView?.numberOfSections
            let dataSections = self.pDataSourceHelper.dataSource()?.count
            if sections != dataSections {
                return false
            }
            let rows = self.pGridView?.numberOfItems(inSection: indexPath_.section)
            if let dataSource =  self.pDataSourceHelper.dataSource(),dataSource.count > indexPath_.section{
                  let dataCount = dataSource[indexPath_.section].count
                  if rows != dataCount {
                    return false
                  }
              }
          }
        return true
    }
}

//MARK: - 设置配置参数
extension GridNode{
    public func waterfall(_ value:Bool){
        self.supportWaterfall = value
    }
    public func enableMoveItem(_ value:Bool){
        self.moveItem = value
    }
    
    public func itemHeight(_ value:CGFloat){
        flowLayout.itemHeight = value
    }
    public func headerHeight(_ value:CGFloat){
        flowLayout.headerHeight = value
    }
    
    public func headerWidth(_ value:CGFloat){
        flowLayout.headerWidth = value
    }
    
    public func footerHeight(_ value:CGFloat){
        flowLayout.footerHeight = value
    }
    
    public func footerWidth(_ value:CGFloat){
        flowLayout.footerWidth = value
    }
    
    public func columnCount(_ value:Int){
        flowLayout.columnCount = value
    }

    public func columnSpacing(_ value:CGFloat){
        flowLayout.minimumInteritemSpacing = value
    }
    
    public func lineSpacing(_ value:CGFloat){
        flowLayout.minimumLineSpacing = value
    }
    
    public func estimatedItemSize(_ value:CGSize = CGSize.zero){
        flowLayout.estimatedItemSize = value
    }
    
    public func scrollDirection(_ value:UICollectionView.ScrollDirection = .vertical){
        flowLayout.scrollDirection = value
    }

    public func sectionInset(_ value:UIEdgeInsets){
        flowLayout.sectionInset = value
    }
    
    @available(iOS 11.0, *)
    public func sectionInsetReference(_ value:UICollectionViewFlowLayout.SectionInsetReference = .fromContentInset) {
        flowLayout.sectionInsetReference = value
    }
    
    public func sectionHeadersPinToVisibleBounds(_ value:Bool){
        flowLayout.sectionHeadersPinToVisibleBounds = value
    }
    
    public func itemRenderDirection(_ value :GridFlowLayout.ItemRenderDirection){
        flowLayout.itemRenderDirection = value
    }
    
    func removeNode(_ node:Any?){
        dataSourceHelper.removeNode(node)
        sectionHeaderSourceHelper.removeNode(node)
        sectionFooterSourceHelper.removeNode(node)
    }
    func removeAll(){
        dataSourceHelper.removeAll()
        dataSourceHelper.removeAll()
        sectionHeaderSourceHelper.removeAll()
    }
    
}

extension GridNode{
    func createNodeFromData(_ data: Any, helper: Any) {
        if pthread_main_np() != 0{
            return
        }
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
