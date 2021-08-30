//
//  ArgoKitViewReaderOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation

protocol ArgoKitViewReaderOperation: AnyObject {
    var needRemake: Bool { get set }
    var nodeObserver: ArgoKitNodeObserver { get }
    
    init(viewNode: ArgoKitNode?)
    func remakeIfNeed() -> Void
    func updateCornersRadius(_ multiRadius: ArgoKitCornerRadius) -> Void
}

extension ArgoKitViewReaderOperation {
    
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)-> Void {}
}

private struct AssociatedNodeRenderKey {
    
    static var shadowKey:Void?
    static var maskLayerKey:Void?
    static var gradientLayerKey:Void?
    static var borderLayerKey:Void?
    static var blurEffectKey:Void?
}

extension ArgoKitNode {
    
    var shadowOperation: ArgoKitViewShadowOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey) as? ArgoKitViewShadowOperation {
                return rs
            } else {
                let rs = ArgoKitViewShadowOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return rs
            }
        }
    }
    
    var maskLayerOperation: ArgoKitMaskLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey) as? ArgoKitMaskLayerOperation {
                return rs
            } else {
                let rs = ArgoKitMaskLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return rs
            }
        }
    }
    
    var gradientLayerOperation: ArgoKitGradientLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.gradientLayerKey) as? ArgoKitGradientLayerOperation {
                return rs
            } else {
                let rs = ArgoKitGradientLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.gradientLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return rs
            }
        }
    }
    
    var borderLayerOperation: ArgoKitBorderLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.borderLayerKey) as? ArgoKitBorderLayerOperation {
                return rs
            } else {
                let rs = ArgoKitBorderLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.borderLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return rs
            }
        }
    }
    
    var blurEffectOperation: ArgoKitBlurEffectOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.blurEffectKey) as? ArgoKitBlurEffectOperation {
                return rs
            } else {
                let rs = ArgoKitBlurEffectOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.blurEffectKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return rs
            }
        }
    }
}
