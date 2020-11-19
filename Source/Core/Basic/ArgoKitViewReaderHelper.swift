//
//  ArgoKitViewReaderHelper.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation


protocol ArgoKitViewReaderOperation{
    var needRemake:Bool{get set}
    func remakeIfNeed() -> Void
}

class ArgoKitViewShadowOperation: ArgoKitViewReaderOperation {
    private var _needRemake:Bool = false
    var needRemake: Bool{
        get{
            _needRemake
        }
        set{
            _needRemake = newValue
        }
    }
   
    var shadowColor:UIColor?
    var shadowOffset:CGSize
    var shadowRadius:CGFloat
    var shadowOpacity:Float
    var multiRadius:ArgoKitCornerRadius
    var shadowPath:UIBezierPath? = nil
    
    weak var viewNode:ArgoKitNode?
    public init(shadowColor:UIColor?, shadowOffset:CGSize,shadowRadius:CGFloat,shadowOpacity:CGFloat,viewNode:ArgoKitNode?){
        self.multiRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowOpacity = Float(shadowOpacity)
        self.viewNode = viewNode
    }
    
    func remakeIfNeed() {
        if let node = self.viewNode {
            if let view = node.view {
                view.layer.shadowColor = shadowColor?.cgColor
                view.layer.shadowOffset = shadowOffset
                view.layer.shadowRadius = shadowRadius
                if shadowRadius <= 0 {
                    view.layer.shadowOpacity = 0.0
                }else{
                    view.layer.shadowOpacity = shadowOpacity;
                }
                shadowPath = ArgoKitCornerManagerTool.bezierPath(frame: node.frame, multiRadius: multiRadius)
                view.layer.shadowPath = shadowPath?.cgPath
            }else{
                ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowColor),shadowColor?.cgColor)
                ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowOffset),shadowOffset)
                ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowRadius),shadowRadius)
                if shadowRadius <= 0 {
                    ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowOpacity),0.0)
                }else{
                    ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowOpacity),shadowOpacity)
                }
                shadowPath = ArgoKitCornerManagerTool.bezierPath(frame: node.frame, multiRadius: multiRadius)
                ArgoKitNodeViewModifier.addAttribute(node,#selector(setter:CALayer.shadowPath),shadowPath?.cgPath)
            }
        }else{
            //节点不存在
        }
    }
}


class ArgoKitViewReaderHelper{
    static var shared: ArgoKitViewReaderHelper = {
        let instance = ArgoKitViewReaderHelper()
        instance.startRunloop()
        return instance
    }()
    private init() {}
    
    var observe:CFRunLoopObserver?
    var operations:NSMutableArray = NSMutableArray()
    func startRunloop() -> Void {
        let runloop:CFRunLoop = CFRunLoopGetMain()
        observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeTimers.rawValue | CFRunLoopActivity.exit.rawValue , true, 1, {[weak self] (observer, activity) in
            self?.runOperation()
        })
        if let _ =  observe {
            CFRunLoopAddObserver(runloop, observe, CFRunLoopMode.commonModes)
        }
    }
    
    func stopRunloop() -> Void {
        if let _ =  observe {
            if CFRunLoopContainsObserver(CFRunLoopGetMain(), observe, CFRunLoopMode.commonModes) {
                CFRunLoopRemoveObserver(CFRunLoopGetMain(),observe, CFRunLoopMode.commonModes)
            }
            observe = nil
        }
    }
    
    func addRenderOperation(operation:ArgoKitViewReaderOperation) -> Void{
        if !operations.contains(operation) {
            operations.add(operation)
        }
    }
    
    func removeAllOperation() -> Void {
        operations.removeAllObjects()
    }
    func runOperation(){
        if self.operations.count == 0 {
            return
        }
        let operations:NSArray = self.operations.copy() as! NSArray
        removeAllOperation()
        for operation in operations {
            (operation as! ArgoKitViewReaderOperation).remakeIfNeed()
        }
    }

    deinit {
        stopRunloop() 
    }
}
