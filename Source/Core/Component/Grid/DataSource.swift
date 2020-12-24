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
        }
    }
}
