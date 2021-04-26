//
//  Alias.swift
//  ArgoKit
//
//  Created by Dai on 2020-11-02.
//

import Foundation

@propertyWrapper
public class Alias<Value> : DynamicProperty {
    private var _value: Value? = nil
    
    public init() {}
    public init(wrappedValue value: Value?) {
        self._value = value
    }
    
    public var projectedValue: Alias<Value> {
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

/* TODO: Aliasable contains Self
public protocol Aliasable {
    func alias(variable: Alias<Self>) -> Self;
}

public extension Aliasable {
    @discardableResult
    func alias(variable: Alias<Self>) -> Self {
        variable.wrappedValue = self
        return self
    }
}
*/
