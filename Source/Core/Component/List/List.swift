//
//  List.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

/// Wrapper of UITableView
/// A view that presents data using rows arranged in a single column.
///
/// Example:
///
///```
///     struct ListView: View {
///
///         @DataSource var dataSource: [Model] = [Model]()
///         @DataSource var headerDataSource: [Model] = [Model]()
///         @DataSource var footerDataSource: [Model] = [Model]()
///
///         var body: View {
///
///             List(data:$dataSource){ data in
///                 Row(data)
///             }
///             .sectionHeader($headerDataSource) { data in
///                 Header(data)
///             }
///             .sectionFooter($footerDataSource) { data in
///                 Footer(data)
///             }
///             .didSelectRow { (data, index) in
///                 // Did Select row action
///             }
///         }
///
///         func appendData(data: Model) {
///             $dataSource.append(data)
///             $dataSource.apply()
///         }
///     }
///```
///
public class List<D>: ScrollView  {
    
    /// The node behind the list.
    var tableNode: TableNode<D> {
        pNode as! TableNode
    }
    
    override func createNode() {
        pNode = TableNode<D>(viewClass: TableView.self)
    }
    
    required init(style: UITableView.Style?) {
        super.init()
        tableNode.style = style ?? .plain
    }
    
    required convenience init() {
        self.init(style: .plain)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - style: Constants for the list styles.
    ///   - content: The content of the list.
    ///
    ///```
    ///     List {
    ///         Row1()
    ///         Row2()
    ///         Row3()
    ///     }
    ///```
    ///
    public convenience init(style: UITableView.Style? = .plain, @ArgoKitListBuilder content: @escaping () -> View) where D : ArgoKitNode {
        self.init(style: style)
        let container = content()
        if let nodes = container.type.viewNodes() {
            tableNode.dataSourceHelper.nodeSourceList?.append(contentsOf:[nodes])
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - style: Constants for the list styles.
    ///   - data: The data for populating the list.
    ///   - rowContent: A view builder that creates the view for a single row of the list.
    ///
    ///```
    ///     List(data: $dataSource) { item in
    ///         Row(item)
    ///     }
    ///```
    ///
    public convenience init(_ style: UITableView.Style? = .plain,
                            data: DataSource<DataList<D>>,
                            @ArgoKitListBuilder rowContent: @escaping (D) -> View) {
        self.init(style: style)
        
        tableNode.dataSourceHelper.dataSourceList = data
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - style: Constants for the list styles.
    ///   - data: The section data for populating the list.
    ///   - rowContent: A view builder that creates the view for a single row of the list.
    ///
    ///```
    ///     List(data: $sectionDataSource) { item in
    ///         Row(item)
    ///     }
    ///```
    ///
    public convenience init(_ style: UITableView.Style? = .plain,
                            data: DataSource<SectionDataList<D>>,
                            @ArgoKitListBuilder rowContent: @escaping (D) -> View){
        self.init(style: style)
        tableNode.dataSourceHelper.sectionDataSourceList = data
        tableNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}

extension List{
    
    /// The view that is displayed above the list's content.
    /// - Parameter headerContent: A view builder that creates the view for header.
    /// - Returns: Self
    @discardableResult
    public func tableHeaderView(headerContent: @escaping () -> View?) -> Self {
        guard let container = headerContent() else {
            tableNode.tableHeaderNode = nil
            return self
        }
        if let nodes = container.body.type.viewNodes(){
            for subNode in nodes {
                container.node?.addChildNode(subNode)
            }
        }
        tableNode.tableHeaderNode = container.node
        return self
    }
    
    /// The view that is displayed below the list's content.
    /// - Parameter footerContent: A view builder that creates the view for footer.
    /// - Returns: Self
    @discardableResult
    public func tableFooterView(headerContent: @escaping () -> View?) -> Self {
        guard let container = headerContent() else {
            tableNode.tableFooterNode = nil
            return self
        }
        if let nodes = container.body.type.viewNodes(){
            for subNode in nodes {
                container.node?.addChildNode(subNode)
            }
        }
        tableNode.tableFooterNode = container.node
        return self
    }
    
    /// The view that is displayed in the header of the specified section of the list.
    /// - Parameters:
    ///   - data: The data for populating the section header.
    ///   - headerContent: A view builder that creates the view for section header.
    /// - Returns: Self
    @discardableResult
    public func sectionHeader(_ data:  DataSource<DataList<D>>, @ArgoKitListBuilder headerContent: @escaping (D) -> View) -> Self{
        tableNode.sectionHeaderSourceHelper.dataSourceList = data
        tableNode.sectionHeaderSourceHelper.buildNodeFunc = { item in
            return headerContent(item)
        }
        return self
    }
    
    /// The view that is displayed in the footer of the specified section of the list.
    /// - Parameters:
    ///   - data: The data for populating the section footer.
    ///   - footerContent: A view builder that creates the view for section footer.
    /// - Returns: Self
    @discardableResult
    public func sectionFooter(_ data: DataSource<DataList<D>>, @ArgoKitListBuilder footerContent: @escaping (D) -> View) -> Self{
        tableNode.sectionFooterSourceHelper.dataSourceList = data
        tableNode.sectionFooterSourceHelper.buildNodeFunc = { item in
            return footerContent(item)
        }
        return self
    }
}


extension List{
    /// The list tuples that contain models and cells that are visible in the list.
    /// The return value of this function is an array containing tuples that contain viewmodes and cells, each representing a visible viewmode in the list.
    public func visibleModelCells() -> [(D,UITableViewCell)] {
        return self.tableNode.visibleModelCells()
    }
    
    /// The list models that are visible in the list.
    /// The return value of this function is an array containing viewmodel objects, each representing a visible viewmode in the list.
    public func visibleModels() -> [D] {
        return self.tableNode.visibleModels()
    }
    
    
    
    public func estimatedRowHeight( value: @escaping @autoclosure () ->CGFloat) -> Self{
        return self.bindCallback({ [tableNode = self.tableNode] in
            tableNode.estimatedRowHeight = value()
        }, forKey: #function)
    }
    
    public func closeAnimation( value: @escaping @autoclosure () ->Bool) -> Self{
        return self.bindCallback({ [tableNode = self.tableNode] in
            let value = value()
            tableNode.setCloseAnimation(value)
        }, forKey: #function)
    }
}
