//
//  ArgoKitViewReaderOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
protocol ArgoKitViewReaderOperation:AnyObject{
    var needRemake:Bool{get set}
    var nodeObserver:ArgoKitNodeObserver{get}
    init(viewNode:ArgoKitNode)
    func remakeIfNeed() -> Void
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void
}
extension ArgoKitViewReaderOperation{
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{}
}

private struct AssociatedNodeRenderKey {
       static var shadowKey:Void?
       static var maskLayerKey:Void?
       static var gradientLayerKey:Void?
}
extension ArgoKitNode{
    var shadowOperation: ArgoKitViewShadowOperation? {
           get {
               if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey) as? ArgoKitViewShadowOperation {
                   return rs
               }else{
                    let rs = ArgoKitViewShadowOperation(viewNode: self)
                    objc_setAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    ArgoKitViewReaderHelper.shared.addRenderOperation(operation:rs)
                    return rs
               }
           }
       }
    
    var maskLayerOperation: ArgoKitViewLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey) as? ArgoKitViewLayerOperation {
                return rs
            }else{
                 let rs = ArgoKitViewLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:rs)
                 return rs
            }
        }
    }
    
    var gradientLayerOperation: ArgoKitGradientLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.gradientLayerKey) as? ArgoKitGradientLayerOperation {
                return rs
            }else{
                 let rs = ArgoKitGradientLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.gradientLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:rs)
                 return rs
            }
        }
    }
}
