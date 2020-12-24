//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation

public protocol ArgoKitIdentifiable:class {
    var reuseIdentifier: String {get} // 复用标识，用于同样式的UI复用
    var identifier: String {get} // 唯一标识
}

private struct AssociatedNodeKey{
       static var nodeIdentifier:Void?
       static var nodeVaulekey:Void?
}
extension ArgoKitIdentifiable {
    
    public var identifier: String{
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeKey.nodeIdentifier) as? String {
                return rs
            }else{
                let rs = Date().timeIntervalSince1970 * 1000.0
                let identifier_ =  String(rs)
                print("identifier_:\(identifier_)")
                 objc_setAssociatedObject(self, &AssociatedNodeKey.nodeIdentifier,identifier_, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                 return identifier_
            }
        }
    }
    
}

extension ArgoKitIdentifiable {
    var linkNode: ArgoKitNode? {
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &AssociatedNodeKey.nodeVaulekey) as? ArgoKitNode
        }
    }
}



extension ArgoKitNode: ArgoKitIdentifiable {
    
    public var reuseIdentifier: String {
        return String(self.hashValue)
    }
    
    
}




