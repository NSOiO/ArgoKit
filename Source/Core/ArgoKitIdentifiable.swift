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
    static var nodeCellHeightKey:Void?
}

class WeakNodeContainer {
    weak var linkNode: ArgoKitNode?
    init(_ node:ArgoKitNode?) {
        linkNode = node
    }
}

class HeightContainer {
    var height:CGFloat = 0
    init(_ height_:CGFloat) {
        height = height_
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
    
    // 存储cell的高度
      var argokit_cellHeight: CGFloat {
          set(newValue) {
              let height:HeightContainer = HeightContainer(newValue)
              objc_setAssociatedObject(self, &AssociatedNodeKey.nodeCellHeightKey, height, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
          }
          get {
              let weakContainer:HeightContainer? = objc_getAssociatedObject(self, &AssociatedNodeKey.nodeCellHeightKey) as? HeightContainer
              return weakContainer?.height ?? 0
          }
      }
}

extension ArgoKitNode: ArgoKitIdentifiable {
    
    public var reuseIdentifier: String {
        return self.identifiable
    }
}




