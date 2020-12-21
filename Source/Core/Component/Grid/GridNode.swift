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
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            ArgoKitReusedLayoutHelper.forLayoutNode(ArgoKitCellNode.self,frame: self.bounds)
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
}


class GridNode: ArgoKitScrollViewNode,
                       UICollectionViewDelegate,
                       UICollectionViewDataSource,
                       UICollectionViewDelegateFlowLayout{
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.zero
    }
    
    
    lazy var dataSourceHelper = ArgoKitDataSourceHelper()
    lazy var headerSourceHelper = ArgoKitDataSourceHelper()
    lazy var footerSourceHelper = ArgoKitDataSourceHelper()
    
    // 支持移动重排
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    fileprivate var moveItem = false
    
    // 支持preview context menu
//    @available(iOS 13.0, *)
//    private var menuActions:[UIAction]?
    
    private var pGridView:ArgoKitGridView?
    
    var flowLayout:GridFlowLayout = GridFlowLayout()
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let gridView = ArgoKitGridView(frame: frame, collectionViewLayout:flowLayout)
        gridView.backgroundColor = .white
        flowLayout.frame = frame
        pGridView = gridView
        gridView.delegate = self
        gridView.dataSource = self
        if #available(iOS 11.0, *) {
            gridView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 10.0, *) {
            gridView.isPrefetchingEnabled = false
        }
        
        if moveItem {
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(GridNode.handleLongGesture(_:)))
            gridView.addGestureRecognizer(longPressGesture)
            
        }
        
        return gridView
    }

    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = pGridView?.indexPathForItem(at: gesture.location(in: self.pGridView)) else {
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
}

extension GridNode {
        
    public func reloadData(data: [[ArgoKitIdentifiable]]?, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil) {
        
        if let data = data {
            self.dataSourceHelper.dataList = data
        }
        
        if let sectionHeaderData = sectionHeaderData {
            self.headerSourceHelper.dataList = [sectionHeaderData]
        }
        if let sectionFooterData =  sectionFooterData{
            self.footerSourceHelper.dataList = [sectionFooterData]
        }
        self.pGridView?.reloadData()
    }
        
    public func reloadSections(_ sectionData: [[ArgoKitIdentifiable]]?, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, sections: IndexSet, with animation: UITableView.RowAnimation) {
        /*
        if sectionData != nil
            || sectionHeaderData != nil
            || sectionFooterData != nil{
            
            for (index, value) in sections.enumerated() {
                if let sectionData = sectionData {
                    self.dataSourceHelper.reloadSection(data: sectionData[index], section: value)
                }
                if let sectionHeaderData = sectionHeaderData {
                    self.headerSourceHelper.reloadRow(rowData: sectionHeaderData[index], row: value, at: 0)
                }
                if let sectionFooterData = sectionFooterData {
                    self.footerSourceHelper.reloadRow(rowData: sectionFooterData[index], row: value, at: 0)
                }
            }
        }
*/
        for (index, value) in sections.enumerated() {
            if let sectionData = sectionData {
                self.dataSourceHelper.reloadSection(data: sectionData[index], section: value)
            }
            if let sectionHeaderData = sectionHeaderData {
                self.headerSourceHelper.reloadRow(rowData: sectionHeaderData[index], row: value, at: 0)
            }
            if let sectionFooterData = sectionFooterData {
                self.footerSourceHelper.reloadRow(rowData: sectionFooterData[index], row: value, at: 0)
            }
        }
        self.pGridView?.reloadSections(sections)
    }

