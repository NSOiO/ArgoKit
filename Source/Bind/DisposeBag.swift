//
//  DisposeBag.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-22.
//

import Foundation

extension Disposable {
    public func disposed(by bag: DisposeBag) {
        bag.insert(self)
    }
}

public class DisposeBag: Disposable {
    private var lock = NSLock()
    private var disposables = [Disposable]()
    private func _dispose() -> [Disposable] {
        lock.lock()
        defer {
            lock.unlock()
        }
        let disposables = self.disposables
        self.disposables.removeAll(keepingCapacity: false)
        return disposables
    }
    
    
    public init() {}
    
    public func insert(_ disposable: Disposable) {
        lock.lock()
        defer {
            lock.unlock()
        }
        self.disposables.append(disposable)
    }
    
    public func dispose() {
        let oldDisposables = self._dispose()
        for item in oldDisposables {
            item.dispose()
        }
    }
}
