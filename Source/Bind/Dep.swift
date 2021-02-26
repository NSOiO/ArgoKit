//
//  Dep.swift
//  ArgoKit
//
//  Created by Dai on 2020-12-04.
//

import Foundation

public final class Dep {
    private static var shared: Dep = Dep()
    private var subscriber:(() -> Void)?
    private var cancellables:[Disposable] = []
    private let lock:NSLock
    
    public init(){
        lock = NSLock()
    }
    public static func registerDep(_ dep: Dep) {
        self.shared = dep
    }
    
    static func setSub(_ sub: @escaping (()->Void)) {
        Dep.shared.lock.lock()
        defer {
            Dep.shared.lock.unlock()
        }
        self.shared.subscriber = sub
    }
    
    static func removeSub() {
        Dep.shared.lock.lock()
        defer {
            Dep.shared.lock.unlock()
        }
        self.shared.subscriber = nil
    }
    
    static func getSub() -> (() -> Void)? {
        Dep.shared.lock.lock()
        defer {
            Dep.shared.lock.unlock()
        }
        let subscriber_ = self.shared.subscriber
        return subscriber_
    }
    
    /// Cancellable
    static func pushCancellable(_ cancel: Disposable) {
        Dep.shared.lock.lock()
        defer {
            Dep.shared.lock.unlock()
        }
        self.shared.cancellables.append(cancel)
    }
    
    static func popAllCancellables() -> [Disposable]{
        Dep.shared.lock.lock()
        defer {
            Dep.shared.lock.unlock()
        }
        let r = self.shared.cancellables
        self.shared.cancellables.removeAll()
        return r
    }
}