    public func appendSections(_ data: [[ArgoKitIdentifiable]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, with animation: UITableView.RowAnimation) {
        
        let start = self.dataSourceHelper.dataList?.count ?? 0
        let end = start + data.count
        self.dataSourceHelper.appendSections(data)
        if let sectionHeaderData = sectionHeaderData {
            self.headerSourceHelper.appendRows(rowData: sectionHeaderData, at: 0)
        }
        if let sectionFooterData = sectionFooterData {
            self.footerSourceHelper.appendRows(rowData: sectionFooterData, at: 0)
        }
        self.pGridView?.insertSections(IndexSet(start..<end))
    }
    
    public func insertSections(_ sectionData: [[ArgoKitIdentifiable]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation) {
                
        for (index, value) in sections.enumerated() {
            self.dataSourceHelper.insertSection(data: sectionData[index], section: value)
            
            if let sectionHeaderData = sectionHeaderData {
                self.headerSourceHelper.insertRow(rowData: sectionHeaderData[index], row: value, at: 0)
            }
            if let sectionFooterData = sectionFooterData {
                self.footerSourceHelper.insertRow(rowData: sectionFooterData[index], row: value, at: 0)
            }
        }
        self.pGridView?.insertSections(sections)
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        
        for index in sections {
            self.dataSourceHelper.deleteSection(index)
        }
        self.pGridView?.deleteSections(sections)
    }
    
    public func moveSection(_ section: Int, toSection newSection: Int) {
        
        self.dataSourceHelper.moveSection(section, toSection: newSection)
        self.pGridView?.moveSection(section, toSection: newSection)
    }
    
    public func reloadRows(_ rowData: [ArgoKitIdentifiable]?, at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        
        if let datas = rowData {
            for (index, indexPath) in indexPaths.enumerated() {
                self.dataSourceHelper.reloadRow(rowData: datas[index], row: indexPath.row, at: indexPath.section)
            }
        }
        self.pGridView?.reloadItems(at: indexPaths)
    }
    
    public func appendRows(_ rowData: [ArgoKitIdentifiable], at section: Int = 0, with animation: UITableView.RowAnimation) {
        
        var start = 0
        if section > self.dataSourceHelper.dataList?.count ?? 0 {
            start = self.dataSourceHelper.dataList?.count ?? 0
        } else {
            start = self.dataSourceHelper.dataList?[section].count ?? 0
        }
        self.dataSourceHelper.appendRows(rowData: rowData, at: section)
        var indexPaths = [IndexPath]()
        for index in (0..<rowData.count) {
            indexPaths.append(IndexPath(row: start + index, section: section))
        }
        self.pGridView?.insertItems(at: indexPaths)
    }
    
    public func insertRows(_ rowData: [ArgoKitIdentifiable], at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {

        for (index, indexPath) in indexPaths.enumerated() {
            self.dataSourceHelper.insertRow(rowData: rowData[index], row: indexPath.row, at: indexPath.section)
        }
        self.pGridView?.insertItems(at: indexPaths)
    }
    
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        
        for indexPath in indexPaths {
            self.dataSourceHelper.deleteRow(indexPath.row, at: indexPath.section)
        }
        self.pGridView?.deleteItems(at: indexPaths)
    }
    
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        
        self.dataSourceHelper.moveRow(at: indexPath, to: newIndexPath)
        self.pGridView?.moveItem(at: indexPath, to: newIndexPath)
    }
    
    public func reloadRowsHeight() {
        self.pGridView?.performBatchUpdates(nil, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension GridNode{
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
        if collectionViewLayout is GridFlowLayout {
            let layout = collectionViewLayout as! GridFlowLayout
            var height = layout.itemHeight
            let calculateHeight = self.dataSourceHelper.rowHeight(indexPath.row, at: indexPath.section, maxWidth: layout.width)
            if height == 0{
                height = calculateHeight
            }
            return CGSize(width:layout.width, height: height)
        }
        return flowLayout.itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var dataSourceHelper:ArgoKitDataSourceHelper? = nil
        var reuseIdentifier:String = kGridHeaderReuseIdentifier
        if kind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.headerSourceHelper
            reuseIdentifier = kGridHeaderReuseIdentifier
        }else if kind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.footerSourceHelper
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
        var height = self.headerSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if let layout = collectionViewLayout as? GridFlowLayout{
            if layout.headerHeiht > 0 {
                height = layout.headerHeiht
            }
        }
        return CGSize(width:width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        let width = collectionView.frame.size.width
        var height = self.footerSourceHelper.rowHeight(section, at:0, maxWidth:width)
        if collectionViewLayout is GridFlowLayout {
            let layout = collectionViewLayout as! GridFlowLayout
            if layout.headerHeiht > 0 {
                height = layout.headerHeiht
            }
        }
        return CGSize(width:width, height: height)
    }
    

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool{
        return moveItem
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        var items = self.dataSourceHelper.dataList?[sourceIndexPath.section]
        let temp = items?.remove(at: sourceIndexPath.item)
        items?.insert(temp as Any, at: destinationIndexPath.item)
        if let items = items{
            self.dataSourceHelper.dataList?[sourceIndexPath.section] = items
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
}

// MARK: UICollectionViewDelegate Select
extension GridNode{
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
//        return false
//    }
//
//    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool // called when the user taps on an already-selected item in multi-select mode
//    {
//        return false
//    }

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
}

// MARK: UICollectionViewDelegate Highlight
extension GridNode{
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool{
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didHighlightItemAt:))
        if let color = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }

    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didUnhighlightItemAt:))
        if  let color = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath]) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }
    }
}

