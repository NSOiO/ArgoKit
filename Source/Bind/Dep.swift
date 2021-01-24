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
    
    public init(){ }
    public static func registerDep(_ dep: Dep) {
        self.shared = dep
    }
    
    static func setSub(_ sub: @escaping (()->Void)) {
        self.shared.subscriber = sub
    }
    
    static func removeSub() {
        self.shared.subscriber = nil
    }
    
    static func getSub() -> (() -> Void)? {
        return self.shared.subscriber
    }
    
    /// Cancellable
    static func pushCancellable(_ cancel: Disposable) {
        self.shared.cancellables.append(cancel)
    }
    
    static func popAllCancellables() -> [Disposable]{
        let r = self.shared.cancellables
        self.shared.cancellables.removeAll()
        return r
    }
}
