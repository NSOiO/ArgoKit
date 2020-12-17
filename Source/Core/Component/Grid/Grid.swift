//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class Grid<D>: ScrollView  {
    private var gridNode:ArgoKitGridNode?
    override func createNode() {
        gridNode = ArgoKitGridNode(viewClass: ArgoKitGridView.self)
        pNode = gridNode
    }
    public required init() {
        super.init()
    }
    
    public convenience init(style: UITableView.Style? = .plain, @ArgoKitListBuilder content: @escaping () -> View) where D : ArgoKitNode {
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            gridNode?.dataSourceHelper.dataList = [nodes]
        }
    }

    public convenience init(data: [D], @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        
        gridNode?.dataSourceHelper.dataList = [data]
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! D)
        }
    }
    
    public convenience init(sectionData: [[D]], @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        gridNode?.dataSourceHelper.dataList = sectionData
        gridNode!.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! D)
        }
    }
}

//MARK: 设置配置参数
extension Grid{
    @discardableResult
    public func maxItemHeight(_ value:CGFloat = 0) -> Self{
        gridNode?.maxItemHeight(value)
        return self
    }
    
    @discardableResult
    public func columnCount(_ value:Int = 1) -> Self{
        gridNode?.columnCount(value)
        return self
    }

    public func columnSpacing(_ value:CGFloat = 0) -> Self{
        gridNode?.columnSpacing(value)
        return self
        
    }
    
    public func lineSpacing(_ value:CGFloat = 0) -> Self{
        gridNode?.lineSpacing(value)
        return self
    }
    
    public func estimatedItemSize(_ value:CGSize = CGSize.zero) -> Self{
        gridNode?.estimatedItemSize(value)
        return self
    }
    
    public func scrollDirection(_ value:UICollectionView.ScrollDirection = .vertical)->Self{
        gridNode?.scrollDirection(value)
        return self
    }
    
    public func headerReferenceSize(_ value:CGSize = CGSize.zero) ->Self {
        gridNode?.headerReferenceSize(value)
        return self
    }
    
    public func footerReferenceSize(_ value:CGSize = CGSize.zero) ->Self {
        gridNode?.footerReferenceSize(value)
        return self
    }

    public func sectionInset(_ value:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )) -> Self {
        gridNode?.sectionInset(value)
        return self
    }
    
    @available(iOS 11.0, *)
    public func sectionInsetReference(_ value:UICollectionViewFlowLayout.SectionInsetReference = .fromContentInset) -> Self {
        gridNode?.sectionInsetReference(value)
        return self
    }
    
    public func sectionHeadersPinToVisibleBounds(_ value:Bool = false) -> Self {
        gridNode?.sectionHeadersPinToVisibleBounds(value)
        return self
    }
    
    public func sectionFootersPinToVisibleBounds(_ value:Bool = false) -> Self {
        gridNode?.sectionFootersPinToVisibleBounds(value)
        return self
    }
}

//MARK: Reload
extension Grid {
        
    public func reloadData(_ data: [D]? = nil, sectionHeaderData: ArgoKitIdentifiable? = nil, sectionFooterData: ArgoKitIdentifiable? = nil)  ->Self where D : ArgoKitIdentifiable{
        gridNode?.reloadData(data: data != nil ? [data!] : nil, sectionHeaderData: (sectionHeaderData != nil) ? [sectionHeaderData!] : nil, sectionFooterData: (sectionFooterData != nil) ? [sectionFooterData!] : nil)
        return self
    }
    
    public func reloadData(_ sectionData: [[D]]? = nil, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil)  ->Self where D : ArgoKitIdentifiable{
        gridNode?.reloadData(data: sectionData, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData)
        return self
    }
    
    public func reloadSections(_ sectionData: [[D]]? = nil, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, sections: IndexSet, with animation: UITableView.RowAnimation)  ->Self where D : ArgoKitIdentifiable{
        gridNode?.reloadSections(sectionData, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, sections: sections, with: animation)
        return self
    }
    
    public func appendSections(_ data: [[D]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, with animation: UITableView.RowAnimation)  ->Self where D : ArgoKitIdentifiable{
        gridNode?.appendSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, with: animation)
        return self
    }
    
    public func insertSections(_ data: [[D]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation)  ->Self where D : ArgoKitIdentifiable{
        gridNode?.insertSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, at: sections, with: animation)
        return self
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
        gridNode?.deleteSections(sections, with: animation)
        return self
    }
    
    public func moveSection(_ section: Int, toSection newSection: Int) ->Self{
        gridNode?.moveSection(section, toSection: newSection)
        return self
    }
    
    public func reloadRows(_ rowData: [D]?, at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self where D : ArgoKitIdentifiable{
        gridNode?.reloadRows(rowData, at: indexPaths, with: animation)
        return self
    }
    
    public func appendRows(_ rowData: [D], at section: Int = 0, with animation: UITableView.RowAnimation) ->Self  where D : ArgoKitIdentifiable{
        gridNode?.appendRows(rowData, at: section, with: animation)
        return self
    }
    
    public func insertRows(_ rowData: [D], at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)  ->Self  where D : ArgoKitIdentifiable{
        gridNode?.insertRows(rowData, at: indexPaths, with: animation)
        return self
    }
    
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self {
        gridNode?.deleteRows(at: indexPaths, with: animation)
        return self
    }
        
    @discardableResult
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)->Self{
        gridNode?.moveRow(at: indexPath, to: newIndexPath)
        return self
    }
}

// MARK: action observer
extension Grid{
    @discardableResult
    public func didSelectItem(_ action:@escaping (_ data: D, _ indexPath: IndexPath) -> Void) ->Self {
        let sel = #selector(ArgoKitGridNode.collectionView(_:didSelectItemAt:))
        gridNode?.observeAction(String(_sel: sel), actionBlock: { (obj, paramter) -> Any? in
            if paramter?.count ?? 0 >= 2 {
                let data: D = paramter![0] as! D
                let indexPath: IndexPath = paramter![1] as! IndexPath
                action(data, indexPath)
            }
            return nil
        })
        return self
    }
}