// MARK: UICollectionViewDelegate Display
extension GridNode{
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
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
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.removeObservingFrameChanged()
        }
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return
        }
        let sel = #selector(self.collectionView(_:didEndDisplaying:forItemAt:))
        self.sendAction(withObj: String(_sel: sel), paramter: [data, indexPath])
    }

    
    // MARK: HEADER OR FOOTER
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath){
        var dataSourceHelper:ArgoKitDataSourceHelper? = nil
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.headerSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.footerSourceHelper
        }
        if let node = dataSourceHelper?.nodeForRow(indexPath.row, at: indexPath.section) {
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight()
            }
        }
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath){
        var dataSourceHelper:ArgoKitDataSourceHelper? = nil
        if elementKind ==  UICollectionView.elementKindSectionHeader{
            dataSourceHelper = self.headerSourceHelper
        }else if elementKind ==  UICollectionView.elementKindSectionFooter{
            dataSourceHelper = self.footerSourceHelper
        }
        if let node = dataSourceHelper?.nodeForRow(indexPath.row, at: indexPath.section) {
            node.removeObservingFrameChanged()
        }
        
    }
}

// MARK: UICollectionViewDelegate Menu
extension GridNode{
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
    

    /**
     * @abstract Called when the interaction begins.
     *
     * @param collectionView  This UICollectionView.
     * @param indexPath       IndexPath of the item for which a configuration is being requested.
     * @param point           Location in the collection view's coordinate space
     *
     * @return A UIContextMenuConfiguration describing the menu to be presented. Return nil to prevent the interaction from beginning.
     *         Returning an empty configuration causes the interaction to begin then fail with a cancellation effect. You might use this
     *         to indicate to users that it's possible for a menu to be presented from this element, but that there are no actions to
     *         present at this particular time.
     */
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        guard let data = self.dataSourceHelper.dataForRow(indexPath.row, at: indexPath.section) else {
            return nil
        }
        let sel = #selector(self.collectionView(_:contextMenuConfigurationForItemAt:point:))
        if let children = self.sendAction(withObj: String(_sel: sel), paramter: [data,indexPath, point])  as? [UIMenuElement]{
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "Actions", children:children)
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
//        return UITargetedPreview(view: UIView())
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

    
}

// MARK: UICollectionViewDelegateFlowLayout
extension GridNode{


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
//
//    }
//
//

}







//MARK: 设置配置参数
extension GridNode{
    
    public func enableMoveItem(_ value:Bool){
        self.moveItem = value
    }
    
    public func itemHeight(_ value:CGFloat){
        flowLayout.itemHeight = value
    }
    
    public func columnCount(_ value:Int){
        flowLayout.columCount = value
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
    
    public func headerReferenceSize(_ value:CGSize = CGSize.zero){
        flowLayout.headerReferenceSize = value
    }
    
    public func footerReferenceSize(_ value:CGSize = CGSize.zero){
        flowLayout.footerReferenceSize = value
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
    
    public func sectionFootersPinToVisibleBounds(_ value:Bool){
        flowLayout.sectionFootersPinToVisibleBounds = value
    }
    
}
