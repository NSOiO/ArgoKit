//
//  ArgoKitGradientLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation

class ArgoKitGradientLayerOperation: NSObject, ArgoKitViewReaderOperation {
    weak var viewNode: ArgoKitNode?
    private var gradientLayer: CAGradientLayer?
    private var _needRemake: Bool = false
    
    var needRemake: Bool{
        get {
            _needRemake
        }
        set {
            _needRemake = newValue
        }
    }
    public var startColor: UIColor?
    public var endColor: UIColor?
    public var direction: ArgoKitGradientType?
    
    public func updateGradientLayer(startColor: UIColor?, endColor: UIColor?, direction: ArgoKitGradientType?) {
        self.startColor = startColor
        self.endColor = endColor
        self.direction = direction
        self.needRemake = true
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
            if let strongSelf = self{
                strongSelf.remakeIfNeed()
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation: strongSelf)
                strongSelf.observation = view.observe(\UIView.frame, options: [.new,.old], changeHandler: { (view, change) in
                    strongSelf.observeValue(change, of: view)
                })
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    private func observeValue(_ change: NSKeyValueObservedChange<CGRect>, of object: Any?) {
        let newRect:CGRect = change.newValue ?? CGRect.zero
        let oldRect:CGRect = change.oldValue ?? CGRect.zero
        if (newRect.equalTo(oldRect)) {
            return
        }
        remakeIfNeed()
    }
    
    func remakeIfNeed() {
        guard let view = self.viewNode?.view else { return }
        if needRemake {
            remark()
            return
        }
        
        if let gradientLayer = self.gradientLayer {
            if !view.bounds.equalTo(gradientLayer.frame) {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                gradientLayer.frame = view.bounds
                CATransaction.commit()
            }
            
            let cornerRadius:CGFloat = view.layer.cornerRadius
            if gradientLayer.cornerRadius != cornerRadius {
                UIView.performWithoutAnimation {
                    gradientLayer.cornerRadius = cornerRadius;
                }
            }
            if view.layer.sublayers?.last !=  gradientLayer{
                UIView.performWithoutAnimation {
                    view.layer.insertSublayer(gradientLayer, at: 0)
                }
            }
        }
    }
    
    private func remark() {
        needRemake = false
        cleanGradientLayerIfNeed()
        let gradientLayer = CAGradientLayer()
        self.gradientLayer = gradientLayer
        if let startColor = startColor,
           let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            gradientLayer.locations = [NSNumber(floatLiteral: 0.0),NSNumber(floatLiteral: 1.0)]
            if let direction = self.direction {
                switch direction {
                case .LeftToRight:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                    break
                case .RightToLeft:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                    break
                case .TopToBottom:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                    break
                case .BottomToTop:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                    break
                default:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                }
            }
            if let view = self.viewNode?.view {
                let layer = view.layer
                layer.insertSublayer(gradientLayer, at: 0)
                gradientLayer.frame = view.bounds
                gradientLayer.cornerRadius = layer.cornerRadius
            }
        }
    }
    
    func cleanGradientLayerIfNeed (){
        if let gradientLayer = self.gradientLayer {
            gradientLayer.removeFromSuperlayer()
            self.gradientLayer = nil;
        }
    }
    
}
