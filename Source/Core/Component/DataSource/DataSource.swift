//
//  DataBind.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/23.
//

import Foundation

public typealias SectionDataList<T> = [[T]]
public typealias DataList<T> = [T]

@propertyWrapper
public class DataSource<Value>  {
    
    weak var _rootNode : DataSourceReloadNode?
    public var _value: Value
    public var dataSource: Value
    
    public var reloadAction:((UITableView.RowAnimation)->Void)?
   
    public init<D>(wrappedValue value: Value) where Value == DataList<D>{
        self.dataSource = value
        _value = value
    }
    
    public var projectedValue: DataSource<Value> {
        return self
    }

    public var wrappedValue: Value  {
        get {
            return dataSource
        }
        set {
            #if DEBUG
                fatalError("Please prefix an instance of a DataSource with $")
            #endif
        }
    }
}

extension DataSource{
    public func getDataSource<D>()->SectionDataList<D> where Value == SectionDataList<D>{
        return dataSource
    }
    
    public func getDataSource<D>()->DataList<D> where Value == DataList<D>{
        return dataSource
    }
    public func apply(with animation: UITableView.RowAnimation = .none){
        if let action = reloadAction{
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
                    print("indexPaths:\(indexPaths)")
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
    
    /// Adds a new element at the end of the dataSource.
    ///
    /// Use this method to append a single element to the end of a dataSource. And Element:ArgoKitIdentifiable
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
    ///
    /// - Returns: Self
    @discardableResult
    public func append<Element>(_ newElement:Element) -> Self
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
        dataSource.append(newElement)
        return self
    }
    
    /// Adds a new element at the end of the dataSource.
    ///
    /// Use this method to append a single element to the end of a dataSource. And Element:ArgoKitIdentifiable.
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
    ///
    /// - Returns: Self
    @discardableResult
    public func append<Element>(_ newElement:DataList<Element>) -> Self
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        dataSource.append(newElement)
        return self
    }
    
    /// Adds the elements of a [Element] to the end of the dataSource.And Element:ArgoKitIdentifiable.
    ///
    /// Use this method to append the elements of a [Element] to the end of this dataSource.
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
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
        dataSource.append(contentsOf: newElements)
        return self
    }
    
    /// Adds the elements of a [[Element]] to the end of the dataSource.And Element:ArgoKitIdentifiable.
    ///
    /// Use this method to append the elements of a [Element] to the end of this dataSource.
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
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        dataSource.append(contentsOf: newElements)
        return self
    }
    
    /// Inserts the elements of a [Element] to the end of the dataSource.And Element:ArgoKitIdentifiable.
    ///
    /// The elements of a [Element] is inserted before the element currently at the specified IndexPath of IndexPaths.
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
    where Value == DataList<Element>, Element:ArgoKitIdentifiable{
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
    
    /// Inserts the elements of a [Element] to the end of the dataSource.And Element:ArgoKitIdentifiable.
    ///
    /// The elements of a [Element] is inserted before the element currently at the specified IndexPath of IndexPaths.
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
    where Value == SectionDataList<Element>, Element:ArgoKitIdentifiable{
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
    
    /// Inserts a new element at the specified position.
    /// The new element is inserted before the element currently at the specified index.
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
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
        return insert(datas: [data], at: [indexPath])
    }
    
    /// Inserts a new element at the specified position.
    /// The new element is inserted before the element currently at the specified index.
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
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        return insert(datas: [data], at: [indexPath])
    }
    
    /// delete the element at the specified position from dataSource.
    ///
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
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
        return self.delete(at: [indexPath])
    }
    
    /// delete the element at the specified position from dataSource.
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
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        return self.delete(at: [indexPath])
    }
    
    /// delete the element at the specified positions from dataSource.
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
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
        var indices:[Int] = []
        for indexPath in indexPaths {
            if dataSource.count <= indexPath.row {
                continue
            }
            indices.append(indexPath.row)
        }
        let reversedndices = indices.sorted().reversed()
        for i in reversedndices {
            guard i < dataSource.count else { return self}
            dataSource.remove(at: i)
        }
        self.deleteRows(at: indexPaths)
        return self
    }
    
    /// delete the element at the specified position from dataSource.
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
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        var section:[Int:[Int]] = [:]
        for indexPath in indexPaths {
            if dataSource.count <= indexPath.section {
                continue
            }
            if dataSource[indexPath.section].count <= indexPath.row {
                continue
            }
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
                dataSource[key].remove(at: i)
            }
        }
        self.deleteRows(at: indexPaths)
        return self
    }
    
    /// replace the element of [Element] at the specified positions from dataSource.
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
    where Value == DataList<Element>, Element:ArgoKitIdentifiable{
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
    where Value == SectionDataList<Element>, Element:ArgoKitIdentifiable{
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
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
        return replace(datas: [data], at: [indexPath])
    }
    
    /// move the element  at the specified position to new position for dataSource.
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
    where Value == DataList<Element>,Element:ArgoKitIdentifiable{
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
    ///
    /// ```
    ///     @DataSource var dataSource:[[Int]] = [[1, 5, 9, 12, 15, 13, 12],[1, 5, 7], [15, 13, 12,24,1]]
    ///     $dataSource.move(at:IndexPath(row: 1, section: 0), at:IndexPath(row: 2, section: 1))
    ///     print(dataSource)
    ///     // Prints "[1, 9, 5, 12, 15, 13, 12]"
    ///```
    ///
    /// - Parameter indexPath: The  position that element will move from.
    /// - Parameter newIndexPath: The new position that element will move to.
    /// - Returns: Self.
    ///
    @discardableResult
    public func move<Element>(at indexPath: IndexPath, to newIndexPath: IndexPath)
    ->Self
    where Value == SectionDataList<Element>,Element:ArgoKitIdentifiable{
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
        if indexPath.section > section - 1 &&
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
        let count = datas.count;
        if indexPath.row > count - 1 {
            return false
        }
        if newIndexPath.row >= count {
            return false
        }
        if newIndexPath.section < 0
            || newIndexPath.row < 0
            || indexPath.section < 0
            || indexPath.row < 0{
            return false
        }
        let data = datas[indexPath.row]
        datas.remove(at: indexPath.row)
        datas.insert(data, at: newIndexPath.row)
        return true
    }
    
}
