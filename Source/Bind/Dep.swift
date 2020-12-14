//
//  Dep.swift
//  ArgoKit
//
//  Created by Dai on 2020-12-04.
//

import Foundation

final class Dep {
    private static var subscriber:(() -> Void)?
    private static var cancellables:[Cancellable] = []
    
    static func setSub(_ sub: @escaping (()->Void)) {
        self.subscriber = sub;
    }
    
    static func removeSub() {
        self.subscriber = nil
    }
    
    static func getSub() -> (() -> Void)? {
        return self.subscriber
    }
    
    /// Cancellable
    static func pushCancellable(_ cancel: Cancellable) {
        self.cancellables.append(cancel)
    }
    
    static func popAllCancellables() -> [Cancellable]{
        let r = self.cancellables
        self.cancellables.removeAll()
        return r
    }
    
}
