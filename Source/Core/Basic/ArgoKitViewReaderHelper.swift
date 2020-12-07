//
//  ArgoKitViewReaderHelper.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation


protocol ArgoKitViewReaderOperation:AnyObject{
    var needRemake:Bool{get set}
    var nodeObserver:ArgoKitNodeObserver{get}
    init(viewNode:ArgoKitNode)
    func remakeIfNeed() -> Void
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void
}
extension ArgoKitViewReaderOperation{
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{}
}

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
   
    var shadowColor:UIColor?
    var shadowOffset:CGSize
    var shadowRadius:CGFloat
    var shadowOpacity:Float
    var multiRadius:ArgoKitCornerRadius
    var corners:UIRectCorner = .allCorners
    var shadowPath:UIBezierPath? = nil
    weak var viewNode:ArgoKitNode?
    
    required init(viewNode:ArgoKitNode){
        self.multiRadius = ArgoKitCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        self.shadowColor = nil
        self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowRadius = 0
        self.shadowOpacity = 0
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
        if let shadowRadius = self.viewNode?.view?.layer.shadowRadius {
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
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.corners = corners
        let multiRadius = ArgoKitCornerManagerTool.multiRadius(multiRadius: self.multiRadius, corner: corners, cornerRadius: shadowRadius)
        self.multiRadius = multiRadius
        self.needRemake = true
    }
    
    
    func updateShadowColor(_ value: UIColor?) -> Void {
        self.shadowColor = value
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
                view.layer.shadowColor = shadowColor?.cgColor
                view.layer.shadowOffset = shadowOffset
                view.layer.shadowRadius = shadowRadius
                if shadowRadius <= 0 {
                    view.layer.shadowOpacity = 0.0
                }else{
                    view.layer.shadowOpacity = shadowOpacity;
                }
                view.layer.shadowPath = shadowPath?.cgPath
            }else{
                ArgoKitNodeViewModifier.addAttribute(isCALayer: true,node,#selector(setter:CALayer.shadowColor),shadowColor?.cgColor)
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
        if let view = self.viewNode?.view{
            view.removeObserver(self, forKeyPath: "frame")
        }
    }
}


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
//                self.needRemake = true
                self.remakeIfNeed()
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
        if self.needRemake {
            self.remake()
        }else{
            if let view = self.viewNode?.view {
                let frame = view.bounds
                view.layer.mask?.frame = frame
            }
        }
        
    }
    func remake(){
        if let view = self.viewNode?.view {
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
    }
    deinit {
        if let view = self.viewNode?.view{
            view.removeObserver(self, forKeyPath: "frame")
        }
    }
}


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
                strongSelf.needRemake = true
                view.addObserver(strongSelf, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
        self.viewNode?.addNode(observer:self.nodeObserver)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
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
    
    
}



class ArgoKitViewReaderHelper{
    static var shared: ArgoKitViewReaderHelper = {
        let instance = ArgoKitViewReaderHelper()
        instance.startRunloop()
        return instance
    }()
    private init() {}
    
    var observe:CFRunLoopObserver?
    var operations:NSHashTable = NSHashTable<AnyObject>.weakObjects()
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
    
    func addRenderOperation(operation:ArgoKitViewReaderOperation?) -> Void{
        if let op = operation {
            if !operations.contains(op) {
                operations.add(op)
            }
        }
    }
    
    func removeAllOperation() -> Void {
        operations.removeAllObjects()
    }
    
    func runOperation(){
        if self.operations.count == 0 {
            return
        }
        let operations = self.operations.copy() as! NSHashTable<AnyObject>
        for operation in operations.allObjects {
            let innerOperation = operation as! ArgoKitViewReaderOperation
            if innerOperation.needRemake {
                innerOperation.remakeIfNeed()
            }
        }
    }

    deinit {
        stopRunloop() 
    }
}
