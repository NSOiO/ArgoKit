//
//  ViewModifier.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/9.
//

import Foundation
extension View{
    func isDirty(_ selector:Selector) -> Bool {
        var isDirty_ = false
        if selector == #selector(setter:UILabel.text) {
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
    public func addAttribute(_ selector:Selector, _ patamter:Any? ...) {
        if let node = self.node{
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
            ArgoKitNodeViewModifier.nodeViewAttribute(with:node, attributes: [attribute])
            
            node.nodeAddView(attribute:attribute)
        }
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
   
    public func clipsToBounds(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.clipsToBounds),value)
        return self;
    }
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
    public func cornerRadius(_ value:CGFloat)->Self{
        addAttribute(#selector(setter:CALayer.cornerRadius),value)
        return self;
    }
    public func borderColor(_ value:CGColor)->Self{
        addAttribute(#selector(setter:CALayer.borderColor),value)
        return self;
    }
    
    
}
