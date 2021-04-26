//
//  Cancelable.swift
//  SwiftBinding
//
//  Created by Dai on 2020-10-28.
//

import Foundation

#if false
// use Disposable instead.
public protocol Cancellable {
    func cancel()
}

public class ClosureCancelable: Cancellable {
    var callback: (() -> Void)?
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    deinit {
//        if let block = self.callback {
//            block()
//        }
        if let _ = self.callback {
            self.callback = nil
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
#endif
