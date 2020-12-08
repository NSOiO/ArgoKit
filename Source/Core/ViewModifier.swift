//
//  ViewModifier.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/9.
//

import Foundation
extension ArgoKitNodeViewModifier{
    class func getIsDirty(_ selector:Selector) -> Bool {
        var isDirty_ = false
        if selector == #selector(setter:UILabel.text) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UILabel.isHidden) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UILabel.attributedText) {
            isDirty_ = true
        }
        if selector == #selector(setter:UILabel.numberOfLines) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UILabel.font) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UIImageView.image) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UIImageView.highlightedImage) {
            isDirty_ = true
        }
        
        return isDirty_;
    }
    public class func addAttribute(isCALayer:Bool = false,isDirty:Bool = false,_ outNode:ArgoKitNode?, _ selector:Selector, _ patamter:Any? ...) {
        ArgoKitNodeViewModifier._addAttribute_(isCALayer:isCALayer,outNode, selector, patamter)
    }
    public class func _addAttribute_(isCALayer:Bool = false,isDirty:Bool = false, _ outNode:ArgoKitNode?,_ selector:Selector, _ patamter:[Any?]) {
        if let node = outNode{
            // 获取参数
            var paraList:Array<Any> = Array()
            for item in patamter {
                if let innerItem =  item{
                    paraList.append(innerItem)
                }
            }
            if patamter.count !=  paraList.count{
                return
            }
            
            let attribute = ViewAttribute(selector:selector,paramter:paraList)
            attribute.isDirty = getIsDirty(selector)
            if isDirty {
                attribute.isDirty = isDirty
            }
            attribute.isCALayer = isCALayer
            
            self.setNodeAttribute(node, attribute)
            node.nodeAddView(attribute:attribute)
            
        }
    }
    
    class func setNodeAttribute(_ node:ArgoKitNode?,_ attribute:ViewAttribute){
        if let linkNode = node?.link {
             self.nodeViewAttribute(with:linkNode, attributes: [attribute], markDirty: false)
         }else{
             self.nodeViewAttribute(with:node, attributes: [attribute], markDirty: true)
         }
        if attribute.isDirty == true {
            node?.markDirty()
        }
    }
}

extension View{
    
    public func addAttribute(isCALayer:Bool = false,isDirty:Bool = false, _ selector:Selector, _ patamter:Any? ...) {
        ArgoKitNodeViewModifier._addAttribute_(isCALayer: isCALayer, self.node, selector, patamter)
    }
}

