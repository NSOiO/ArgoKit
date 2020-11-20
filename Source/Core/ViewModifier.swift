//
//  ViewModifier.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/9.
//

import Foundation
extension ArgoKitNodeViewModifier{
    class func isDirty(_ selector:Selector) -> Bool {
        var isDirty_ = false
        if selector == #selector(setter:UILabel.text) {
            isDirty_ = true
        }
        
        if selector == #selector(setter:UIView.isHidden) {
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
    public class func addAttribute(isCALayer:Bool = false,_ outNode:ArgoKitNode?, _ selector:Selector, _ patamter:Any? ...) {
        ArgoKitNodeViewModifier._addAttribute_(isCALayer:isCALayer,outNode, selector, patamter)
    }
    public class func _addAttribute_(isCALayer:Bool = false,_ outNode:ArgoKitNode?,_ selector:Selector, _ patamter:[Any?]) {
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
            attribute.isDirty = isDirty(selector)
            attribute.isCALayer = isCALayer
            self.nodeViewAttribute(with:node, attributes: [attribute])
            
            node.nodeAddView(attribute:attribute)
        }
    }
}

extension View{
   
    public func addAttribute(isCALayer:Bool = false, _ selector:Selector, _ patamter:Any? ...) {
        ArgoKitNodeViewModifier._addAttribute_(self.node, selector, patamter)
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
        if let enable = self.node?.isEnabled {
            self.node?.isEnabled = !value
            if !enable && !value {
                if let node =  self.node?.root{
                    node.applyLayout(size: CGSize(width: node.size.width, height: CGFloat.nan))
                }
            }
        }
        return self;
    }
    public func contentMode(_ value:UIView.ContentMode)->Self{
        addAttribute(#selector(setter:UIView.contentMode),value)
        return self;
    }
    public func tintColor(_ value:UIColor)->Self{
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    public func tintAdjustmentMode(_ value:UIView.TintAdjustmentMode)->Self{
        addAttribute(#selector(setter:UIView.tintAdjustmentMode),value)
        return self;
    }
    
    public func clipsToBounds(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.clipsToBounds),value)
        return self;
    }
    
    public func cornerRadius(_ value:CGFloat)->Self{
        addAttribute(isCALayer: true,#selector(setter:CALayer.cornerRadius),value)
        return self;
    }
    
    public func cornerRadius(topLeft:CGFloat,topRight:CGFloat,bottomLeft:CGFloat,bottomRight:CGFloat)->Self{
        if topLeft == topRight &&
            topLeft ==  bottomLeft &&
            topLeft ==  bottomRight{
            addAttribute(isCALayer: true,#selector(setter:CALayer.cornerRadius),topLeft)
        }else{
            self.node?.maskLayerOperation?.updateCornersRadius(ArgoKitCornerRadius(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
        }
        return self;
    }
    
    public func cornerRadius(_ value:CGFloat,corners:UIRectCorner)->Self{
        if corners.contains(.allCorners) {
            addAttribute(isCALayer: true,#selector(setter:CALayer.cornerRadius),value)
        }else{
            self.node?.maskLayerOperation?.updateCornersRadius( radius: value,corners: corners)
        }
        return self;
    }
    
    public func borderColor(_ value:UIColor)->Self{
        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        return self;
    }
    
    public func shadow(shadowColor:UIColor, shadowOffset:CGSize,shadowRadius:CGFloat,shadowOpacity:CGFloat,corners:UIRectCorner = .allCorners)->Self{
        self.node?.shadowOperation?.updateCornersRadius(shadowColor: shadowColor, shadowOffset: shadowOffset, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity, corners: corners)
        return self;
    }
}

private struct AssociatedNodeRenderKey {
       static var shadowKey:Void?
       static var maskLayerKey:Void?
}
extension ArgoKitNode{
    var shadowOperation: ArgoKitViewShadowOperation? {
           get {
               if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey) as? ArgoKitViewShadowOperation {
                   return rs
               }else{
                    let rs = ArgoKitViewShadowOperation(viewNode: self)
                    objc_setAssociatedObject(self, &AssociatedNodeRenderKey.shadowKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    ArgoKitViewReaderHelper.shared.addRenderOperation(operation:rs)
                    return rs
               }
           }
       }
    
    var maskLayerOperation: ArgoKitViewLayerOperation? {
        get {
            if let rs = objc_getAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey) as? ArgoKitViewLayerOperation {
                return rs
            }else{
                 let rs = ArgoKitViewLayerOperation(viewNode: self)
                objc_setAssociatedObject(self, &AssociatedNodeRenderKey.maskLayerKey,rs, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                ArgoKitViewReaderHelper.shared.addRenderOperation(operation:rs)
                 return rs
            }
        }
    }
}
