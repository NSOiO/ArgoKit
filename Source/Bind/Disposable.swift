//
//  Disposable.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-22.
//

import Foundation
public protocol Disposable {
    func dispose()
}

public class ClosureDisposable: Disposable {
    var callback: (() -> Void)?
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    deinit {
        if let block = self.callback {
            block()
        }
    }
    public func dispose() {
        guard let block = self.callback else {
            print("had alread been disposed")
            return
        }
        block()
        self.callback = nil
    }
}
