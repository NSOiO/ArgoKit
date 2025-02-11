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
    private var oldFrame = CGRect.zero
    var reLayoutAction:((CGRect)->())?
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            if let action = reLayoutAction {
                action(self.bounds)
            }
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
}

class GridNode<D>: ArgoKitScrollViewNode,
                       UICollectionViewDelegate,
                       UICollectionViewDataSource,
                       GridDelegateFlowLayout,
                       GridDelegateWaterfallLayout,
                       DataSourceReloadNode
{

    deinit {
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
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
    
    // 支持移动重排
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    fileprivate var moveItem = false
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
    private var pGridView: ArgoKitGridView?
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
        if #available(iOS 11.0, *) {
            gridView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 10.0, *) {
            gridView.isPrefetchingEnabled = false
        }
        gridView.alwaysBounceVertical = true
        
        if moveItem {
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
        return gridView
    }

    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
        
            case UIGestureRecognizerState.began:
                guard let selectedIndexPath = pGridView?.indexPathForItem(at: gesture.location(in: self.pGridView)) else    {
                    break
                }
                pGridView?.beginInteractiveMovementForItem(at: selectedIndexPath)
            case UIGestureRecognizerState.changed:
                pGridView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            case UIGestureRecognizerState.ended:
                pGridView?.endInteractiveMovement()
            default:
                pGridView?.cancelInteractiveMovement()
        }
    }

    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSourceHelper.numberOfSection()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceHelper.numberOfRows(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.dataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kGridCellReuseIdentifier
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            pGridView?.register(GridCell.self, forCellWithReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = pGridView?.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GridCell
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.linkCellNode(node)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if let layout = collectionViewLayout as? GridFlowLayout {
            var height = layout.itemHeight
            let itemWidth = layout.itemWidth(inSection: indexPath.section)
            let calculateHeight = self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: itemWidth)
            if height == 0{
                height = calculateHeight
            }
            return CGSize(width:itemWidth, height: height)
        }
        return CGSize.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var dataSourceHelper:DataSourceHelper<D>? = nil
        var reuseIdentifier:String = kGridHeaderReuseIdentifier
        if kind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.sectionHeaderSourceHelper
            reuseIdentifier = kGridHeaderReuseIdentifier
        }else if kind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.sectionFooterSourceHelper
            reuseIdentifier = kGridFooterReuseIdentifier
        }
        if let dataSourceHelper = dataSourceHelper {
            let identifier = dataSourceHelper.reuseIdForRow(indexPath.section, at: 0) ?? reuseIdentifier
            if !dataSourceHelper.registedReuseIdSet.contains(identifier) {
                pGridView?.register(GridCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
                dataSourceHelper.registedReuseIdSet.insert(identifier)
            }
            let reusableView = pGridView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! GridCell
            if let node = dataSourceHelper.nodeForRow(indexPath.section, at: 0) {
                reusableView.linkCellNode(node)
            }
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let width = collectionView.frame.size.width
        var height = self.sectionHeaderSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if let layout = collectionViewLayout as? GridFlowLayout{
            if layout.headerHeight > 0 {
                height = layout.headerHeight
            }
        }
        return CGSize(width:width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        let width = collectionView.frame.size.width
        var height = self.sectionFooterSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if collectionViewLayout is GridFlowLayout {
            let layout = collectionViewLayout as! GridFlowLayout
            if layout.footerHeight > 0 {
                height = layout.footerHeight
            }
        }
        return CGSize(width:width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool{
        return moveItem
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        var items = self.dataSourceHelper.sectionDataSourceList?[sourceIndexPath.section]
        let temp = items?.remove(at: sourceIndexPath.item)
        items?.insert((temp)!, at: destinationIndexPath.item)
        if let items = items{
            self.dataSourceHelper.sectionDataSourceList?[sourceIndexPath.section] = items
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
    
    
    /*
     // 使用默认实现
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
        return false
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool // called when the user taps on an already-selected item in multi-select mode
    {
        return false
    }
 */
    // MARK: - UICollectionViewDelegate Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didSelectItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didHighlightItemAt:))
        if let color = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:willDisplay:forItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            ArgoKitReusedLayoutHelper.removeLayoutNode(node)
        }
        let sel = #selector(self.collectionView(_:didEndDisplaying:forItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    
    // MARK: - HEADER OR FOOTER
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath){
        var dataSourceHelper:DataSourceHelper<D>? = nil
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.sectionHeaderSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.sectionFooterSourceHelper
        }
        if let node = dataSourceHelper?.nodeForRow(indexPath.section, at: 0) {
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
        guard let data = dataSourceHelper?.dataForRow(indexPath.section, at: 0) else {
            return
        }
        if let node = self.dataSourceHelper.nodeForRow(indexPath.section, at: 0) {
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
            dataSourceHelper = self.sectionHeaderSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.sectionFooterSourceHelper
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
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.collectionView(_:shouldShowMenuForItemAt:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return false
        }
        let sel = #selector(self.collectionView(_:canPerformAction:forItemAt:withSender:))
        if let s_sender = sender {
            return self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender]) as? Bool ?? false
        }
        return self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath]) as? Bool ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:performAction:forItemAt:withSender:))
        if let s_sender = sender {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath, s_sender])
        } else {
            self.sendAction(withObj: String(_sel: sel), paramter: [action, data, indexPath])
        }
    }
    

    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
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
     * @abstract Called when the interaction begins. Return a UITargetedPreview describing the desired highlight preview.
     *
     * @param collectionView  This UICollectionView.
     * @param configuration   The configuration of the menu about to be displayed by this interaction.
     */
//    @available(iOS 13.0, *)
//    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview{
//        let sel = #selector(self.collectionView(_:previewForHighlightingContextMenuWithConfiguration:))
//        if let view = self.sendAction(withObj: String(_sel: sel), paramter:nil)  as? UIView{
//            if let containerView = self.view {
//                let previewTarget = UIPreviewTarget(container: containerView, center: containerView.center)
//                let previewParams = UIPreviewParameters()
//                previewParams.backgroundColor = .clear
//                return UITargetedPreview(view: view, parameters: previewParams, target: previewTarget)
//            }
//        }
//        return nil
//    }

    
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
    
    
}
extension GridNode{
    public func visibleModelCells() -> [(D,UICollectionViewCell)] {
        var models:[(D,UICollectionViewCell)] = []
        if let pGridView = self.pGridView{
            let cells = pGridView.visibleCells
            for cell in cells {
                if let indexPath = pGridView.indexPath(for: cell){
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
        if let pGridView = self.pGridView{
            let cells = pGridView.visibleCells
            for cell in cells {
                if let indexPath = pGridView.indexPath(for: cell){
                    if let model = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) as? D{
                        models.append(model)
                    }
                }
            }
        }
        return models
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
    
    public func reloadRowsHeight() {
        if let gridView = self.pGridView{
            gridView.performBatchUpdates(nil, completion: nil)
        }
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
    
    public func footerHeight(_ value:CGFloat){
        flowLayout.footerHeight = value
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
