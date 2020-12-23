//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class Grid<D>: ScrollView  {
    var gridNode:GridNode?
    override func createNode() {
        gridNode = GridNode(viewClass: ArgoKitGridView.self)
        pNode = gridNode
    }
    public required init() {
        super.init()
    }
    
    public convenience init(waterfall:Bool = false,@ArgoKitListBuilder content: @escaping () -> View) where D : ArgoKitNode {
        self.init()
        gridNode?.waterfall(waterfall)
        let container = content()
        if let nodes = container.type.viewNodes() {
            gridNode?.dataSourceHelper.dataList?.wrappedValue = [nodes]
        }
    }

    public convenience init(waterfall:Bool = false,data: DataBind<Array<Array<Any>>>, @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        gridNode?.waterfall(waterfall)
        gridNode?.dataSourceHelper.dataList = data
//        gridNode?.setDataSourceList(data: data)
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            if let item = item as? D{
                return rowContent(item)
            }
            return nil
        }
    }
    
    public convenience init(waterfall:Bool = false,sectionData: DataBind<Array<Array<D>>>, @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init()
        gridNode?.waterfall(waterfall)
//        gridNode?.dataSourceHelper.dataList = sectionData
//        gridNode?.setDataSourceList(data: sectionData)
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            if let item = item as? D{
                return rowContent(item)
            }
            return nil
        }
    }
}


extension Grid{
    
//    @discardableResult
//    public func sectionHeader(@ArgoKitListBuilder headerContent: @escaping () -> View) -> Self {
//        let container = headerContent()
//        if let nodes = container.type.viewNodes() {
//            gridNode?.headerSourceHelper.dataList = [nodes]
//        }
//        return self
//    }
//    
//    @discardableResult
//    public func sectionHeader<T: ArgoKitIdentifiable>(data: [T], @ArgoKitListBuilder headerContent: @escaping (T) -> View) -> Self {
//        gridNode?.headerSourceHelper.dataList = [data]
//        gridNode?.headerSourceHelper.buildNodeFunc = { item in
//            if let item = item as? T{
//                return headerContent(item)
//            }
//            return nil
//        }
//        return self
//    }
//    
//    @discardableResult
//    public func sectionFooter(@ArgoKitListBuilder headerContent: @escaping () -> View) -> Self {
//        let container = headerContent()
//        if let nodes = container.type.viewNodes() {
//            gridNode?.footerSourceHelper.dataList = [nodes]
//        }
//        return self
//    }
//    
//    @discardableResult
//    public func sectionFooter<T: ArgoKitIdentifiable>(data: [T], @ArgoKitListBuilder footerContent: @escaping (T) -> View) -> Self {
//        gridNode?.footerSourceHelper.dataList = [data]
//        gridNode?.footerSourceHelper.buildNodeFunc = { item in
//            if let item = item as? T {
//                return footerContent(item)
//            }
//           return nil
//        }
//        return self
//    }
}
