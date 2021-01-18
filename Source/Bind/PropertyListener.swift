//
//  PropertyListener.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-18.
//

import Foundation

#if false
@propertyWrapper
public class PropertyListener<Value>: Property<Value> {
    public typealias Listener = (Value) -> Void
    let listener: Listener
    lazy var autoListen = self.watch { [weak self] value in
        self?.listener(value)
    }
    
    public init(wrappedValue value: Value, _ listener: @escaping Listener) {
        self.listener = listener
        super.init(wrappedValue: value)
    }
    
    public override var wrappedValue: Value {
        get {
            _ = self.autoListen
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }
}
#endif
