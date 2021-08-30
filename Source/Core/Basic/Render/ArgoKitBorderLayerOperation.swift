//
//  ArgoKitBorderLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation

class ArgoKitBorderLayerOperation: NSObject, ArgoKitViewReaderOperation {
    var bezierPathCache: [String: UIBezierPath] = [:]
    weak var viewNode: ArgoKitNode?
    private var borderLayer: CAShapeLayer?
    private var _needRemake: Bool = false
    var needRemake: Bool {
        get {
            _needRemake
        }
        set {
            _needRemake = newValue
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            needRemake = true
        }
    }
    
    var borderColor: UIColor = UIColor.black {
        didSet {
            needRemake = true
        }
    }
    
    private var pcircle: Bool = false
    func circle() {
        pcircle = true
        needRemake = true
    }
    
    private var multiRadius: ArgoKitCornerRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
    func updateCornersRadius(_ multiRadius: ArgoKitCornerRadius) -> Void {
        self.multiRadius = multiRadius
        needRemake = true
    }
    
    private var _nodeObserver: ArgoKitNodeObserver = ArgoKitNodeObserver()
    var nodeObserver: ArgoKitNodeObserver {
        get {
            _nodeObserver
        }
    }
    
    private var observation: NSKeyValueObservation?
    required init(viewNode: ArgoKitNode?) {
        self.viewNode = viewNode
        super.init()
        
        self.nodeObserver.setCreateViewBlock { [weak self] view in
            if let strongSelf = self {
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation: strongSelf)
                strongSelf.observation = view.observe(\UIView.frame, options: [.new,.old], changeHandler: { (view, change) in
                    strongSelf.observeValue(change, of: view)
                })
            }
        }
        self.viewNode?.addNode(observer: self.nodeObserver)
    }
    
    private func observeValue(_ change: NSKeyValueObservedChange<CGRect>, of object: Any?){
        let newRect: CGRect = change.newValue ?? CGRect.zero
        let oldRect: CGRect = change.oldValue ?? CGRect.zero
        if (newRect.equalTo(oldRect)) {
            return
        }
        if let view = object as? UIView {
            remakeIfNeed(view: view)
        }
    }
    
    func remakeIfNeed() {
        needRemake = false
        cleanBorderLayerIfNeed()
        if borderWidth == 0 {
            return
        }
        remark()
    }
    
    private func remakeIfNeed(view: UIView) {
        self.needRemake = true
    }
    
    private func remark(){
        if let view = self.viewNode?.view {
            if view.isKind(of: UIScrollView.self) {
                view.layer.borderWidth = borderWidth
                view.layer.borderColor = borderColor.cgColor
                return
            }
            let borderLayer = CAShapeLayer()
            let bounds = view.bounds
            let maxBorderWidth = CGFloat.minimum(bounds.size.width, bounds.size.height)
            let borderWidth = (borderWidth < maxBorderWidth) ? borderWidth: maxBorderWidth
            if pcircle {
                self.multiRadius = ArgoKitCornerRadius(topLeft: maxBorderWidth/2.0, topRight: maxBorderWidth/2.0, bottomLeft: maxBorderWidth/2.0, bottomRight: maxBorderWidth/2.0)
            }
            let key = "\(bounds.width)" + "\(bounds.height)" + "\(multiRadius)"
            var borderPath: UIBezierPath
            if let path = bezierPathCache[key] {
                borderPath = path
            } else {
                borderPath = ArgoKitCornerManagerTool.bezierPath(frame: bounds, multiRadius: multiRadius, lineWidth: borderWidth)
                bezierPathCache[key] = borderPath
            }
            
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.fillColor = nil
            borderLayer.path = borderPath.cgPath
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
        if let borderLayer = self.borderLayer {
            borderLayer.removeFromSuperlayer()
            self.borderLayer = nil
        }
    }
    
    func existRoundCorner() -> Bool {
        return multiRadius.topLeft != 0 || multiRadius.topRight != 0 || multiRadius.bottomLeft != 0 || multiRadius.bottomRight != 0
    }
}
