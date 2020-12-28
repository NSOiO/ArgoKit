//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class List<D>: ScrollView  {
        
    var tableNode: TableNode<D> {
        pNode as! TableNode
    }
    
    override func createNode() {
        pNode = TableNode<D>(viewClass: UITableView.self)
        pNode?.flexGrow(1.0)
    }
    
    required init(style: UITableView.Style?) {
        super.init()
        tableNode.style = style ?? .plain
    }
    
    required public convenience init() {
        self.init(style: .plain)
    }
    
    public convenience init(style: UITableView.Style? = .plain, @ArgoKitListBuilder content: @escaping () -> View) where D : ArgoKitNode {
        self.init(style: style)
        let container = content()
        if let nodes = container.type.viewNodes() {
            tableNode.dataSourceHelper.nodeSourceList?.wrappedValue.append(nodes)
        }
    }

    public convenience init(_ style: UITableView.Style? = .plain,
                            data: DataSource<DataList<D>>,
                            @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init(style: style)
        
        tableNode.dataSourceHelper.dataSourceList = data
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
    
    public convenience init(_ style: UITableView.Style? = .plain,
                            data: DataSource<SectionDataList<D>>,
                            @ArgoKitListBuilder rowContent: @escaping (D) -> View) where D:ArgoKitIdentifiable{
        self.init(style: style)
        tableNode.dataSourceHelper.sectionDataSourceList = data
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}

extension List{
    @discardableResult
    public func tableHeaderView(@ArgoKitViewBuilder headerContent: @escaping () -> View) -> Self {
        let container = headerContent()
        tableNode.tableHeaderNode = container.type.viewNode()
        return self
    }
    
    @discardableResult
    public func tableFooterView(@ArgoKitViewBuilder footerContent: @escaping () -> View) -> Self {
        let container = footerContent()
        tableNode.tableFooterNode = container.type.viewNode()
        return self
    }
    
    @discardableResult
    public func sectionHeader(_ data:  DataSource<DataList<D>>, @ArgoKitListBuilder headerContent: @escaping (D) -> View) -> Self where D:ArgoKitIdentifiable{
        tableNode.sectionHeaderSourceHelper.dataSourceList = data
        tableNode.sectionHeaderSourceHelper.buildNodeFunc = { item in
            return headerContent(item)
        }
        return self
    }
    
    @discardableResult
    public func sectionFooter(_ data: DataSource<DataList<D>>, @ArgoKitListBuilder footerContent: @escaping (D) -> View) -> Self where D:ArgoKitIdentifiable{
        tableNode.sectionFooterSourceHelper.dataSourceList = data
        tableNode.sectionFooterSourceHelper.buildNodeFunc = { item in
            return footerContent(item)
        }
        return self
    }
}

