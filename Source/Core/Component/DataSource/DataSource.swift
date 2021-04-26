//
//  DataBind.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/23.
//

import Foundation

enum DataSourceType {
    case none
    case body
    case header
    case footer
}
public typealias SectionDataList<T> = [[T]]
public typealias DataList<T> = [T]

/// Wrapper datasource of List or Grid
/// dataSource = [Element] or dataSource = [[Element]]
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
@propertyWrapper
public class DataSource<Value>  {
    weak var _rootNode : DataSourceReloadNode?
    var dataSource: Value
    var type: DataSourceType = .none
    
    public var reloadAction:((UITableView.RowAnimation)->Void)?
    
    public init<D>(_ value: Value) where Value == DataList<D>{
        self.dataSource = value
    }
    public init<D>(_ value: Value) where Value == SectionDataList<D>{
        self.dataSource = value
    }
    
    public init<D>(wrappedValue value: Value) where Value == DataList<D>{
        self.dataSource = value
    }
    
    public init<D>(wrappedValue value: Value) where Value == SectionDataList<D>{
        self.dataSource = value
    }
    
    public var projectedValue: DataSource<Value> {
        return self
    }

    public var wrappedValue: Value  {
        get {
            return dataSource
        }
//        set {
//            #if DEBUG
//                fatalError("Please prefix an instance of a DataSource with $")
//            #endif
//        }
    }
}


extension DataSource{
//    public func getDataSource<D>()->SectionDataList<D> where Value == SectionDataList<D>{
//        return dataSource
//    }
//
//    public func getDataSource<D>()->DataList<D> where Value == DataList<D>{
//        return dataSource
//    }
    
    /// call this method  after the data has been manipulated
    /// And calling of method must be on the main thread
    public func getDataSource<D>()->DataList<D> where Value == DataList<D>{
        return dataSource
    }
    
    
    /// apply the changes of data source on the List, use the specified animation.
    /// - Parameter animation: The type of animation to use when the List changes.
    public func apply(with animation: UITableView.RowAnimation = UITableView.RowAnimation(rawValue: -1) ?? .none){
        if let action = reloadAction,animation.rawValue != -1{
            action(animation)
        }else{
            if let node = self._rootNode {
                node.reloadData()
            }
        }
        reloadAction = nil
    }
    

    
    private func reloadData(){
        reloadAction = {[weak self] animation in
            if let node = self?._rootNode {
                node.reloadData()
            }
        }
    }
    
    private func insertRows(at indexPaths: [IndexPath]) {
        if let _ = reloadAction {
            self.reloadData()
        }else{
            reloadAction = {[weak self,indexPaths] animation in
                if let node = self?._rootNode {
                    node.insertRows(at: indexPaths, with: animation)
                }
            }
        }
    }
    
    private func deleteRows(at indexPaths: [IndexPath]) {
        if let _ = reloadAction {
            self.reloadData()
        }else{
            reloadAction = {[weak self,indexPaths] animation in
                if let node = self?._rootNode {
                    node.deleteRows(at: indexPaths, with: animation)
                }
            }
        }
    }
    
    private func reloadRows(at indexPaths: [IndexPath]) {
        if let _ = reloadAction {
            self.reloadData()
        }else{
            reloadAction = {[weak self,indexPaths] animation in
                if let node = self?._rootNode {
                    node.reloadRows(at: indexPaths, with: animation)
                }
            }
        }
    }
    
    private func deleteSections(at sections: IndexSet) {
        if let _ = reloadAction {
            self.reloadData()
        }else{
            reloadAction = {[weak self,sections] animation in
                if let node = self?._rootNode {
                    node.deleteSections(sections, with: animation)
                }
            }
        }
    }
    
    private func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath){
        if let _ = reloadAction {
            self.reloadData()
        }else{
            reloadAction = {[weak self,indexPath,newIndexPath] animation in
                if let node = self?._rootNode {
                    node.moveRow(at: indexPath, to: newIndexPath)
                }
            }
        }
    }
}

// MARK: === data Preparsed ===
extension DataSource{
    /// prepare a viewnode from a  element.
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [Int]()
    ///     $dataSource.prepareNode(from:data)
    ///```
    /// - Parameter element: The element to prepare a view node.
    /// - Returns: Self
    @discardableResult
    public func prepareNode<Element>(from element:Element) -> Self{
        if let node = self._rootNode, !(Thread.isMainThread){
            node.createNodeFromData(element,helper: self)
        }
        return self
    }
    
