//
//  ArgoKitMaskLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitMaskLayerOperation:NSObject, ArgoKitViewReaderOperation {
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
    var multiRadius:ArgoKitCornerRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0){
        didSet{
            self.needRemake = true
        }
    }
    var shadowPath:UIBezierPath? = nil
    private var pcircle:Bool? = false
    weak var viewNode:ArgoKitNode?
    
    required init(viewNode:ArgoKitNode){
        self.viewNode = viewNode
        super.init()
        
        self.nodeObserver.setCreateViewBlock {[weak self] view in
            if let strongSelf = self{
                strongSelf.needRemake = true
                view.addObserver(strongSelf, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        let rect:CGRect = change?[NSKeyValueChangeKey.newKey] as! CGRect
        if let mask = self.viewNode?.view?.layer.mask {
            if !(mask.frame.equalTo(rect)) {
                self.needRemake = true
            }
        }
    }
    
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{
        self.multiRadius = multiRadius
        self.needRemake = true
    }
    
    func circle() {
        pcircle = true
        self.needRemake = true
    }
    
    
    func remakeIfNeed() {
        self.needRemake = false
        remake()
//        if let node = self.viewNode {
//            var frame:CGRect = node.frame
//            if let view = node.view{
//                frame = view.frame
//            }
//            if frame.equalTo(CGRect.zero) {
//                return
//            }
//            if pcircle == true{
//                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.cornerRadius),CGFloat.minimum(frame.size.width, frame.size.height)/2.0)
//                return;
//            }
//            let maskPath = ArgoKitCornerManagerTool.bezierPath(frame: frame, multiRadius: self.multiRadius)
//            var maskLayer:CAShapeLayer? = nil
//            if let mask =  node.view?.layer.mask {
//                maskLayer = mask as? CAShapeLayer
//            }else{
//                maskLayer = CAShapeLayer()
//            }
//            maskLayer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//            maskLayer?.path = maskPath.cgPath
//            if let view = node.view {
//                view.layer.mask = maskLayer
//            }else{
//                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.mask),maskLayer)
//            }
//        }
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
            let maskPath = ArgoKitCornerManagerTool.bezierPath(frame: bounds, multiRadius: self.multiRadius)
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
