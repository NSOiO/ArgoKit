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
            if let value = _value as? SectionDataList<Any> {
                for subValue in value {
                    if let item = subValue as? DataList<Any>{
                        for iv in item {
                            if let item = iv  as? ArgoKitIdentifiable {
                                property_getName(model: item)
                            }
                        }
                    }
                }
            }
            if let value = _value as? DataList<Any>{
                for iv in value {
                    if let item = iv  as? ArgoKitIdentifiable {
                        property_getName(model: item)
                    }
                }
            }
        }
    }
    
    func property_getName(model:ArgoKitIdentifiable){
        while true {
            var count: UInt32 = 0;
            var cls: AnyClass? = object_getClass(model);
            let ivarList = class_copyIvarList(cls, &count);
            for i in 0..<count {
                let ivarName = ivar_getName(ivarList![Int(i)])
                let key = String(cString: ivarName!)
                debugPrint(key)
            }
            if let superCls = cls?.superclass(), superCls.self != NSObject.self {
                   cls = superCls
                } else {
                    break
                }
        }
       
    }
}