    /// prepare a viewnode from a  elements.
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [Int]()
    ///     $dataSource.prepareNode(from:data)
    ///```
    /// - Parameter elements: The elements to prepare view nodes.
    /// - Returns: Self
    @discardableResult
    public func prepareNode<Element>(from elements:DataList<Element>) -> Self{
        if Thread.isMainThread{
            return self
        }
        
        for data in elements{
            if let node = self._rootNode {
                node.createNodeFromData(data,helper: self)
            }
        }
        return self
    }
}
// MARK: === data appended ===
extension DataSource{

    /// Adds a new element at the end of the dataSource.
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [Int]()
    ///     $dataSource.append(1)
    ///     $dataSource.append(2)
    ///     $dataSource.append(3)
    ///     print(dataSource)
    ///     // Prints "[1, 2, 3]"
    ///```
    /// - Parameter newElement: The element to append to the dataSource.
    /// - Returns: Self
    @discardableResult
    public func append<Element>(_ newElement:Element) -> Self
    where Value == DataList<Element>{
        dataSource.append(newElement)
        return self
    }
    
    /// Adds a new element at the end of the dataSource.
    /// dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int][ = [[Int]]()
    ///     var numbers1 = [1, 2, 3]
    ///     var numbers2 = [4, 5, 6]
    ///     var numbers3 = [7, 8, 9]
    ///     $dataSource.append(numbers1)
    ///     $dataSource.append(numbers2)
    ///     print("numbers1:\(dataSource[0])")
    ///     print("numbers2:\(dataSource[1])")
    ///     // Prints "numbers1:[1, 2, 3]"
    ///     // Prints "numbers1:[4, 5, 6]"
    ///```
    /// - Parameter newElement: The element to append to the dataSource.
    /// - Returns: Self
    @discardableResult
    public func append<Element>(_ newElement:DataList<Element>) -> Self
    where Value == SectionDataList<Element>{
        dataSource.append(newElement)
        return self
    }
    
    /// Adds a new element at the end of the specified section of the dataSource
    /// dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1, 2, 3],[4, 5, 6],[7, 8, 9]]
    ///     var numbers = 10
    ///     $dataSource.append(numbers,section:1)
    ///     print("numbers1:\(dataSource)")
    ///     // Prints "[[1, 2, 3],[4, 5, 6, 10],[7, 8, 9]]"
    ///```
    /// - Parameter newElement: The element to append to the dataSource.
    /// - Parameter section: The specified section of the dataSource
    /// - Returns: Self
    @discardableResult
    public func append<Element>(_ newElement:Element,section:Int) -> Self
    where Value == SectionDataList<Element>{
        if section > dataSource.count - 1 ||
            section < 0{
            return self
        }
        dataSource[section].append(newElement)
        return self
    }
    
