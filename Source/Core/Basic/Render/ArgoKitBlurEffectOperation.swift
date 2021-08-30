//
//  ArgoKitBlurEffectOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation

class ArgoKitBlurEffectOperation: NSObject, ArgoKitViewReaderOperation {
    weak var viewNode: ArgoKitNode?
    private var _needRemake: Bool = false
    var needRemake: Bool {
        get {
            _needRemake
        }
        set {
            _needRemake = newValue
        }
    }
    
    public var style: UIBlurEffect.Style = UIBlurEffect.Style.extraLight
    
    private var blurEffect: Bool = false
    private var vibrancyEffect: Bool = false
    private var alpha: CGFloat? = 1.0
    private var color: UIColor?
    var effectView: UIVisualEffectView?
    
    func addBlurEffect(style: UIBlurEffect.Style, alpha:CGFloat? = 1.0, color:UIColor?) {
        self.style = style
        self.alpha = alpha
        self.color = color
        blurEffect = true
        needRemake = true
    }
    
    func removeBlurEffect() {
        if let effectView = self.effectView {
            needRemake = false
            blurEffect = false
            effectView.removeFromSuperview()
            self.effectView = nil
        }
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
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:strongSelf)
                strongSelf.observation = view.observe(\UIView.frame, options: [.new, .old], changeHandler: { (view, change) in
                    strongSelf.observeValue(change, of: view)
                })
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    private func observeValue(_ change: NSKeyValueObservedChange<CGRect>, of object: Any?){
        let newRect: CGRect = change.newValue ?? CGRect.zero
        let oldRect: CGRect = change.oldValue ?? CGRect.zero
        if (newRect.equalTo(oldRect)) {
            return
        }
        if effectView != nil {
            needRemake = true
        }
    }
    
    func remakeIfNeed() {
        needRemake = false
        if blurEffect,
           let view = self.viewNode?.view {
            if let effectView = self.effectView {
                effectView.frame = view.bounds
            } else {
                let blurEffect: UIBlurEffect = UIBlurEffect(style: style)
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
