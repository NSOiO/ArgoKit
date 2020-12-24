//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class Grid<D>: ScrollView{
    var gridNode:GridNode<D>?
    override func createNode() {
        gridNode = GridNode(viewClass: ArgoKitGridView.self)
        pNode = gridNode
    }
    public required init() {
        super.init()
    }
    
//    public convenience init(waterfall:Bool = false,data: D, @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:RandomAccessCollection,D.Element:ArgoKitIdentifiable{
//        self.init()
//        gridNode?.waterfall(waterfall)
//        gridNode?.dataSourceHelper.dataSourceList = data
//        gridNode?.dataSourceHelper.buildNodeFunc = { item in
//            return rowContent(item)
//        }
//    }
    
    public convenience init(waterfall:Bool = false,@ArgoKitListBuilder content: @escaping () -> View) where D:ArgoKitNode{
        self.init()
        gridNode?.waterfall(waterfall)
        let container = content()
        if let nodes = container.type.viewNodes() {
            gridNode?.dataSourceHelper.nodeSourceList?.wrappedValue?.append(nodes)
        }
    }

    public convenience init(waterfall:Bool = false,data: DataSource<DataList<D>>, @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        gridNode?.waterfall(waterfall)
        gridNode?.dataSourceHelper.dataSourceList = data
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
    
    public convenience init(waterfall:Bool = false,sectionData: DataSource<SectionDataList<D>>, @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        gridNode?.waterfall(waterfall)
        gridNode?.dataSourceHelper.sectionDataSourceList = sectionData
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}


extension Grid{
    
    @discardableResult
    public func sectionHeader(@ArgoKitListBuilder headerContent: @escaping () -> View) -> Self {
        let container = headerContent()
        if let nodes = container.type.viewNodes() {
            gridNode?.headerSourceHelper.nodeSourceList?.wrappedValue?.append(nodes)
        }
        return self
    }
    
    @discardableResult
    public func sectionHeader(data:DataSource<DataList<D>>, @ArgoKitListBuilder headerContent: @escaping (D) -> View) -> Self where D: ArgoKitIdentifiable{
        gridNode?.headerSourceHelper.dataSourceList = data
        gridNode?.headerSourceHelper.buildNodeFunc = { item in
            return headerContent(item)
        }
        return self
    }
    
    @discardableResult
    public func sectionFooter(@ArgoKitListBuilder footerContent: @escaping () -> View) -> Self {
        let container = footerContent()
        if let nodes = container.type.viewNodes() {
            gridNode?.footerSourceHelper.nodeSourceList?.wrappedValue?.append(nodes)
        }
        return self
    }
    
    @discardableResult
    public func sectionFooter(data:DataSource<DataList<D>>, @ArgoKitListBuilder footerContent: @escaping (D) -> View) -> Self where D: ArgoKitIdentifiable{
        gridNode?.headerSourceHelper.dataSourceList = data
        gridNode?.footerSourceHelper.buildNodeFunc = { item in
            return footerContent(item)
        }
        return self
    }
}