    /// Adds the elements of a [Element] to the end of the specified section of the dataSource.
    /// dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int][ = [[1, 2, 3],[4, 5, 6],[7, 8, 9]]
    ///     var numbers = [10, 20, 30]
    ///     $dataSource.append(numbers,section:1)
    ///     print("numbers1:\(dataSource)")
    ///     // Prints "[[1, 2, 3],[4, 5, 6,10, 20, 30],[7, 8, 9]]"
    ///```
    /// - Parameter newElements: The element to append to the dataSource.
    /// - Parameter section: The specified section of the dataSource
    /// - Returns: Self
    @discardableResult
    public func append<Element>(contentsOf newElements:DataList<Element>,section:Int) -> Self
    where Value == SectionDataList<Element>{
        if section > dataSource.count - 1 ||
            section < 0{
            return self
        }
        dataSource[section].append(contentsOf: newElements)
        return self
    }
    
    
    /// Adds the elements of a [Element] to the end of the dataSource
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[Int[ = [Int]()
    ///     var numbers = [1, 2, 3, 4, 5]
    ///     $dataSource.append(contentsOf: numbers)
    ///     print(numbers)
    ///     // Prints "[1, 2, 3, 4, 5]"
    ///```
    /// - Parameter newElements: The elements to append to the dataSource.
    /// - Returns: Self
    @discardableResult
    public func append<Element>(contentsOf newElements:DataList<Element>) -> Self
    where Value == DataList<Element>{
        dataSource.append(contentsOf: newElements)
        return self
    }
    
    /// Adds the elements of a [[Element]] to the end of the dataSource.
    /// dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[Int]]]()
    ///     var numbers = [[1, 2, 3, 4, 5],[6,7,8]]
    ///     $dataSource.append(contentsOf: numbers)
    ///     print(numbers)
    ///     // Prints "[[1, 2, 3, 4, 5],[6,7,8]]"
    ///```
    /// - Parameter newElements: The elements to append to the dataSource.
    /// - Returns: Self
    @discardableResult
    public func append<Element>(contentsOf newElements:SectionDataList<Element>) -> Self
    where Value == SectionDataList<Element>{
        dataSource.append(contentsOf: newElements)
        return self
    }
}
// MARK: === data inserted ===
extension DataSource{
    /// Inserts the elements of a [Element] to the end of the dataSource.
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [1, 2, 3, 4, 5]
    ///     var numbers = [10, 20, 30]
    ///     var indexPaths = [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0)]
    ///     $dataSource.insert(datas: numbers, at: indexPaths)
    ///
    ///     print(dataSource)
    ///     // Prints "[10,20,30,1, 2, 3, 4, 5]"
    ///```
    /// - Parameter datas: The new elements to insert into the dataSource.
    /// - Parameter indexPaths: The positions at which to insert the new element.
    ///
    /// - Returns: Self`.
    @discardableResult
    public func insert<Element>(datas:[Element],at indexPaths: [IndexPath]) -> Self
    where Value == DataList<Element>{
        if datas.count <= 0 {
            return self
        }
        if datas.count !=  indexPaths.count{
            return self
        }
        for index in 0 ..< datas.count{
            let data = datas[index]
            let indexPath = indexPaths[index]
            if dataSource.count <  indexPath.row{
                continue
            }
            dataSource.insert(data, at: indexPath.row)
        }
        self.insertRows(at: indexPaths)
        return self
    }
    
    /// Inserts the elements of a sequence into the dataSource at the specified position.
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [1, 2, 3, 4, 5]
    ///     $dataSource.insert(contentsOf: 100...103, at: 3)
    ///     print(numbers)
    ///     // Prints "[1, 2, 3, 100, 101, 102, 103, 4, 5]"
    ///```
    /// Calling this method may invalidate any existing indices for use with this dataSource.
    ///
    /// - Parameter newElements: The new elements to insert into the dataSource.
    /// - Parameter position: The position at which to insert the new elements. `index`
    ///   must be a valid index of the collection.
    @discardableResult
    public func insert<Element>(contentsOf datas:[Element],at position:Int) -> Self
    where Value == DataList<Element>{
        if datas.count <= 0 {
            return self
        }
        if position > dataSource.count{
            return self
        }
        dataSource.insert(contentsOf:datas, at: position)
        self.reloadData()
        return self
    }
    
    
    /// Inserts the elements of a [Element] to the end of the dataSource
    ///  dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1,2],[3,4],[5,6]]
    ///     var numbers = [10, 20, 30]
    ///     var indexPaths = [IndexPath(row: 1, section: 0),IndexPath(row: 1, section: 1),IndexPath(row: 0, section: 2)]
    ///     $dataSource.insert(datas: numbers, at: indexPaths)
    ///
    ///     print(dataSource)
    ///     // Prints "[[1,10,2],[3,20,4],[30,5,6]]"
    ///```
    /// - Parameter datas: The new elements to insert into the dataSource.
    /// - Parameter indexPaths: The positions at which to insert the new element.
    /// - Returns: Self`.
    @discardableResult
    public func insert<Element>(datas:[Element],at indexPaths: [IndexPath]) -> Self
    where Value == SectionDataList<Element>{
        if datas.count <= 0 {
            return self
        }
        if datas.count !=  indexPaths.count{
            return self;
        }
        for index in 0 ..< datas.count{
            let data = datas[index]
            let indexPath = indexPaths[index]
            if dataSource.count <= indexPath.section {
                continue
            }
            if dataSource[indexPath.section].count < indexPath.row {
                continue
            }
            dataSource[indexPath.section].insert(data, at: indexPath.row)
        }
        self.insertRows(at: indexPaths)
        return self
    }
    
    /// Inserts the elements of a [Element] to the end of the specified section of the dataSource.
    ///  dataSource = [[Element]]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1,2],[3,4],[5,6]]
    ///     var numbers = [10, 20, 30]
    ///     var indexPaths = [IndexPath(row: 1, section: 0),IndexPath(row: 1, section: 1),IndexPath(row: 0, section: 2)]
    ///     $dataSource.insert(datas: numbers, at: indexPaths)
    ///
    ///     print(dataSource)
    ///     // Prints "[[1,10,2],[3,20,4],[30,5,6]]"
    ///```
    /// - Parameter datas: The new elements to insert into the dataSource.
    /// - Parameter indexPaths: The positions at which to insert the new element.
    /// - Parameter section: The specified section of the dataSource.
    /// - Returns: Self`.
    @discardableResult
    public func insert<Element>(contentsOf datas:[Element],at position: Int, section:Int) -> Self
    where Value == SectionDataList<Element>{
        if datas.count <= 0 {
            return self
        }
        if section > dataSource.count - 1 ||
            section < 0{
            return self
        }
        if position > dataSource[section].count{
            return self
        }
        
        dataSource[section].insert(contentsOf:datas, at: position)
        self.reloadData()
        return self
    }
    
    /// Inserts a new element at the specified position.
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [1, 2, 3, 4, 5]
    ///     $dataSource.insert(data:10, at: IndexPath(row: 1, section: 0))
    ///
    ///     print(dataSource)
    ///     // Prints "[1,10, 2, 3, 4, 5]"
    ///```
    /// - Parameter datas: The new element to insert into the dataSource.
    /// - Parameter indexPath: The position at which to insert the new element.
    ///
    /// - Returns: Self`.
    @discardableResult
    public func insert<Element>(data:Element,at indexPath: IndexPath) -> Self
    where Value == DataList<Element>{
        return insert(datas: [data], at: [indexPath])
    }
    
    /// Inserts a new element at the specified position.
    /// dataSource = [Element]
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1,2],[3,4],[5,6]]
    ///     $dataSource.insert(data:10, at: IndexPath(row: 1, section: 1))
    ///     print(dataSource)
    ///     // Prints "[[1,2],[3,10,4],[5,6]]"
    ///```
    /// - Parameter datas: The new element to insert into the dataSource.
    /// - Parameter indexPath: The position at which to insert the new element.
    ///
    /// - Returns: Self`.
    @discardableResult
    public func insert<Element>(data:Element,at indexPath: IndexPath)
    -> Self
    where Value == SectionDataList<Element>{
        return insert(datas: [data], at: [indexPath])
    }
}

