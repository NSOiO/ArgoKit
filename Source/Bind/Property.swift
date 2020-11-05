//
//  Property.swift
//  SwiftBinding
//
//  Created by Dai on 2020-10-26.
//

import Foundation
//import SwiftUI

fileprivate var internalID: Int = 1

internal protocol DynamicProperty { }

@propertyWrapper
//@dynamicMemberLookup
public class Property<Value> : DynamicProperty {
    private var _value: Value
    private var subscribers = [(Value) -> Void]()
    private var subscribersMap = [Int: ((Value) -> Void)]()
    private func makeID() -> Int { internalID += 1; return internalID }
    
    /// Initialize with the provided initial value.
    public init(wrappedValue value: Value) {
        self._value = value
        print("Property init ",self.wrappedValue)
    }
    
    deinit {
        print("Property deinit ",self.wrappedValue)
    }
    
    public var projectedValue: Property<Value> {
        return self
    }

//    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Subject {
//        let s = self.wrappedValue[keyPath: keyPath]
//        return s
//    }

    /// The current state value.
    public var wrappedValue: Value {
        get {
            return _value
        }
        set {
            _value = newValue
            for subscriber in self.subscribersMap.values {
                subscriber(newValue)
            }
        }
    }
    
//    public func subscribe(_ f: @escaping (Value) -> Void) {
//        self.subscribers.append(f)
//    }
    
    public func subscribe(_ f: @escaping (Value) -> Void) -> Int{
        let id = makeID()
        self.subscribersMap[id] = f
        return id
    }
    
    public func removesubscriber(_ id: Int) {
        self.subscribersMap.removeValue(forKey: id)
    }
    
    public func watch(_ f: @escaping (Value) -> Void) -> Cancellable {
        let id = self.subscribe(f)
        let cancel = ClosureCancelable { [weak self] in
            self?.removesubscriber(id)
        }
        return cancel
    }
}

