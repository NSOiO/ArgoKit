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
    
    required init(viewNode:ArgoKitNode){
        self.viewNode = viewNode
        super.init()
        
        self.nodeObserver.setCreateViewBlock {[weak self] view in
            if let strongSelf = self{
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:strongSelf)
                view.addObserver(strongSelf, forKeyPath: "frame", options: [.new,.old], context: nil)
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        let newrect:CGRect = change?[NSKeyValueChangeKey.newKey] as! CGRect
        let oldrect:CGRect = change?[NSKeyValueChangeKey.oldKey] as! CGRect
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
        if let view = self.viewNode?.view{
            view.removeObserver(self, forKeyPath: "frame")
        }
    }
}
