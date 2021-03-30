//
//  View.Bind.swift
//  ArgoKit
//
//  Created by Dongpeng Dai on 2020/12/23.
//

import Foundation

extension View {
    private func p_watch<R: View,V>(properties: Observable<V>..., function:@escaping (V) -> R, key: String) {
        self.p_watch(properties: properties, function: function, key: key)
    }
    
    private func p_watch<R: View,V>(properties: [Observable<V>], function:@escaping (V) -> R, key: String) {
        var cancels:[Disposable] = []
        for property in properties {
            let cancel = property.watch { (new) in
                _ = function(new)
            }
            cancels.append(cancel)
        }

        self.node?.bindProperties.setObject(cancels, forKey: key as NSString)
    }
    
    private func p_unwatch(key: String) {
        self.node?.bindProperties.removeObject(forKey: key as NSString)
    }
    
    /*
    func watch<R: View, V>(property: Property<V>?, f: @escaping (V) -> R, key: String) {
        if let pro = property {
            self.watch(property: pro, f: f, key: key)
        } else {
            self.unwatch(key: key)
        }
    }
    */
    
    func watch<R: View, V>(property: Observable<V?>?, function: @escaping (V?) -> R, key: String, triggerImmediately: Bool = true) -> Self{
        if let pro = property {
            if triggerImmediately {
                _ = function(pro.wrappedValue)
            }
            self.p_watch(properties: pro, function: function, key: key)
        } else {
            if triggerImmediately {
                _ = function(nil)
            }
            self.p_unwatch(key: key)
        }
        return self
    }
    
    func watch<R: View, V>(property: Observable<V>?, function: @escaping (V) -> R, key: String, triggerImmediately: Bool = true) -> Self{
        if let pro = property {
            if triggerImmediately {
                _ = function(pro.wrappedValue)
            }
            self.p_watch(properties: pro, function: function, key: key)
        } else {
            self.p_unwatch(key: key)
        }
        return self
    }
    
    private func setCancellables(_ cancellables: [Disposable], forKey key: String) {
        if let node = self.node {
            node.bindProperties.setObject(cancellables, forKey: key as NSString)
        } else {
            fatalError("node should not be nil")
        }
        
    }
    
    private func removeCancellables(forKey key: String) {
        self.node?.bindProperties.removeObject(forKey: key)
    }
    
    @discardableResult
    public func bindCallback(_ callback: @escaping () -> Void, forKey key: String) -> Self {
//        Dep.setSub { //[weak self] in
//            self.removeCancellables(forKey: key)
//            self.bindCallback(callback, forKey: key)
//        }
//        callback()
//        Dep.removeSub()
//        let cancels = Dep.popAllCancellables()
//        if cancels.count > 0 {
//            self.setCancellables(cancels, forKey: key)
//        }
        ArgoKitUtils.runMainThreadSyncBlock {
            self.bindCallback_(callback, forKey: key)
        }
        return self
    }
    
    private func bindCallback_(_ callback: @escaping () -> Void, forKey key: String){
        Dep.setSub { //[weak self] in
            self.removeCancellables(forKey: key)
            self.bindCallback(callback, forKey: key)
        }
        callback()
        Dep.removeSub()
        let cancels = Dep.popAllCancellables()
        if cancels.count > 0 {
            self.setCancellables(cancels, forKey: key)
        }
    }

//    func alias(_ alias: Alias<Self?>) -> Self{
//        alias.wrappedValue = self
//        return self
//    }
}

//func watch<R: View,V>(object: R, property: Property<V>, f:@escaping (V) -> R, key: String) {
//    let cancel = property.watch { (new) in
//        _ = f(new)
//    }
//    object.node?.bindProperties.setObject(cancel, forKey: key as NSString)
//}
