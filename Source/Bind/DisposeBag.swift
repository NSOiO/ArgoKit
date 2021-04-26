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
    private var disposables = [Disposable]()
    private func _dispose() -> [Disposable] {
        let disposables = self.disposables
        self.disposables.removeAll(keepingCapacity: false)
        return disposables
    }
    
    
    public init() {}
    
    public func insert(_ disposable: Disposable) {
        self.disposables.append(disposable)
    }
    
    public func dispose() {
        let oldDisposables = self._dispose()
        for item in oldDisposables {
            item.dispose()
        }
    }
}
