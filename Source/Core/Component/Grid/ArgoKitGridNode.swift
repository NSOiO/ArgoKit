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
            ArgoKitReusedLayoutHelper.forLayoutNode(ArgoKitGridCellNode.self,frame: self.bounds)
            oldFrame = self.frame
        }
        super.layoutSubviews()
    }
}
class ArgoKitGridNode: ArgoKitScrollViewNode,
                       UICollectionViewDelegate,
                       UICollectionViewDataSource,
                       UICollectionViewDelegateFlowLayout{
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.zero
    }
    
    lazy var dataSourceHelper = ArgoKitGridDataSourceHelper()
    lazy var headerSourceHelper = ArgoKitGridDataSourceHelper()
    lazy var footerSourceHelper = ArgoKitGridDataSourceHelper()
    
    private var pGridView:ArgoKitGridView?
    var flowLayout:ArgoKitGridFlowLayout = ArgoKitGridFlowLayout()
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
        return gridView
    }
}

extension ArgoKitGridNode {
        
    public func reloadData(data: [[ArgoKitIdentifiable]]?, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil) {
        
        if data != nil {
            self.dataSourceHelper.dataList = data
        }
        if sectionHeaderData != nil {
            self.headerSourceHelper.dataList = [sectionHeaderData!]
        }
        if sectionFooterData != nil {
            self.footerSourceHelper.dataList = [sectionFooterData!]
        }
        self.pGridView?.reloadData()
    }
        
    public func reloadSections(_ sectionData: [[ArgoKitIdentifiable]]?, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, sections: IndexSet, with animation: UITableView.RowAnimation) {
        
        if sectionHeaderData != nil
            || sectionHeaderData != nil
            || sectionFooterData != nil{
            
            for (index, value) in sections.enumerated() {
                if sectionHeaderData != nil {
                    self.dataSourceHelper.reloadSection(data: sectionData![index], section: value)
                }
                if sectionHeaderData != nil {
                    self.headerSourceHelper.reloadRow(rowData: sectionHeaderData![index], row: value, at: 0)
                }
                if sectionFooterData != nil {
                    self.footerSourceHelper.reloadRow(rowData: sectionFooterData![index], row: value, at: 0)
                }
            }
        }
        self.pGridView?.reloadSections(sections)
    }

    public func appendSections(_ data: [[ArgoKitIdentifiable]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, with animation: UITableView.RowAnimation) {
        
        let start = self.dataSourceHelper.dataList?.count ?? 0
        let end = start + data.count
        self.dataSourceHelper.appendSections(data)
        if sectionHeaderData != nil {
            self.headerSourceHelper.appendRows(rowData: sectionHeaderData!, at: 0)
        }
        if sectionFooterData != nil {
            self.footerSourceHelper.appendRows(rowData: sectionFooterData!, at: 0)
        }
        self.pGridView?.insertSections(IndexSet(start..<end))
    }
    
    public func insertSections(_ sectionData: [[ArgoKitIdentifiable]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation) {
                
        for (index, value) in sections.enumerated() {
            self.dataSourceHelper.insertSection(data: sectionData[index], section: value)
            
            if sectionHeaderData != nil {
                self.headerSourceHelper.insertRow(rowData: sectionHeaderData![index], row: value, at: 0)
            }
            if sectionFooterData != nil {
                self.footerSourceHelper.insertRow(rowData: sectionFooterData![index], row: value, at: 0)
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
    
    public func reloadRowsHeight(indexPath:IndexPath) {
        print("indexPath=\(indexPath)")
        self.pGridView?.performBatchUpdates({[weak self] in
            self?.pGridView?.reloadItems(at: [indexPath])
        }, completion: { result in
            
        })
       
    }
}

// MARK: UICollectionViewDataSource
extension ArgoKitGridNode{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSourceHelper.numberOfSection()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSourceHelper.numberOfRows(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.dataSourceHelper.reuseIdForRow(indexPath.row, at: indexPath.section) ?? kGridCellReuseIdentifier
        if !self.dataSourceHelper.registedReuseIdSet.contains(identifier) {
            pGridView?.register(ArgoKitGridCell.self, forCellWithReuseIdentifier: identifier)
            self.dataSourceHelper.registedReuseIdSet.insert(identifier)
        }
        let cell = pGridView?.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ArgoKitGridCell
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            cell.linkCellNode(node)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionViewLayout is ArgoKitGridFlowLayout {
            let layout = collectionViewLayout as! ArgoKitGridFlowLayout
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
        print("indexPath:\(indexPath)")
        var dataSourceHelper:ArgoKitGridDataSourceHelper? = nil
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
                pGridView?.register(ArgoKitGridCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
                dataSourceHelper.registedReuseIdSet.insert(identifier)
            }
            let reusableView = pGridView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! ArgoKitGridCell
            if let node = dataSourceHelper.nodeForRow(indexPath.section, at: 0) {
                reusableView.linkCellNode(node)
            }
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let width = collectionView.frame.size.width
        let height = self.headerSourceHelper.rowHeight(section, at:0, maxWidth:width)
        return CGSize(width:width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        let width = collectionView.frame.size.width
        let height = self.footerSourceHelper.rowHeight(section, at:0, maxWidth:width)
        return CGSize(width:width, height: height)
    }
    

//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool{
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
//        
//    }
//
//
//    func indexTitles(for collectionView: UICollectionView) -> [String]?{
//        return []
//    }
//
//    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath{
//        return IndexPath(index: 0)
//    }
}

// MARK: UICollectionViewDelegate Select
extension ArgoKitGridNode{
    
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
extension ArgoKitGridNode{
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool{
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:didHighlightItemAt:))
        if  let color = self.sendAction(withObj: String(_sel: sel), paramter: nil) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }

    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        let sel = #selector(self.collectionView(_:didUnhighlightItemAt:))
        if  let color = self.sendAction(withObj: String(_sel: sel), paramter: nil) as? UIColor {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = color
        }
    }
}

// MARK: UICollectionViewDelegate Display
extension ArgoKitGridNode{
    @available(iOS 8.0, *)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if let node = self.dataSourceHelper.nodeForRow(indexPath.row, at: indexPath.section) {
            node.indexpath = indexPath
            node.observeFrameChanged {[weak self] (_, _) in
                self?.reloadRowsHeight(indexPath: node.indexpath)
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
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath){
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ArgoKitGridNode{


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
extension ArgoKitGridNode{
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
