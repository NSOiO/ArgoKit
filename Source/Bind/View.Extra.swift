//
//  View.bind.Swift
//  ArgoKit
//
//  Created by Dai on 2020-11-06.
//

import Foundation

extension View {
    private func p_watch<R: View,V>(property: Property<V>, function:@escaping (V) -> R, key: String) {
        let cancel = property.watch { (new) in
            _ = function(new)
        }
        self.node?.bindProperties.setObject(cancel, forKey: key as NSString)
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
    
    func watch<R: View, V>(property: Property<V?>?, function: @escaping (V?) -> R, key: String, triggerImmediately: Bool = true) -> Self{
        if let pro = property {
            if triggerImmediately {
                _ = function(pro.wrappedValue)
            }
            self.p_watch(property: pro, function: function, key: key)
        } else {
            if triggerImmediately {
                _ = function(nil)
            }
            self.p_unwatch(key: key)
        }
        return self
    }
    
    func watch<R: View, V>(property: Property<V>?, function: @escaping (V) -> R, key: String, triggerImmediately: Bool = true) -> Self{
        if let pro = property {
            if triggerImmediately {
                _ = function(pro.wrappedValue)
            }
            self.p_watch(property: pro, function: function, key: key)
        } else {
            self.p_unwatch(key: key)
        }
        return self
    }
    
    func alias(_ alias: Alias<Self?>) -> Self{
        alias.wrappedValue = self
        return self
    }
}

//func watch<R: View,V>(object: R, property: Property<V>, f:@escaping (V) -> R, key: String) {
//    let cancel = property.watch { (new) in
//        _ = f(new)
//    }
//    object.node?.bindProperties.setObject(cancel, forKey: key as NSString)
//}
