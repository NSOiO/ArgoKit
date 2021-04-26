//
//  ArgoKitBlurEffectOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
class ArgoKitBlurEffectOperation: NSObject,ArgoKitViewReaderOperation {
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
    
    public var style:UIBlurEffect.Style = UIBlurEffect.Style.extraLight
    
    private var blurEffect:Bool = false
    private var vibrancyEffect:Bool = false
    private var alpha:CGFloat? = 1.0
    private var color:UIColor?
    var effectView:UIVisualEffectView?
    
    func addBlurEffect(style:UIBlurEffect.Style,alpha:CGFloat? = 1.0,color:UIColor?){
        self.style = style
        self.alpha = alpha
        self.color = color
        self.blurEffect = true
        self.needRemake = true
    }
    
    func removeBlurEffect(){
        self.effectView?.removeFromSuperview()
        self.effectView = nil
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
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    func remakeIfNeed() {
        if self.blurEffect {
            if let view = self.viewNode?.view {
                if self.effectView == nil{
                    let blurEffect:UIBlurEffect = UIBlurEffect(style: self.style)
                    let effectView = UIVisualEffectView(effect: blurEffect)
                    effectView.frame = view.bounds
                    if let color = self.color {
                        effectView.backgroundColor = color
                    }
                    if let alpha = self.alpha {
                        effectView.alpha = alpha
                    }
                    self.effectView = effectView
                    view.addSubview(effectView)
                }
            }
            
        }
    }

}
