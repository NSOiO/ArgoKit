//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class Grid<D>: ScrollView  {
    var gridNode:ArgoKitGridNode?
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

extension Grid{
    @discardableResult
    public func sectionHeader<T: ArgoKitIdentifiable>(_ data: [T], @ArgoKitListBuilder headerContent: @escaping (T) -> View) -> Self {
        gridNode?.headerSourceHelper.dataList = [data]
        gridNode?.headerSourceHelper.buildNodeFunc = { item in
            return headerContent(item as! T)
        }
        return self
    }
    
    @discardableResult
    public func sectionFooter<T: ArgoKitIdentifiable>(_ data: [T], @ArgoKitListBuilder footerContent: @escaping (T) -> View) -> Self {
        gridNode!.footerSourceHelper.dataList = [data]
        gridNode!.footerSourceHelper.buildNodeFunc = { item in
            return footerContent(item as! T)
        }
        return self
    }
}