// MARK: === data deleted ===
extension DataSource{
    /// Removes all elements from the dataSource.
    @discardableResult
    public func clear<Element>() -> Self where Value == DataList<Element>{
        dataSource.removeAll()
        if let node = self._rootNode {
            node.removeAll()
        }
        return self
    }
    
    /// Removes all elements from the dataSource.
    @discardableResult
    public func clear<Element>() -> Self where Value == SectionDataList<Element>{
        dataSource.removeAll()
        if let node = self._rootNode {
            node.removeAll()
        }
        return self
    }
    
    /// delete the element at the specified position from dataSource.
    /// dataSource = [Element]
    /// ```
    ///     @DataSource var dataSource:[Int] = [1, 5, 9, 12, 15, 13, 12]
    ///     $dataSource.delete(IndexPath(row: 1, section: 0))
    ///     print(dataSource)
    ///     // Prints "[1, 9, 12, 15, 13, 12]"
    ///```
    ///
    /// - Parameter indexPath: The position of the element to remove.
    /// - Returns: Self.
    ///
    @discardableResult
    public func delete<Element>(at indexPath: IndexPath)
    -> Self
    where Value == DataList<Element>{
        return self.delete(at: [indexPath])
    }
    
    /// delete the element at the specified position from dataSource.
    ///  dataSource = [[Element]]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int] = [[1, 5], [9, 12], [15, 13, 12]]
    ///     $dataSource.delete(IndexPath(row: 1, section: 1))
    ///     print(dataSource)
    ///     // Prints "[[1, 5], [9], [15, 13, 12]]"
    ///```
    ///
    /// - Parameter indexPath: The position of the element to delete.
    /// - Returns: Self.
    ///
    @discardableResult
    public func delete<Element>(at indexPath: IndexPath)
    -> Self
    where Value == SectionDataList<Element>{
       
        return self.delete(at: [indexPath])
    }
    
    /// delete the element at the specified positions from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int] = [1, 5, 9, 12, 15, 13, 12]
    ///     $dataSource.delete(at:[IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0),IndexPath(row: 1, section: 0)])
    ///     print(dataSource)
    ///     // Prints "[1, 15, 13, 12]"
    ///```
    ///
    /// - Parameter indexPaths: The positions of the element to delete.
    /// - Returns: Self.
    ///
    @discardableResult
    public func delete<Element>(at indexPaths: [IndexPath])
    -> Self
    where Value == DataList<Element>{
        var indices:[Int] = []
        var _indexPaths:[IndexPath] = [];
        for indexPath in indexPaths {
            if dataSource.count <= indexPath.row {
                continue
            }
            _indexPaths.append(indexPath)
            indices.append(indexPath.row)
        }
        let reversedndices = indices.sorted().reversed()
        for i in reversedndices {
            guard i < dataSource.count else { return self}
    
            if let node = self._rootNode {
                if let cellNode = dataSource[i] as? ArgoKitIdentifiable{
                    node.removeNode(cellNode.argokit_linkNode)
                }
            }
            dataSource.remove(at: i)
        }
        self.deleteRows(at: _indexPaths)
        return self
    }
    
