//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation

/// A class of types whose instances hold the value of an entity with stable identity.
public protocol ArgoKitIdentifiable: class {
    
    /// A string used to identify a cell that is reusable.
    var reuseIdentifier: String {get} // 复用标识，用于同样式的UI复用
}

private struct AssociatedNodeKey {
      
    static var nodeVaulekey:Void?
    static var nodeIndePathKey:Void?
}

extension ArgoKitIdentifiable {
    var argokit_linkNode: ArgoKitNode? {
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey) as? ArgoKitNode
        }
    }
    
    var argokit_indexPath: IndexPath? {
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedNodeKey.nodeIndePathKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return  objc_getAssociatedObject(self, &AssociatedNodeKey.nodeIndePathKey) as? IndexPath
        }
    }
}

extension ArgoKitNode: ArgoKitIdentifiable {
    
    public var reuseIdentifier: String {
        return self.identifiable
    }
}




