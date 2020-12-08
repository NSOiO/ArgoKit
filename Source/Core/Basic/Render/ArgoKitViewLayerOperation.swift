//
//  ArgoKitViewLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitViewLayerOperation:NSObject, ArgoKitViewReaderOperation {
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
    var radius:CGFloat
    var corners:UIRectCorner
    var multiRadius:ArgoKitCornerRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
    var shadowPath:UIBezierPath? = nil
    private var pcircle:Bool? = false
    weak var viewNode:ArgoKitNode?
    
    required init(viewNode:ArgoKitNode){
        self.multiRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        self.radius = 0
        self.corners = .allCorners
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
    
    func updateCornersRadius(radius:CGFloat,corners:UIRectCorner)->Void{
        self.corners = corners
        self.radius = radius
        let multiRadius = ArgoKitCornerManagerTool.multiRadius(multiRadius: self.multiRadius, corner: corners, cornerRadius: radius)
        self.multiRadius = multiRadius
        self.needRemake = true
    }
    
    func remakeIfNeed() {
        self.needRemake = false
        if let node = self.viewNode {
            var frame:CGRect = node.frame
            if let view = node.view{
                frame = view.frame
            }
            if frame.equalTo(CGRect.zero) {
                return
            }
            if pcircle == true{
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.cornerRadius),CGFloat.minimum(frame.size.width, frame.size.height)/2.0)
                return;
            }
            let maskPath = ArgoKitCornerManagerTool.bezierPath(frame: frame, multiRadius: self.multiRadius)
            var maskLayer:CAShapeLayer? = nil
            if let mask =  node.view?.layer.mask {
                maskLayer = mask as? CAShapeLayer
            }else{
                maskLayer = CAShapeLayer()
            }
            maskLayer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            maskLayer?.path = maskPath.cgPath
            if let view = node.view {
                view.layer.mask = maskLayer
            }else{
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.mask),maskLayer)
            }
        }
    }
    
    deinit {
        if let view = self.viewNode?.view{
            view.removeObserver(self, forKeyPath: "frame")
        }
    }
}