    /// delete the element at the specified position from dataSource.
    /// dataSource = [[Element]]
    ///
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5], [9, 12], [15, 13, 12,24,1]]
    ///      $dataSource.delete(at:[IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0),IndexPath(row: 3, section: 0),IndexPath(row: 1, section: 3),IndexPath(row: 1, section: 3)])
    ///     print(dataSource)
    ///     // Prints "[[1, 15, 13, 12], [1, 5], [9, 12], [15, 24, 1]]"
    ///```
    ///
    /// - Parameter indexPaths: The positions of the element to delete.
    /// - Returns: Self.
    ///
    @discardableResult
    public func delete<Element>(at indexPaths: [IndexPath])
    -> Self
    where Value == SectionDataList<Element>{
        var section:[Int:[Int]] = [:]
        var _indexPaths:[IndexPath] = [];
        for indexPath in indexPaths {
            if indexPath.count != 2 {
                continue
            }
            if dataSource.count <= indexPath.section {
                continue
            }
            if dataSource[indexPath.section].count <= indexPath.row {
                continue
            }
            _indexPaths.append(indexPath)
            if let _ = section[indexPath.section]{
                section[indexPath.section]?.append(indexPath.row)
            }else{
                let value = [indexPath.row]
                section[indexPath.section] = value
            }
        }
        for (key,value) in section{
            let reversedIndices = value.sorted().reversed()
            for i in reversedIndices {
                guard i < dataSource[key].count else { return self}
                if let node = self._rootNode {
                    if let cellNode = dataSource[key][i] as? ArgoKitIdentifiable{
                        node.removeNode(cellNode.argokit_linkNode)
                    }
                }
                dataSource[key].remove(at: i)
            }
        }
        self.deleteRows(at: _indexPaths)
        return self
    }
    
    /// delete the section at the specified position from dataSource.
    /// dataSource = [[Element]]
    ///
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5], [9, 12], [15, 13, 12,24,1]]
    ///     $dataSource.deleteSection(at:[1,2])
    ///     print(dataSource)
    ///     // Prints "[[1, 5, 9, 12, 15, 13, 12],[15, 13, 12,24,1]]"
    ///```
    ///
    /// - Parameter sections: The positions of the section to delete.
    /// - Returns: Self.
    ///
    @discardableResult
    public func delete<Element>(sections: IndexSet)
    -> Self
    where Value == SectionDataList<Element>{
        var sections_ = IndexSet()
        for section in sections {
            if section > dataSource.count - 1 {
                return self
            }
            sections_.insert(section)
            if let node = self._rootNode {
                let cellNodes:[Any] = dataSource[section]
                for cellNode in cellNodes {
                    if let cellNode = cellNode as? ArgoKitIdentifiable{
                        node.removeNode(cellNode.argokit_linkNode)
                    }
                   
                }
            }
            dataSource.remove(at: section)
        }
        deleteSections(at: sections_)
        return self
    }
}

// MARK: === data replaced === Data Replace
extension DataSource{
    /// replace the element of [Element] at the specified positions from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int] = [1, 5, 9, 12, 15, 13, 12]
    ///     $dataSource.replace(datas:[10,20], at:[IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0))
    ///     print(dataSource)
    ///     // Prints "[1, 10, 20, 12, 15, 13, 12]"
    ///```
    ///
    /// - Parameter datas: The new elements to replace into the dataSource.
    /// - Parameter indexPaths: The positions of the element to replace.
    /// - Returns: Self.
    ///
    @discardableResult
    public func replace<Element>(datas:[Element],at replaceIndexPaths: [IndexPath]) -> Self
    where Value == DataList<Element>{
        if datas.count !=  replaceIndexPaths.count{
            return self
        }
        for index in 0 ..< datas.count{
            let data = datas[index]
            let indexPath = replaceIndexPaths[index]
            if dataSource.count <= indexPath.row {
              continue
            }
            dataSource.remove(at: indexPath.row)
            dataSource.insert(data, at: indexPath.row)
        }
        self.reloadRows(at: replaceIndexPaths)
        return self
    }
    
