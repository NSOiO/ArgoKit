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
public class Observable<Value> : DynamicProperty {
    private var _value: Value
//    private var subscribers = [(Value) -> Void]()
    private var subscribersMap = [Int: ((Value) -> Void)]()
    private func makeID() -> Int { internalID += 1; return internalID }
    /// Initialize with the provided initial value.
    public init(wrappedValue value: Value) {
        self._value = value
    }
    
    deinit {
        subscribersMap.removeAll()
    }
    
    public var projectedValue: Observable<Value> {
        return self
    }

//    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Subject {
//        let s = self.wrappedValue[keyPath: keyPath]
//        return s
//    }

    /// The current state value.
    public var wrappedValue: Value {
        get {
            if let sub = Dep.getSub() {
                Dep.pushCancellable(self.watch(sub))
            }
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
    
    public func watch(_ f: @escaping (Value) -> Void) -> Disposable {
        let id = self.subscribe(f)
        let cancel = ClosureDisposable { [weak self] in
            self?.removesubscriber(id)
        }
        return cancel
    }
    
    public func watch(_ f:@escaping () -> Void) -> Disposable {
        self.watch { _ in
            f()
        }
        
    }
    
    public func watch<T>(type:(T.Type), _ handler: @escaping (T) -> Void) -> Disposable {
        self.watch { new in
            if let action = new as? T {
                handler(action)
            }
        }
    }
}

