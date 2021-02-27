//
//  ArgoKitGradientLayerOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitGradientLayerOperation:NSObject, ArgoKitViewReaderOperation {
    weak var viewNode:ArgoKitNode?
    private var gradientLayer:CAGradientLayer?
    private var _needRemake:Bool = false
    
    var needRemake: Bool{
        get{
            _needRemake
        }
        set{
            _needRemake = newValue
        }
    }
    public var startColor:UIColor?
    public var endColor:UIColor?
    public var direction:ArgoKitGradientType?
    private var observation:NSKeyValueObservation?
    public func updateGradientLayer(startColor: UIColor?,endColor:UIColor?,direction:ArgoKitGradientType?) {
        self.startColor = startColor
        self.endColor = endColor
        self.direction = direction
        self.needRemake = true
    }
    
    private var _nodeObserver:ArgoKitNodeObserver = ArgoKitNodeObserver()
    var nodeObserver: ArgoKitNodeObserver{
        get{
            _nodeObserver
        }
    }
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
        remakeIfNeed()
    }
    
    func remakeIfNeed() {
        if let view = self.viewNode?.view {
            if self.needRemake {
                remark()
                return;
            }
            
            let frame = view.bounds
            if !frame.equalTo(self.gradientLayer?.frame ?? CGRect.zero) {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.gradientLayer?.frame = frame
                CATransaction.commit()
            }
            
            let layer:CALayer = view.layer
            let cornerRadius:CGFloat = layer.cornerRadius
            if self.gradientLayer?.cornerRadius != cornerRadius {
                UIView.performWithoutAnimation {
                    self.gradientLayer?.cornerRadius = cornerRadius;
                }
            }
            if let  gradientLayer = self.gradientLayer{
                if layer.sublayers?.last !=  gradientLayer{
                    UIView.performWithoutAnimation {
                        layer.insertSublayer(gradientLayer, at: 0)
                    }
                }
            }
        }
        
    }
    
    
    private func remark(){
        cleanGradientLayerIfNeed()
        let gradientLayer = CAGradientLayer()
        self.gradientLayer = gradientLayer
        if let startColor = startColor,let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
            gradientLayer.locations = [NSNumber(floatLiteral: 0.0),NSNumber(floatLiteral: 1.0)]
            if let direction = self.direction {
                switch direction {
                case .RightToLeft:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                case .TopToBottom:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                case .BottomToTop:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
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
                view.backgroundColor = UIColor.clear
            }
            
        }
    }
    
    func cleanGradientLayerIfNeed (){
        self.needRemake = false;
        if self.gradientLayer != nil{
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil;
        }
    }
    
    deinit {
    }
    
}