    /// replace the element of [Element] at the specified positions from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5], [15, 13, 12,24,1]]
    ///     $dataSource.replace(datas:[10,20,30], at:[IndexPath(row: 1, section: 0),IndexPath(row: 1, section: 1),IndexPath(row: 2, section: 2)])
    ///     print(dataSource)
    ///     // Prints "[[1, 10, 9, 12, 15, 13, 12],[1, 20], [15, 13, 30,24,1]]"
    ///```
    ///
    /// - Parameter datas: The new elements to replace into the dataSource.
    /// - Parameter indexPaths: The positions of the element to replace.
    /// - Returns: Self.
    ///
    @discardableResult
    public func replace<Element>(datas:[Element],at replaceIndexPaths: [IndexPath]) -> Self
    where Value == SectionDataList<Element>{
        if datas.count !=  replaceIndexPaths.count{
            return self
        }
        for index in 0 ..< datas.count{
            let data = datas[index]
            let indexPath = replaceIndexPaths[index]
            if dataSource.count <= indexPath.section {
                continue
            }
            if dataSource[indexPath.section].count <= indexPath.row {
                continue
            }
            dataSource[indexPath.section].remove(at: indexPath.row)
            dataSource[indexPath.section].insert(data, at: indexPath.row)
        }
        self.reloadRows(at: replaceIndexPaths)
        return self
    }
    
    /// replace the element  at the specified positions from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int] = [1, 5, 9, 12, 15, 13, 12]
    ///     $dataSource.replace(data:10, at:IndexPath(row: 3, section: 0))
    ///     print(dataSource)
    ///     // Prints "[1, 5, 9, 10, 15, 13, 12]"
    ///```
    ///
    /// - Parameter data: The new element to replace into the dataSource.
    /// - Parameter indexPath: The position of the element to replace.
    /// - Returns: Self.
    ///
    @discardableResult
    public func replace<D>(data:D,at indexPath: IndexPath)
    -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        return replace(datas: [data], at: [indexPath])
    }
    
    /// replace the element  at the specified position from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5, 7], [15, 13, 12,24,1]]
    ///     $dataSource.replace(datas:30, at:IndexPath(row: 1, section: 1))
    ///     print(dataSource)
    ///     // Prints "[[1, 5, 9, 12, 15, 13, 12],[1, 30, 7], [15, 13, 12,24,1]]"
    ///```
    ///
    /// - Parameter data: The new elements to replace into the dataSource.
    /// - Parameter indexPath: The position of the element to replace.
    /// - Returns: Self.
    ///
    @discardableResult
    public func replace<Element>(data:Element,at indexPath: IndexPath)
    -> Self
    where Value == SectionDataList<Element>{
        return replace(datas: [data], at: [indexPath])
    }
}

// MARK:=== data moved ===
extension DataSource{
    /// move the element  at the specified position to new position for dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int]] = [1, 5, 9, 12, 15, 13, 12]
    ///     $dataSource.move(at:IndexPath(row: 1, section: 0), at:IndexPath(row: 2, section: 0))
    ///     print(dataSource)
    ///     // Prints "[1, 9, 5, 12, 15, 13, 12]"
    ///```
    ///
    /// - Parameter indexPath: The  position that element will move from.
    /// - Parameter newIndexPath: The new position that element will move to.
    /// - Returns: Self.
    ///
    
    @discardableResult
    public func move<Element>(at indexPath: IndexPath, to newIndexPath: IndexPath) ->Self
    where Value == DataList<Element>{
        if indexPath.section < 0 ||  newIndexPath.section < 0 {
            return self
        }
        if indexPath.row == newIndexPath.row {
            return self
        }
        if move(&dataSource, indexPath, newIndexPath) == true {
            self.moveRow(at: indexPath, to: newIndexPath)
        }
        return self
    }
    

