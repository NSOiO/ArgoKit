//
//  DataBind.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/23.
//

import Foundation
//public typealias DataList<T> = [[T]]
//@propertyWrapper
//public class DataBind<Value>{
//    private var _value: DataList<Value>? = nil
//
//
//    public init() {}
//    public init(wrappedValue value: DataList<Value>?){
//        self._value = value
//    }
//
//    public var projectedValue: DataBind<Value> {
//        return self
//    }
//
//    public var wrappedValue: DataList<Value>? {
//        get {
//            return _value
//        }
//        set {
//            _value = newValue
//        }
//    }
//
//    var nodeCache:[String:ArgoKitNode] = [:]
//    func addNode(key:String,node:ArgoKitNode){
//        nodeCache[key] = node
//    }
//
//    func removeNode(key:String){
//        nodeCache.removeValue(forKey: key)
//    }
//
//    func removeAllNodes(){
//        nodeCache.removeAll()
//    }
//
//    func getNode(key:String)->ArgoKitNode?{
//        return nodeCache[key]
//    }
//}

public typealias SectionDataList<T> = [[T]]
public typealias DataList<T> = [T]
@propertyWrapper
public class DataSource<Value>{
    private var _value: Value? = nil
   
    
    public init() {}
    public init(wrappedValue value: Value?){
        self._value = value
    }
    
    public var projectedValue: DataSource<Value> {
        return self
    }

    public var wrappedValue: Value? {
        get {
            return _value
        }
        set {
            _value = newValue
            removeAllNodes()
        }
        
    }
    
    var nodeCache:[String:ArgoKitNode] = [:]
    func addNode(key:String,node:ArgoKitNode){
        nodeCache[key] = node
    }
    
    func removeNode(key:String){
        nodeCache.removeValue(forKey: key)
    }
    
    func removeAllNodes(){
        nodeCache.removeAll()
    }
    
    func getNode(key:String)->ArgoKitNode?{
        return nodeCache[key]
    }
}
