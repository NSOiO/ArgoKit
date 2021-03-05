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

public extension ArgoKitIdentifiable {
    var reuseIdentifier: String {
        String(describing: Self.self) }
}

public protocol ViewModelProtocol: ArgoKitIdentifiable {
    func makeView() -> View
}

private struct AssociatedNodeKey {
      
    static var nodeVaulekey:Void?
    static var nodeIndePathKey:Void?
}

class WeakNodeContainer {
    weak var linkNode: ArgoKitNode?
    init(_ node:ArgoKitNode?) {
        linkNode = node
    }
}

extension ArgoKitIdentifiable {
    weak var argokit_linkNode: ArgoKitNode? {
        set(newValue) {
            let weakContainer:WeakNodeContainer = WeakNodeContainer(newValue)
            objc_setAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey, weakContainer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let weakContainer:WeakNodeContainer? = objc_getAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey) as? WeakNodeContainer
            return  weakContainer?.linkNode
        }
    }
}

extension ArgoKitNode: ArgoKitIdentifiable {
    
    public var reuseIdentifier: String {
        return self.identifiable
    }
}