    /// move the element  at the specified position to new position for dataSource.
    /// dataSource = [[Element]]
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5, 7], [15, 13, 12,24,1]]
    ///     $dataSource.move(at:IndexPath(row: 1, section: 0), at:IndexPath(row: 2, section: 1))
    ///     print(dataSource)
    ///     // Prints "[[1, 9, 12, 15, 13, 12],[1, 5,5, 7], [15, 13, 12,24,1]]"
    ///```
    ///
    /// - Parameter indexPath: The  position that element will move from.
    /// - Parameter newIndexPath: The new position that element will move to.
    /// - Returns: Self.
    ///
    @discardableResult
    public func move<Element>(at indexPath: IndexPath, to newIndexPath: IndexPath)
    ->Self
    where Value == SectionDataList<Element>{
        let section = dataSource.count
        if newIndexPath.section < 0
            || newIndexPath.row < 0
            || indexPath.section < 0
            || indexPath.row < 0{
            return self
        }
        if indexPath.section ==  newIndexPath.section
            && indexPath.row == newIndexPath.row{
            return self
        }
        if indexPath.section > section - 1 ||
            newIndexPath.section > section - 1{
            return self
        }
        var ret = false
        if indexPath.section ==  newIndexPath.section
            && indexPath.row != newIndexPath.row{
            ret = move(&dataSource[indexPath.section], indexPath, newIndexPath)
        }else if(indexPath.section !=  newIndexPath.section){
            let count = dataSource[indexPath.section].count
            if indexPath.row > count - 1 {
                return self
            }
            let newCount = dataSource[newIndexPath.section].count
            if newIndexPath.row > newCount {
                return self
            }
            let data = dataSource[indexPath.section][indexPath.row]
            dataSource[newIndexPath.section].insert(data, at: newIndexPath.row)
            dataSource[indexPath.section].remove(at: indexPath.row)
            ret = true
        }
        if ret {
            self.moveRow(at: indexPath, to: newIndexPath)
        }
        return self
    }
    
    private func move<T>(_ datas:inout[T],_ indexPath:IndexPath,_ newIndexPath:IndexPath) -> Bool{
        if newIndexPath.section < 0
            || newIndexPath.row < 0
            || indexPath.section < 0
            || indexPath.row < 0{
            return false
        }
        let count = datas.count
        if indexPath.row > count - 1 {
            return false
        }
        if newIndexPath.row >= count {
            return false
        }
        let data = datas[indexPath.row]
        datas.remove(at: indexPath.row)
        datas.insert(data, at: newIndexPath.row)
        return true
    }
}

// MARK: Get value
extension DataSource{
    /// The number of elements in the dataSource.
    /// dataSource = [Element]
    public func count<Element>()->Int where Value == DataList<Element>{
        dataSource.count
    }
    
    /// The number of elements in the dataSource.
    /// dataSource = [[Element]]
    public func count<Element>()->Int where Value == SectionDataList<Element>{
        dataSource.count
    }
    
    /// The number of elements  at the specified section from dataSource.
    /// dataSource = [[Element]]
    /// - Parameter section: The  specified section
    public func count<Element>(section:Int)->Int where Value == SectionDataList<Element>{
        if section > dataSource.count - 1{
            return 0
        }
        return dataSource[section].count
    }
    
    /// Accesses the element at the specified position from dataSource.
    /// dataSource = [Element]
    /// The following example uses indexed subscripting to update an array's
    /// second element. After assigning the new value (`15`) at a specific
    /// position, that value is immediately available at that same position.
    ///
    ///```
    ///     @DataSource var dataSource:[Int] = [1, 2, 3, 4, 5]
    ///     streets[1] = 15
    ///     print(streets[1])
    ///     // Prints "15"
    ///```
    /// - Parameter index: The position of the element to access.
    public subscript<Element>(row:Int)->Element where Value == DataList<Element>{
        set {
            if row <= dataSource.count{
                dataSource[row] = newValue
            }
        }
        get {
            return dataSource[row]
        }
    }
    
