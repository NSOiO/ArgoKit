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
    private var lock:NSLock
    
    public init(){
        lock = NSLock()
    }
    public static func registerDep(_ dep: Dep) {
        self.shared = dep
    }
    
    static func setSub(_ sub: @escaping (()->Void)) {
        Dep.shared.lock.lock()
        self.shared.subscriber = sub
        Dep.shared.lock.unlock()
    }
    
    static func removeSub() {
        Dep.shared.lock.lock()
        self.shared.subscriber = nil
        Dep.shared.lock.unlock()
    }
    
    static func getSub() -> (() -> Void)? {
        Dep.shared.lock.lock()
        let subscriber_ = self.shared.subscriber
        Dep.shared.lock.unlock()
        return subscriber_
    }
    
    /// Cancellable
    static func pushCancellable(_ cancel: Disposable) {
        Dep.shared.lock.lock()
        self.shared.cancellables.append(cancel)
        Dep.shared.lock.unlock()
    }
    
    static func popAllCancellables() -> [Disposable]{
        Dep.shared.lock.lock()
        let r = self.shared.cancellables
        self.shared.cancellables.removeAll()
        Dep.shared.lock.unlock()
        return r
    }
}
