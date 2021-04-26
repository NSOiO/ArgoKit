//
//  ArgoKitMaskLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitMaskLayerOperation:NSObject, ArgoKitViewReaderOperation {
    var bezierPathCache:[String:UIBezierPath] = [:]
    private var _needRemake:Bool = false
    var needRemake: Bool{
        get{
            _needRemake
        }
        set{
            _needRemake = newValue
        }
    }
    private var _nodeObserver:ArgoKitNodeObserver = ArgoKitNodeObserver()
    var nodeObserver: ArgoKitNodeObserver{
        get{
            _nodeObserver
        }
    }
    var radius:CGFloat = 0
    var corners:UIRectCorner = .allCorners
    var multiRadius:ArgoKitCornerRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
    var shadowPath:UIBezierPath? = nil
    private var pcircle:Bool? = false
    weak var viewNode:ArgoKitNode?
    private var observation:NSKeyValueObservation?
    required init(viewNode:ArgoKitNode){
        self.viewNode = viewNode
        super.init()
        
        self.nodeObserver.setCreateViewBlock {[weak self] view in
            if let strongSelf = self{
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:strongSelf)
                strongSelf.observation = view.observe(\UIView.frame, options: [.new,.old], changeHandler: { (view, change) in
                    strongSelf.observeValue(change, of: view)
                })
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    private func observeValue(_ change:NSKeyValueObservedChange<CGRect>,of object: Any?){
        let newrect:CGRect = change.newValue ?? CGRect.zero
        let oldrect:CGRect = change.oldValue ?? CGRect.zero
        if (newrect.equalTo(oldrect)) {
            return
        }
        if let _ = (object as? UIView)?.layer.mask {
            self.needRemake = true
        }
    }
    
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{
        self.multiRadius = multiRadius
    }
    
    func circle() {
        pcircle = true
    }
    
    
    func remakeIfNeed() {
        self.needRemake = false
        remake()
    }
    
    func remake() {
        self.needRemake = false
        if let view = self.viewNode?.view {
            let bounds:CGRect = view.bounds
            if bounds.equalTo(CGRect.zero) {
                return
            }
            if pcircle == true{
                let cornerRadius = CGFloat.minimum(bounds.size.width, bounds.size.height)/2.0
                self.multiRadius = ArgoKitCornerRadius(topLeft: cornerRadius, topRight: cornerRadius, bottomLeft: cornerRadius, bottomRight: cornerRadius)
            }
            let key = "\(bounds.width)"+"\(bounds.height)"+"\(self.multiRadius)"
            var maskPath:UIBezierPath
            if let path = bezierPathCache[key]{
                maskPath = path
            }else{
                maskPath = ArgoKitCornerManagerTool.bezierPath(frame: bounds, multiRadius: self.multiRadius)
                bezierPathCache[key] = maskPath
            }
            var maskLayer:CAShapeLayer? = nil
            if let mask = view.layer.mask {
                maskLayer = mask as? CAShapeLayer
            }else{
                maskLayer = CAShapeLayer()
            }
            maskLayer?.frame = bounds
            maskLayer?.path = maskPath.cgPath
            view.layer.mask = maskLayer
           
        }
    }
    
    deinit {
    }
}
