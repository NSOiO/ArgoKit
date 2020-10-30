//
//  Cancelable.swift
//  SwiftBinding
//
//  Created by Dai on 2020-10-28.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public class ClosureCancelable: Cancellable {
    var callback: (() -> Void)?
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    deinit {
        if let block = self.callback {
            block()
        }
    }
    public func cancel() {
        guard let block = self.callback else {
            print("had alread been cancelled")
            return
        }
        block()
        self.callback = nil
    }
}
