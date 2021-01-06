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
//            dataSource = newValue
//            fatalError("$")
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
    
    private func _moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath){
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
    
    private func swap<T>(_ nums:inout[T],_ a:Int,_ b:Int) {
        let count = nums.count
        if a == b || a < 0 || a > count - 1 || b < 0 || b > count - 1 {
            return
        }
        (nums[a],nums[b]) = (nums[b],nums[a])
    }
    
    
    @discardableResult
    public func append<D>(data:D) -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        dataSource.append(data)
        return self
    }
    
    @discardableResult
    public func append<D>(data:DataList<D>) -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        dataSource.append(data)
        return self
    }
    
    @discardableResult
    public func append<D>(contentsOf datas:DataList<D>) -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        dataSource.append(contentsOf: datas)
        return self
    }
    
    @discardableResult
    public func append<D>(contentsOf datas:SectionDataList<D>) -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        dataSource.append(contentsOf: datas)
        return self
    }
    
    @discardableResult
    public func insert<D>(datas:[D],at indexPaths: [IndexPath],with animation: UITableView.RowAnimation = .none) -> Self
    where Value == DataList<D>, D:ArgoKitIdentifiable{
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
    
    @discardableResult
    public func insert<D>(datas:[D],at indexPaths: [IndexPath],with animation: UITableView.RowAnimation = .none) -> Self
    where Value == SectionDataList<D>, D:ArgoKitIdentifiable{
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
    
    @discardableResult
    public func insert<D>(data:D,at indexPath: IndexPath,with animation: UITableView.RowAnimation = .none) -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        return insert(datas: [data], at: [indexPath])
    }
    
    @discardableResult
    public func insert<D>(data:D,at indexPath: IndexPath,with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        return insert(datas: [data], at: [indexPath])
    }
    
    @discardableResult
    public func delete<D>(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        return self.delete(at: [indexPath], with: animation)
    }
    
    @discardableResult
    public func delete<D>(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        return self.delete(at: [indexPath], with: animation)
    }
    
    @discardableResult
    public func delete<D>(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        for indexPath in indexPaths {
            if dataSource.count <= indexPath.row {
                continue
            }
            dataSource.remove(at:indexPath.row)
        }
        self.deleteRows(at: indexPaths)
        return self
    }
    
    @discardableResult
    public func delete<D>(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable {
        for indexPath in indexPaths {
            if dataSource.count <= indexPath.section {
                continue
            }
            if dataSource[indexPath.section].count <= indexPath.row {
                continue
            }
            dataSource[indexPath.section].remove(at:indexPath.row)
        }
        self.deleteRows(at: indexPaths)
        return self
    }
    
    @discardableResult
    public func replace<D>(datas:[D],at replaceIndexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none) -> Self
    where Value == DataList<D>, D:ArgoKitIdentifiable{
        if datas.count !=  replaceIndexPaths.count{
            return self
        }
        for index in 0 ..< datas.count{
            let data = datas[index]
            let indexPath = replaceIndexPaths[index]
            if dataSource.count <= indexPath.row {
              continue
            }
            dataSource.replaceSubrange(Range(uncheckedBounds: (lower: indexPath.row, upper: indexPath.row)), with: [data])
        }
        self.reloadRows(at: replaceIndexPaths)
        return self
    }
    
    @discardableResult
    public func replace<D>(datas:[D],at replaceIndexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none) -> Self
    where Value == SectionDataList<D>, D:ArgoKitIdentifiable{
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
            dataSource[indexPath.section].replaceSubrange(Range(uncheckedBounds: (lower: indexPath.row, upper: indexPath.row)), with: [data])
        }
        self.reloadRows(at: replaceIndexPaths)
        return self
    }
    
    @discardableResult
    public func replace<D>(data:D,at indexPath: IndexPath,with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        return replace(datas: [data], at: [indexPath],with: animation)
    }
    
    @discardableResult
    public func replace<D>(data:D,at indexPath: IndexPath,with animation: UITableView.RowAnimation = .none)
    -> Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        return replace(datas: [data], at: [indexPath])
    }
    
    public func move<D>(at indexPath: IndexPath, to newIndexPath: IndexPath) ->Self
    where Value == DataList<D>,D:ArgoKitIdentifiable{
        let count = dataSource.count;
        if indexPath.section != 0 ||  newIndexPath.section != 0 {
            return self
        }
        if indexPath.row >= count ||  newIndexPath.row >= count {
            return self
        }
        swap(&dataSource, indexPath.row, newIndexPath.row)
        
        self._moveRow(at: indexPath, to: newIndexPath)
        return self
    }

    
    public func move<D>(at indexPath: IndexPath, to newIndexPath: IndexPath)
    ->Self
    where Value == SectionDataList<D>,D:ArgoKitIdentifiable{
        let section = dataSource.count
        let count = dataSource[section].count;
        if indexPath.section >= section ||  newIndexPath.section >= section {
            return self
        }
        if indexPath.row >= count ||  newIndexPath.row >= count {
            return self
        }
        
        swap(&dataSource[indexPath.section], indexPath.row, newIndexPath.row)
        
        self._moveRow(at: indexPath, to: newIndexPath)
        return self
    }
    
}