    /// Accesses the element at the specified position from dataSource.
    /// dataSource = [[Element]]
    /// The following example uses indexed subscripting to update an array's
    /// second element. After assigning the new value (`[10,11,12]`) at a specific
    /// position, that value is immediately available at that same position.
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1, 2, 3],[4, 5, 6],[7, 8, 9]]
    ///     $dataSource[1] = [10,11,12]
    ///     print($dataSource[1])
    ///     // Prints "[10,11,12]"
    ///```
    /// - Parameter index: The position of the element to access.
    public subscript<Element>(row:Int)->[Element] where Value == SectionDataList<Element>{
        set {
            if row <= dataSource.count{
                dataSource[row] = newValue
            }
        }
        get {
            return dataSource[row]
        }
    }
    
    /// Accesses the element at the specified position of specified section from dataSource.
    /// dataSource = [[Element]]
    /// The following example uses indexed subscripting to update an array's
    /// second element of first section. After assigning the new value (`15`) at a specific
    /// position, that value is immediately available at that same position.
    ///
    ///```
    ///     @DataSource var dataSource:[[Int]] = [[1, 2, 3],[4, 5, 6],[7, 8, 9]]
    ///     $dataSource[1,0] = 15
    ///     print($dataSource[1])
    ///     // Prints "15"
    ///```
    /// - Parameter index: The position of the element to access.
    public subscript<Element>(row:Int,section:Int)->Element where Value == SectionDataList<Element>{
        set {
            if section > dataSource.count - 1 {
                return
            }
            if row <= dataSource[section].count{
                dataSource[section][row] = newValue
            }
        }
        get {
            return dataSource[section][row]
        }
    }

    
    /// get the element  at the specified indexPath from dataSource.
    /// dataSource = [Element]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int] = [1, 5, 9, 12, 15, 13, 12]
    ///     let value:Int = $dataSource.value(indexPath:IndexPath(row: 1, section: 0))
    ///     print(value)
    ///     // Prints "5"
    ///```
    ///
    /// - Parameter indexPath: The  specified position
    /// - Returns: element for position.
    ///
    public func value<Element>(at indexPath:IndexPath) -> Element? where Value == DataList<Element>{
        if indexPath.row > dataSource.count - 1{
            return nil
        }
        return dataSource[indexPath.row]
    }
    
    /// get the element  at the specified indexPath from dataSource.
    /// dataSource = [[Element]]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5, 7], [15, 13, 12,24,1]]
    ///     let value:Int = $dataSource.value(at:IndexPath(row: 2, section: 1))
    ///     print(value)
    ///     // Prints "7"
    ///```
    ///
    /// - Parameter indexPath: The  specified position
    /// - Returns: element for position.
    ///
    public func value<Element>(at indexPath:IndexPath) -> Element? where Value == SectionDataList<Element>{
        if indexPath.section > dataSource.count - 1{
            return nil
        }
        if indexPath.row > dataSource[indexPath.section].count - 1{
            return nil
        }
        return dataSource[indexPath.section][indexPath.row]
    }
    
    /// get the element  at the specified section from dataSource.
    /// dataSource = [[Element]]
    ///
    /// ```
    ///     @DataSource var dataSource:[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5, 7], [15, 13, 12,24,1]]
    ///     let value:Int = $dataSource.value(at:IndexPath(row: 2, section: 1))
    ///     print(value)
    ///     // Prints "7"
    ///```
    ///
    /// - Parameter section: The  specified section
    /// - Returns: elements for position.
    ///
    public func value<Element>(at section:Int) -> [Element]? where Value == SectionDataList<Element>{
        if section > dataSource.count - 1{
            return nil
        }
        return dataSource[section]
    }
    
    /// The first element of the dataSource.
    /// dataSource = [Element]
    ///
    /// If the dataSource is empty, the value of this property is `nil`.
    ///
    ///     @DataSource var dataSource:[Int]] = [10, 20, 30, 40, 50]
    ///     if let firstNumber:Int = $dataSource.first {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "10"
    /// - Returns: the first element.
    public func first<Element>() -> Element? where Value == DataList<Element>{
        if dataSource.count <= 0 {
            return nil
        }
        return dataSource.first
    }
    
    /// The last element of the dataSource.
    /// dataSource = [Element]
    ///
    /// If the dataSource is empty, the value of this property is `nil`.
    ///
    ///     @DataSource var dataSource:[Int]] = [10, 20, 30, 40, 50]
    ///     if let firstNumber:Int = $dataSource.first() {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "50"
    /// - Returns: the last element.
    public func last<Element>() -> Element? where Value == DataList<Element>{
        if dataSource.count <= 0 {
            return nil
        }
        return dataSource.last
    }
    
    /// The first element of the dataSource.
    /// dataSource = [[Element]]
    ///
    /// If the dataSource is empty, the value of this property is `nil`.
    ///
    ///     @DataSource var dataSource:[Int]] = [[10, 20, 30, 40, 50],[10,20],[30,40]]
    ///     if let firstNumber:[Int] = $dataSource.first() {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "[10, 20, 30, 40, 50]"
    /// - Returns: the first element.
    public func first<Element>() -> [Element]? where Value == SectionDataList<Element>{
        if dataSource.count <= 0 {
            return nil
        }
        return dataSource.first
    }
    
    /// The last element of the dataSource.
    /// dataSource = [[Element]]
    ///
    /// If the dataSource is empty, the value of this property is `nil`.
    ///
    ///     @DataSource var dataSource:[Int]] = [[10, 20, 30, 40, 50],[10,20],[30,40]]
    ///     if let firstNumber:[Int] = $dataSource.last() {
    ///         print(firstNumber)
    ///     }
    ///     // Prints "[10, 20, 30, 40, 50]"
    /// - Returns: the last element.
    public func last<Element>() -> [Element]? where Value == SectionDataList<Element>{
        if dataSource.count <= 0 {
            return nil
        }
        return dataSource.last
    }
    
}
