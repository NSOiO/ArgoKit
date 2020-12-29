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
public class DataSource<Value>{
    
    weak var _rootNode : DataSourceReloadNode?
    private var _value: Value
   
    public init(wrappedValue value: Value){
        self._value = value
    }
    
    public var projectedValue: DataSource<Value> {
        return self
    }

    public var wrappedValue: Value {
        get {
            return _value
        }
        set {
            _value = newValue
        }

    }
    
}


extension DataSource{
    private func dataSource()->Array<Array<Any>>? {
        if let value = _value as? SectionDataList<Any> {
            return value
        }else if let value = _value as? DataList<Any>{
            return [value]
        }
        return [[]]
    }
    
    public func reloadData(){
        if let node = self._rootNode{
            node.reloadData()
        }
    }
    
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            for indexPath in indexPaths {
                if indexPath.section >= dataSource()?.count ?? 0
                    || indexPath.row >= dataSource()?[indexPath.section].count ?? 0{
                    continue
                }
                if let data = dataSource()?[indexPath.section][indexPath.row] as? ArgoKitIdentifiable{
                    data.linkNode = nil
                }
            }
            node.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            node.insertSections(sections,with: animation)
        }
    }



    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            node.reloadSections(sections,with: animation)
        }
    }

    public func moveSection(_ section: Int, toSection newSection: Int){
        if let node = self._rootNode{
            node.moveSection(section,toSection: newSection)
        }
    }

    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            node.insertRows(at: indexPaths, with: animation)
        }
    }
    
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            node.deleteSections(sections,with: animation)
        }
    }
    public func deleteSection(_ sections: IndexSet, with animation: UITableView.RowAnimation){
        if let node = self._rootNode{
            node.deleteSections(sections,with: animation)
        }
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        for indexPath in indexPaths {
            if var value = _value as? SectionDataList<Any> {
                value[indexPath.section].remove(at:indexPath.row)
            }
            if var value = _value as? DataList<Any>{
                value.remove(at:indexPath.row)
            }
        }
        
        if let node = self._rootNode{
            node.deleteRows(at: indexPaths, with: animation)
        }
    }
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation){
        self.deleteRows(at: [indexPath], with: animation)
    }


    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath){
        
        if indexPath.section >= dataSource()?.count ?? 0
            || indexPath.row >= dataSource()?[indexPath.section].count ?? 0
            || newIndexPath.section >= dataSource()?.count ?? 0 {
            return
        }
        
        let itemToMove = dataSource()![indexPath.section][indexPath.row]
        if var value = _value as? SectionDataList<Any> {
            value[indexPath.section].remove(at:indexPath.row)
        }else if var value = _value as? DataList<Any>{
            value.remove(at:indexPath.row)
        }
        if indexPath.section != newIndexPath.section
            || newIndexPath.row < indexPath.row {
            if var value = _value as? SectionDataList<Any> {
                value[newIndexPath.section].insert(itemToMove,at:newIndexPath.row)
            }else if var value = _value as? DataList<Any>{
                value.insert(itemToMove,at:newIndexPath.row)
            }
        } else {
            if var value = _value as? SectionDataList<Any> {
                value[newIndexPath.section].insert(itemToMove,at:newIndexPath.row - 1)
            }else if var value = _value as? DataList<Any>{
                value.insert(itemToMove,at:newIndexPath.row - 1)
            }
        }
        
        if let node = self._rootNode{
            node.moveRow(at: indexPath, to: newIndexPath)
        }
    }
}