// modifier
extension View {
    public func isUserInteractionEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.isUserInteractionEnabled),value)
        return self
    }

    public func tag(_ value:Int)->Self{
        addAttribute(#selector(setter:UIView.tag),value)
        return self
    }
    public func tag()->Int?{
        return self.node?.view?.tag
    }
    public func layer()-> CALayer? {
        return self.node?.view?.layer
    }

    @available(iOS 9.0, *)
    public func canBecomeFocused()-> Bool? {
        return self.node?.view?.canBecomeFocused
    }

    @available(iOS 9.0, *)
    public func isFocused()-> Bool? {
        return self.node?.view?.isFocused
    }

    /// The identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    @available(iOS 14.0, *)
    public func focusGroupIdentifier(_ value:String?)->Self{
        addAttribute(#selector(setter:UIView.focusGroupIdentifier),value)
        return self
    }
    
    @available(iOS 14.0, *)
    public func focusGroupIdentifier()-> String? {
        return self.node?.view?.focusGroupIdentifier
    }

    @available(iOS 9.0, *)
    public func semanticContentAttribute(_ value:UISemanticContentAttribute)->Self{
        addAttribute(#selector(setter:UIView.semanticContentAttribute),value)
        return self
    }
    public func semanticContentAttribute()->UISemanticContentAttribute?{
        return self.node?.view?.semanticContentAttribute
    }
    @available(iOS 10.0, *)
    public func effectiveUserInterfaceLayoutDirection()-> UIUserInterfaceLayoutDirection? {
        return self.node?.view?.effectiveUserInterfaceLayoutDirection
    }
}

extension View{
   
    public func backgroundColor(_ value:UIColor)->Self{
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    public func backgroundColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    public func backgroundColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    public func alpha(_ value:CGFloat)->Self{
        addAttribute(#selector(setter:UIView.alpha),value)
        return self;
    }
    public func opaque(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.isOpaque),value)
        return self;
    }
    public func clearsContextBeforeDrawing(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.clearsContextBeforeDrawing),value)
        return self;
    }
    public func hidden(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.isHidden),value)
        return self;
    }
    
    public func display(_ value:Bool)->Self{
        let display_ = !value
        addAttribute(#selector(setter:UIView.isHidden),display_)
        if let enable = self.node?.isEnabled {
            if !enable && !display_ {
                if let node =  self.node?.root{
                    self.node?.isEnabled = !display_
                    ArgoKitReusedLayoutHelper.appLayout(node)
                }
            }else{
                self.node?.isEnabled = !display_
            }
        }else{
            self.node?.isEnabled = !display_
        }
      
        return self;
    }
    
    public func contentMode(_ value:UIView.ContentMode)->Self{
        addAttribute(#selector(setter:UIView.contentMode),value.rawValue)
        return self;
    }
    public func tintColor(_ value:UIColor)->Self{
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    public func tintColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    public func tintColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    public func tintAdjustmentMode(_ value:UIView.TintAdjustmentMode)->Self{
        addAttribute(#selector(setter:UIView.tintAdjustmentMode),value.rawValue)
        return self;
    }
    
    public func clipsToBounds(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.clipsToBounds),value)
        return self;
    }
    
    public func cornerRadius(_ value:CGFloat)->Self{
        return self.cornerRadius(topLeft: value, topRight: value, bottomLeft: value, bottomRight: value);
    }
    
    public func cornerRadius(topLeft:CGFloat,topRight:CGFloat,bottomLeft:CGFloat,bottomRight:CGFloat)->Self{
        if topLeft == topRight &&
            topLeft ==  bottomLeft &&
            topLeft ==  bottomRight{
            _ = self.clipsToBounds(true)
            addAttribute(isCALayer: true,#selector(setter:CALayer.cornerRadius),topLeft)
        }else{
            self.node?.maskLayerOperation?.updateCornersRadius(ArgoKitCornerRadius(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
        }
        let multiRadius = ArgoKitCornerRadius(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        self.node?.borderLayerOperation?.updateCornersRadius(multiRadius)
        return self;
    }
    
    public func borderWidth(_ value:CGFloat)->Self{
//        addAttribute(isCALayer:true,#selector(setter:CALayer.borderWidth),value)
        
        self.node?.borderLayerOperation?.borderWidth = value
        return self;
    }
    
    public func borderColor(_ value:UIColor)->Self{
//        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        
        self.node?.borderLayerOperation?.borderColor = value
        return self;
    }
    
    
    
    public func borderColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        return self;
    }
    
    public func borderColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        return self;
    }
    
    public func circle()->Self{
        _ = self.clipsToBounds(true)
        self.node?.maskLayerOperation?.circle()
        return self;
    }
    
    public func shadowColor(_ value: UIColor?) -> Self {
        self.node?.shadowOperation?.updateShadowColor(value)
        return self
    }
    
    public func shadowColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        self.node?.shadowOperation?.updateShadowColor(value)
        return self;
    }
    
    public func shadowColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        self.node?.shadowOperation?.updateShadowColor(value)
        return self;
    }
    
    public func shadow(offset: CGSize, radius: CGFloat, opacity: Float) -> Self {
        self.node?.shadowOperation?.updateShadow(offset: offset, radius: radius, opacity: opacity)
        return self
    }
    
    public func shadow(shadowColor:UIColor? = .gray, shadowOffset:CGSize,shadowRadius:CGFloat,shadowOpacity:Float,corners:UIRectCorner = .allCorners)->Self{
        self.node?.shadowOperation?.updateCornersRadius(shadowColor: shadowColor, shadowOffset: shadowOffset, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, corners: corners)
        return self;
    }
    
    public func gradientColor(startColor: UIColor?,endColor:UIColor?,direction:ArgoKitGradientType?) -> Self {
        self.node?.gradientLayerOperation?.updateGradientLayer(startColor: startColor, endColor: endColor, direction: direction)
        return self
    }
    
    func cleanGradientLayer() -> Self {
        self.node?.gradientLayerOperation?.cleanGradientLayerIfNeed()
        return self
    }
}
