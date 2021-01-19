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
        pNode = TableNode<D>(viewClass: UITableView.self)
        pNode?.flexGrow(1.0)
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
    public func tableHeaderView(@ArgoKitListBuilder headerContent: @escaping () -> View) -> Self {
        let container = headerContent()
        tableNode.tableHeaderNode = container.type.viewNode()
        return self
    }
    
    /// The view that is displayed below the list's content.
    /// - Parameter footerContent: A view builder that creates the view for footer.
    /// - Returns: Self
    @discardableResult
    public func tableFooterView(@ArgoKitListBuilder footerContent: @escaping () -> View) -> Self {
        let container = footerContent()
        tableNode.tableFooterNode = container.type.viewNode()
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

