//
//  Delegate.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-12.
//

import Foundation

public struct Delegate {
    private var block: (() -> Void)?
    
    public init() {}
    public mutating func delegate<T: AnyObject>(on target: T, block: ((T) -> Void)?) {
        self.block = { [weak target] in
            guard let target = target else { return }
            block?(target)
        }
    }
    
    public func callAsFunction() -> Void {
        block?()
    }
}

public typealias Action = Delegate
