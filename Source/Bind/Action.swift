//
//  Action.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-26.
//

import Foundation

public protocol Action {}
public struct EmptyAction: Action { public init(){} }

public extension Observable where Value == Action {
    func watchAction<T>(type:(T.Type), _ handler: @escaping (T) -> Void) -> Disposable {
        self.watch { new in
            if let action = new as? T {
                handler(action)
            }
        }
    }
    
    func watchAction<T>(filter: @escaping (T) -> Bool, handler: @escaping (T) -> Void) -> Disposable {
        self.watch { new in
            if let action = new as? T, filter(action){
                handler(action)
            }
        }
    }
}
