//
//  ArgoKitMaskLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation

class ArgoKitMaskLayerOperation: NSObject, ArgoKitViewReaderOperation {
    
    var bezierPathCache: [String: UIBezierPath] = [:]
    private var _needRemake: Bool = false
    var needRemake: Bool {
        get {
            _needRemake
        }
        set {
            _needRemake = newValue
        }
    }
    private var _nodeObserver: ArgoKitNodeObserver = ArgoKitNodeObserver()
    var nodeObserver: ArgoKitNodeObserver {
        get {
            _nodeObserver
        }
    }
    var multiRadius: ArgoKitCornerRadius?
    private var pcircle: Bool?
    
    weak var viewNode: ArgoKitNode?
    private var observation: NSKeyValueObservation?
    
    required init(viewNode: ArgoKitNode?) {
        self.viewNode = viewNode
        super.init()
        
        self.nodeObserver.setCreateViewBlock { [weak self] view in
            if let strongSelf = self {
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation: strongSelf)
                strongSelf.observation = view.observe(\UIView.frame, options: [.new, .old], changeHandler: { (view, change) in
                    strongSelf.observeValue(change, of: view)
                })
            }
        }
        self.viewNode?.addNode(observer: self.nodeObserver)
    }
    
    private func observeValue(_ change: NSKeyValueObservedChange<CGRect>, of object: Any?) {
        let newRect: CGRect = change.newValue ?? CGRect.zero
        let oldRect: CGRect = change.oldValue ?? CGRect.zero
        if (newRect.equalTo(oldRect)) {
            return
        }
        if let _ = (object as? UIView)?.layer.mask {
            self.needRemake = true
        }
    }
    
    func updateCornersRadius(_ multiRadius: ArgoKitCornerRadius) -> Void {
        self.multiRadius = multiRadius
    }
    
    func circle() {
        pcircle = true
    }
    
    func remakeIfNeed() {
        if multiRadius == nil && pcircle == nil {
            return
        }
        needRemake = false
        remake()
    }
    
    func remake() {
        needRemake = false
        if let view = self.viewNode?.view {
            let bounds: CGRect = view.bounds
            if bounds.equalTo(CGRect.zero) {
                return
            }
            if pcircle == true {
                let cornerRadius = CGFloat.minimum(bounds.size.width, bounds.size.height) / 2.0
                self.multiRadius = ArgoKitCornerRadius(topLeft: cornerRadius, topRight: cornerRadius, bottomLeft: cornerRadius, bottomRight: cornerRadius)
            }
            guard let multiRadius = self.multiRadius else {
                return
            }
            if view.isKind(of: UIScrollView.self) {
                view.layer.cornerRadius = multiRadius.topLeft
                return
            }
            let key = "\(bounds.width)" + "\(bounds.height)" + "\(multiRadius)"
            var maskPath: UIBezierPath
            if let path = bezierPathCache[key] {
                maskPath = path
            } else {
                maskPath = ArgoKitCornerManagerTool.bezierPath(frame: bounds, multiRadius: multiRadius)
                bezierPathCache[key] = maskPath
            }
            var maskLayer: CAShapeLayer? = nil
            if let mask = view.layer.mask {
                maskLayer = mask as? CAShapeLayer
            } else {
                maskLayer = CAShapeLayer()
            }
            maskLayer?.frame = bounds
            maskLayer?.path = maskPath.cgPath
            view.layer.mask = maskLayer
        }
    }
}
