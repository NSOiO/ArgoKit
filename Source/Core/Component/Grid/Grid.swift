//
//  Grid.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

/// Wrapper of UICollectionView
/// An object that manages an ordered collection of data items and presents them using customizable layouts.
///
/// Example:
///
///```
///     struct GridView: View {
///
///         @DataSource var dataSource: [Model] = [Model]()
///         @DataSource var headerDataSource: [Model] = [Model]()
///         @DataSource var footerDataSource: [Model] = [Model]()
///
///         var body: View {
///
///             Grid(data:$dataSource){ data in
///                 Item(data)
///             }
///             .sectionHeader($headerDataSource) { data in
///                 Header(data)
///             }
///             .sectionFooter($footerDataSource) { data in
///                 Footer(data)
///             }
///             .cellSelected { (data, index) in
///                 // Did Select item action
///             }
///         }
///
///         func appendData(data: Model) {
///             models.append(data)
///             $dataSource.apply()
///         }
///     }
///```
///
public class Grid<D>: ScrollView {
    
    var gridNode: GridNode<D>?
    
    override func createNode() {
        gridNode = GridNode(viewClass: ArgoKitGridView.self)
        pNode = gridNode
        self.height(.auto)
        pNode?.flexGrow(1.0)
    }
    
    required init() {
        super.init()
    }
    
    /// Initializer
    /// - Parameters:
    ///   - waterfall: Whether the grid syle is waterfall.
    ///   - content: The content of the grid.
    ///
    ///```
    ///     Grid {
    ///         Item1()
    ///         Item2()
    ///         Item3()
    ///     }
    ///```
    ///
    public convenience init(waterfall: Bool = false, @ArgoKitListBuilder content: @escaping () -> View) where D : ArgoKitNode {
        self.init()
        gridNode?.waterfall(waterfall)
        let container = content()
        if let nodes = container.type.viewNodes() {
            gridNode?.dataSourceHelper.nodeSourceList?.append(contentsOf: [nodes])
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - waterfall: Whether the grid syle is waterfall.
    ///   - data: The data for populating the grid.
    ///   - itemContent: A view builder that creates the view for a single item of the grid.
    ///
    ///```
    ///     Grid(data: $dataSource) { item in
    ///         Item(item)
    ///     }
    ///```
    ///
    public convenience init(waterfall: Bool =  false,
                            data: DataSource<DataList<D>>,
                            @ArgoKitListBuilder itemContent: @escaping (D) -> View){
        self.init()
        gridNode?.waterfall(waterfall)
        gridNode?.dataSourceHelper.dataSourceList = data
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            return itemContent(item)
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - waterfall: Whether the grid syle is waterfall.
    ///   - data: The section data for populating the grid.
    ///   - itemContent: A view builder that creates the view for a single item of the grid.
    ///
    ///```
    ///     Grid(data: $sectionDataSource) { item in
    ///         Item(item)
    ///     }
    ///```
    ///
    public convenience init(waterfall:Bool = false,
                            data: DataSource<SectionDataList<D>>,
                            @ArgoKitListBuilder itemContent: @escaping (D) -> View){
        self.init()
        gridNode?.waterfall(waterfall)
        gridNode?.dataSourceHelper.sectionDataSourceList = data
        gridNode?.dataSourceHelper.buildNodeFunc = { item in
            return itemContent(item)
        }
    }
}

extension Grid {
    
    /// The view that is displayed in the header of the specified section of the grid.
    /// - Parameter headerContent: A view builder that creates the view for section header.
    /// - Returns: Self
    @discardableResult
    public func sectionHeader(@ArgoKitListBuilder headerContent: @escaping () -> View) -> Self {
        let container = headerContent()
        if let nodes = container.type.viewNodes() {
            gridNode?.sectionHeaderSourceHelper.nodeSourceList?.append(contentsOf:[nodes])
        }
        return self
    }
    
    /// The view that is displayed in the header of the specified section of the grid.
    /// - Parameters:
    ///   - data: The data for populating the section header.
    ///   - headerContent: A view builder that creates the view for section header.
    /// - Returns: Self
    @discardableResult
    public func sectionHeader(data:DataSource<DataList<D>>, @ArgoKitListBuilder headerContent: @escaping (D) -> View) -> Self{
        gridNode?.sectionHeaderSourceHelper.dataSourceList = data
        gridNode?.sectionHeaderSourceHelper.buildNodeFunc = { item in
            return headerContent(item)
        }
        return self
    }
    
    /// The view that is displayed in the footer of the specified section of the grid.
    /// - Parameter footerContent: A view builder that creates the view for section footer.
    /// - Returns: Self
    @discardableResult
    public func sectionFooter(@ArgoKitListBuilder footerContent: @escaping () -> View) -> Self {
        let container = footerContent()
        if let nodes = container.type.viewNodes() {
            gridNode?.sectionFooterSourceHelper.nodeSourceList?.append(contentsOf:[nodes])
        }
        return self
    }
    
    /// The view that is displayed in the footer of the specified section of the grid.
    /// - Parameters:
    ///   - data: The data for populating the section footer.
    ///   - footerContent: A view builder that creates the view for section footer.
    /// - Returns: Self
    @discardableResult
    public func sectionFooter(data:DataSource<DataList<D>>, @ArgoKitListBuilder footerContent: @escaping (D) -> View) -> Self{
        gridNode?.sectionFooterSourceHelper.dataSourceList = data
        gridNode?.sectionFooterSourceHelper.buildNodeFunc = { item in
            return footerContent(item)
        }
        return self
    }
}

extension Grid{
    /// The grid tuples that contain models and cells that are visible in the grid.
    /// The return value of this function is an array containing tuples that contain viewmodes and cells, each representing a visible viewmode in the grid.
    public func visibleModelCells() -> [(D,UICollectionViewCell)] {
        return self.gridNode?.visibleModelCells() ?? []
    }
    /// The grid models that are visible in the grid.
    /// The return value of this function is an array containing viewmodel objects, each representing a visible viewmode in the grid.
    public func visibleModels() -> [D] {
        return self.gridNode?.visibleModels() ?? []
    }
}
