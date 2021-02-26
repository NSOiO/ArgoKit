//
//  ArgoKitViewShadowOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitViewShadowOperation: NSObject, ArgoKitViewReaderOperation {
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
   
    var shadowColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.215)
    var shadowOffset:CGSize
    var shadowRadius:CGFloat
    var shadowOpacity:Float
    var multiRadius:ArgoKitCornerRadius
    var corners:UIRectCorner = .allCorners
    var shadowPath:UIBezierPath? = nil
    weak var viewNode:ArgoKitNode?
    private var observation:NSKeyValueObservation?
    required init(viewNode:ArgoKitNode){
        self.multiRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowRadius = 0
        self.shadowOpacity = 0
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
        if let shadowRadius = (object as? UIView)?.layer.shadowRadius {
            if shadowRadius > 0 {
                self.needRemake = true
            }
        }
    }
    
    
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{
        self.multiRadius = multiRadius
        self.needRemake = true
    }
    
    func updateCornersRadius(shadowColor:UIColor?, shadowOffset:CGSize,shadowRadius:CGFloat,shadowOpacity:Float,corners:UIRectCorner)->Void{
        self.shadowColor = shadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0.215)
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.corners = corners
        let multiRadius = ArgoKitCornerManagerTool.multiRadius(multiRadius: self.multiRadius, corner: corners, cornerRadius: shadowRadius)
        self.multiRadius = multiRadius
        
        self.needRemake = true
    }
    
    func updateShadowColor(_ value: UIColor?) -> Void {
        self.shadowColor = value ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0.215)

        self.needRemake = true
    }
    
    func updateShadow(offset: CGSize, radius: CGFloat, opacity: Float) -> Void {
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = opacity
        
        self.needRemake = true
    }
    
    func remakeIfNeed() {
        self.needRemake = false
        if let node = self.viewNode {
            var frame:CGRect = node.frame
            if let view = node.view{
                frame = view.frame
            }
            shadowPath = ArgoKitCornerManagerTool.bezierPath(frame:frame, multiRadius: self.multiRadius)
            if let view = node.view {
                view.layer.shadowColor = shadowColor.cgColor
                view.layer.shadowOffset = shadowOffset
                view.layer.shadowRadius = shadowRadius
                if shadowRadius <= 0 {
                    view.layer.shadowOpacity = 0.0
                }else{
                    view.layer.shadowOpacity = shadowOpacity;
                }
                view.layer.shadowPath = shadowPath?.cgPath
            }else{
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowColor),shadowColor.cgColor)
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowOffset),shadowOffset)
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowRadius),shadowRadius)
                if shadowRadius <= 0 {
                    ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowOpacity),0.0)
                }else{
                    ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowOpacity),shadowOpacity)
                }
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowPath),shadowPath?.cgPath)
            }
        }
    }
    deinit {
    }
}
