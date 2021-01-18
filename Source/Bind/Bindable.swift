//
//  Bindable.swift
//  ArgoKit
//
//  Created by Dongpeng Dai on 2021/1/8.
//

import Foundation

@propertyWrapper
public struct Bindable<Value>  {
    private var _value: () -> Value
    public init(wrappedValue value: @escaping @autoclosure () -> Value) {
        self._value = value
    }
    public var wrappedValue: Value { _value() }
}

@propertyWrapper
public enum Lazy<Value> {
    case uninitialized(() -> Value)
    case initialized(Value)

    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(wrappedValue)
    }

    public var wrappedValue: Value {
        mutating get {
          switch self {
              case .uninitialized(let initializer):
                let value = initializer()
                self = .initialized(value)
                return value
              case .initialized(let value):
                return value
          }
        }
        set {
            self = .initialized(newValue)
        }
    }
    
    public var projectedValue: Lazy<Value> {
        return self
    }
}

/*
extension Bindable: ExpressibleByUnicodeScalarLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral where Value == String {
    public init(/unicodeScalarLiteral value: Value) {
        self.init(wrappedValue: value)
    }
    public init(extendedGraphemeClusterLiteral value: Value) {
        self.init(wrappedValue: value)
    }
    public init(stringLiteral value: Value) {
        self.init(wrappedValue: value)
    }
}

extension Bindable: ExpressibleByIntegerLiteral where Value == Int {
    public init(integerLiteral value: Value) {
        self.init(wrappedValue: value)
    }
}

extension Bindable: ExpressibleByFloatLiteral where Value == Float{
    public init(floatLiteral value: Value) {
        self.init(wrappedValue: value)
    }
}

extension Bindable: ExpressibleByBooleanLiteral where Value == Bool {
    public init(booleanLiteral value: Value) {
        self.init(wrappedValue: value)
    }
}
*/
