//
//  ArgoKitBorderLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitBorderLayerOperation:NSObject, ArgoKitViewReaderOperation {
    var borderLayerCache:[String:CAShapeLayer] = [:]
    weak var viewNode:ArgoKitNode?
    private var borderLayer:CAShapeLayer?
    private var _needRemake:Bool = false
    var needRemake: Bool{
        get{
            _needRemake
        }
        set{
            _needRemake = newValue
        }
    }
    
    var borderWidth:CGFloat = 0{
        didSet{
            needRemake = true
        }
    }
    var borderColor:UIColor = UIColor.black{
        didSet{
            needRemake = true
        }
    }
    
    private var pcircle:Bool = false
    func circle() {
        pcircle = true
        needRemake = true
    }
    
    private var multiRadius:ArgoKitCornerRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0);
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{
        self.multiRadius = multiRadius
        needRemake = true
    }
    
    private var _nodeObserver:ArgoKitNodeObserver = ArgoKitNodeObserver()
    var nodeObserver: ArgoKitNodeObserver{
        get{
            _nodeObserver
        }
    }
    private var observation:NSKeyValueObservation?
    required init(viewNode: ArgoKitNode) {
        self.viewNode = viewNode
        super.init()
        self.nodeObserver.setCreateViewBlock {[weak self] view in
            if let strongSelf = self{
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:self)
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
        if let view = object as? UIView {
            remakeIfNeed(view: view)
        }
    }
    
    func remakeIfNeed() {
        self.cleanBorderLayerIfNeed()
        if self.borderWidth == 0 {
            return
        }
        remark()
    }
    
    private func remakeIfNeed(view:UIView) {
        let layer = view.layer
        let cornerRadius = layer.cornerRadius;
        if let borderLayer = self.borderLayer {
            if borderLayer.cornerRadius !=  cornerRadius{
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                borderLayer.cornerRadius = cornerRadius
                CATransaction.commit()
            }
            if layer.sublayers?.last != borderLayer {
                layer.insertSublayer(borderLayer, at: 0)
            }
        }
        else{
            self.needRemake = true
        }
    }
    
    
    private func remark(){
        if let view = self.viewNode?.view {
            let borderLayer = CAShapeLayer()
            let bounds = view.bounds
            let maxBorderWidth = CGFloat.minimum(bounds.size.width, bounds.size.height)
            let borderWidth = (self.borderWidth < maxBorderWidth) ? self.borderWidth:maxBorderWidth
            if pcircle {
                self.multiRadius = ArgoKitCornerRadius(topLeft: maxBorderWidth/2.0, topRight: maxBorderWidth/2.0, bottomLeft: maxBorderWidth/2.0, bottomRight: maxBorderWidth/2.0)
            }
            borderLayer.strokeColor = self.borderColor.cgColor
            borderLayer.fillColor = nil
            borderLayer.path = ArgoKitCornerManagerTool.bezierPath(frame: bounds, multiRadius: self.multiRadius, lineWidth: borderWidth).cgPath
            borderLayer.frame = bounds
            borderLayer.lineWidth = borderWidth
            if self.existRoundCorner() {
                borderLayer.lineCap = CAShapeLayerLineCap.square
            }else{
                borderLayer.lineCap = CAShapeLayerLineCap.round
            }
            borderLayer.masksToBounds = true
            borderLayer.allowsGroupOpacity = false
            self.borderLayer = borderLayer
            view.layer.addSublayer(borderLayer)
        }
    }
    
    
    func cleanBorderLayerIfNeed (){
        self.needRemake = false
        if let borderLayer = self.borderLayer {
            borderLayer.removeFromSuperlayer()
            self.borderLayer = nil
        }
    }
    
    func existRoundCorner() -> Bool {
        return self.multiRadius.topLeft != 0 || self.multiRadius.topRight != 0 || self.multiRadius.bottomLeft != 0 || self.multiRadius.bottomRight != 0
    }
    
    deinit {
    }
    
}
