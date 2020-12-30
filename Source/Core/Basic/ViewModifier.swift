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

extension View {
    
    /// Adds attribute to the UIKit View
    /// - Parameters:
    ///   - isCALayer: trueif is calayer.
    ///   - isDirty: true if the attribute may change the view layout
    ///   - selector: The selector of the attribute.
    ///   - patamter: patamter.
    public func addAttribute(isCALayer: Bool = false, isDirty: Bool = false, _ selector: Selector, _ patamter: Any? ...) {
        ArgoKitNodeViewModifier._addAttribute_(isCALayer: isCALayer, isDirty: isDirty, self.node, selector, patamter)
    }
}

// modifier
extension View {
    
    /// Sets a Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Parameter value: A Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Returns: Self
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIView.isUserInteractionEnabled),value)
        return self
    }
    
    /// Sets an integer that you can use to identify view objects in your application.
    /// - Parameter value: An integer that you can use to identify view objects in your application.
    /// - Returns: Self
    @discardableResult
    public func tag(_ value: Int) -> Self {
        addAttribute(#selector(setter:UIView.tag),value)
        return self
    }
    
    /// Gets an integer that you can use to identify view objects in your application.
    /// - Returns: An integer that you can use to identify view objects in your application.
    public func tag() -> Int? {
        return self.node?.view?.tag
    }
    
    /// Gets the view’s Core Animation layer used for rendering.
    /// - Returns: The view’s Core Animation layer used for rendering.
    public func layer() -> CALayer? {
        return self.node?.view?.layer
    }
    
    /// Gets a Boolean value that indicates whether the view is currently capable of being focused.
    /// - Returns: A Boolean value that indicates whether the view is currently capable of being focused.
    @available(iOS 9.0, *)
    public func canBecomeFocused() -> Bool? {
        return self.node?.view?.canBecomeFocused
    }
    
    /// Gets a Boolean value that indicates whether the item is currently focused.
    /// - Returns: A Boolean value that indicates whether the item is currently focused.
    @available(iOS 9.0, *)
    public func isFocused()-> Bool? {
        return self.node?.view?.isFocused
    }

    /// Sets the identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    /// - Parameter value: The identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    /// - Returns: Self
    @available(iOS 14.0, *)
    @discardableResult
    public func focusGroupIdentifier(_ value: String?) -> Self {
        addAttribute(#selector(setter:UIView.focusGroupIdentifier),value)
        return self
    }
    
    /// Gets the identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    /// - Returns: The identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    @available(iOS 14.0, *)
    @discardableResult
    public func focusGroupIdentifier() -> String? {
        return self.node?.view?.focusGroupIdentifier
    }
    
    /// Sets a semantic description of the view’s contents, used to determine whether the view should be flipped when switching between left-to-right and right-to-left layouts.
    /// - Parameter value: A semantic description of the view’s contents, used to determine whether the view should be flipped when switching between left-to-right and right-to-left layouts.
    /// - Returns: Self
    @available(iOS 9.0, *)
    @discardableResult
    public func semanticContentAttribute(_ value: UISemanticContentAttribute) -> Self {
        addAttribute(#selector(setter:UIView.semanticContentAttribute),value)
        return self
    }
    
    /// Gets a semantic description of the view’s contents, used to determine whether the view should be flipped when switching between left-to-right and right-to-left layouts.
    /// - Returns: A semantic description of the view’s contents, used to determine whether the view should be flipped when switching between left-to-right and right-to-left layouts.
    public func semanticContentAttribute() -> UISemanticContentAttribute? {
        return self.node?.view?.semanticContentAttribute
    }
    
    /// Gets the user interface layout direction appropriate for arranging the immediate content of the view.
    /// - Returns: The user interface layout direction appropriate for arranging the immediate content of the view.
    @available(iOS 10.0, *)
    public func effectiveUserInterfaceLayoutDirection() -> UIUserInterfaceLayoutDirection? {
        return self.node?.view?.effectiveUserInterfaceLayoutDirection
    }
}

extension View{
    
    /// Sets the view’s background color.
    /// - Parameter value: The view’s background color.
    /// - Returns: Self
    @discardableResult
    public func backgroundColor(_ value: UIColor) -> Self {
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    /// Sets the view’s background color.
    /// - Parameters:
    ///   - r: The red value of the color object. 0~255
    ///   - g: The green value of the color object. 0~255
    ///   - b: The blue value of the color object. 0~255
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func backgroundColor(red r: Int, green g: Int, blue b: Int, alpha a: CGFloat = 1) -> Self {
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    /// Sets the view’s background color.
    /// - Parameters:
    ///   - hex: The hex value of the color object
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func backgroundColor(hex: Int, alpha a: Float = 1) -> Self {
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UIView.backgroundColor),value)
        return self;
    }
    
    /// Sets the view’s alpha value.
    /// - Parameter value: The view’s alpha value, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self {
        addAttribute(#selector(setter:UIView.alpha),value)
        return self;
    }
    
    /// Gets a Boolean value that determines whether the view is opaque.
    /// - Parameter value: A Boolean value that determines whether the view is opaque.
    /// - Returns: Self
    @discardableResult
    public func opaque(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIView.isOpaque),value)
        return self;
    }
    
    /// Sets a Boolean value that determines whether the view’s bounds should be automatically cleared before drawing.
    /// - Parameter value: A Boolean value that determines whether the view’s bounds should be automatically cleared before drawing.
    /// - Returns: Self
    @discardableResult
    public func clearsContextBeforeDrawing(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIView.clearsContextBeforeDrawing),value)
        return self;
    }
    
    /// Sets a Boolean value that determines whether the view is hidden.
    /// - Parameter value: A Boolean value that determines whether the view is hidden.
    /// - Returns: Self
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIView.isHidden),value)
        return self;
    }
    
    @available(*, unavailable, renamed: "gone(_:)")
    @discardableResult
    public func display(_ value: Bool) -> Self {
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
    
    /// Sets a Boolean value that determines whether the view is hidden and styling properties should be applied
    /// - Parameter value: true if you want to hide the view and not applied styling properties.
    /// - Returns: Self
    @discardableResult
    public func gone(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIView.isHidden),value)
        if let enable = self.node?.isEnabled {
            if !enable && !value {
                if let node =  self.node?.root {
                    self.node?.isEnabled = !value
                    ArgoKitReusedLayoutHelper.appLayout(node)
                }
            }else{
                self.node?.isEnabled = !value
            }
        }else{
            self.node?.isEnabled = !value
        }
        return self;
    }
    
    /// Sets options to specify how a view adjusts its content when its size changes.
    /// - Parameter value: Options to specify how a view adjusts its content when its size changes.
    /// - Returns: Self
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> Self {
        addAttribute(#selector(setter:UIView.contentMode),value.rawValue)
        return self;
    }
    
    /// Sets the first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Parameter value: The first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Returns: Self
    @discardableResult
    public func tintColor(_ value: UIColor) -> Self {
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    /// Sets the first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Parameters:
    ///   - r: The red value of the color object. 0~255
    ///   - g: The green value of the color object. 0~255
    ///   - b: The blue value of the color object. 0~255
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func tintColor(red r: Int, green g: Int, blue b: Int, alpha a: CGFloat = 1) -> Self {
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    /// Sets the first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Parameters:
    ///   - hex: The hex value of the color object
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func tintColor(hex: Int, alpha a: Float = 1) -> Self {
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UIView.tintColor),value)
        return self;
    }
    
    /// Sets the first non-default tint adjustment mode value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Parameter value: The first non-default tint adjustment mode value in the view’s hierarchy, ascending from and starting with the view itself.
    /// - Returns: Self
    @discardableResult
    public func tintAdjustmentMode(_ value:UIView.TintAdjustmentMode)->Self{
        addAttribute(#selector(setter:UIView.tintAdjustmentMode),value.rawValue)
        return self;
    }
    
    /// Sets a Boolean value that determines whether subviews are confined to the bounds of the view.
    /// - Parameter value: A Boolean value that determines whether subviews are confined to the bounds of the view.
    /// - Returns: Self
    @discardableResult
    public func clipsToBounds(_ value:Bool)->Self{
        addAttribute(#selector(setter:UIView.clipsToBounds),value)
        return self;
    }
    
    /// Sets the corner radius of this view.
    /// - Parameter value: The corner radius of this view.
    /// - Returns: Self
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        return self.cornerRadius(topLeft: value, topRight: value, bottomLeft: value, bottomRight: value);
    }
    
    /// Sets the radius of this view's corner.
    /// - Parameters:
    ///   - topLeft: The radius of this view's top left corner.
    ///   - topRight: The radius of this view's top right corner.
    ///   - bottomLeft: The radius of this view's bottom left corner.
    ///   - bottomRight: The radius of this view's bottom right corner.
    /// - Returns: Self
    @discardableResult
    public func cornerRadius(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) -> Self {
        let multiRadius = ArgoKitCornerRadius(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        self.node?.maskLayerOperation?.updateCornersRadius(multiRadius)
        
        self.node?.borderLayerOperation?.updateCornersRadius(multiRadius)
        return self;
    }
    
    /// Sets the width of this view's border.
    /// - Parameter value: The border width of this view.
    /// - Returns: Self
    @discardableResult
    public func borderWidth(_ value: CGFloat) -> Self {
        self.node?.borderLayerOperation?.borderWidth = value
        return self;
    }
    
    /// Sets the color of this view's border.
    /// - Parameter value: The border color of this view.
    /// - Returns: Self
    @discardableResult
    public func borderColor(_ value: UIColor) -> Self {
        self.node?.borderLayerOperation?.borderColor = value
        return self;
    }
    
    /// Sets the color of this view's border.
    /// - Parameters:
    ///   - r: The red value of the color object. 0~255
    ///   - g: The green value of the color object. 0~255
    ///   - b: The blue value of the color object. 0~255
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func borderColor(red r: Int, green g: Int, blue b: Int, alpha a: CGFloat = 1) -> Self {
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        return self;
    }
    
    /// Sets the color of this view's border.
    /// - Parameters:
    ///   - hex: The hex value of the color object
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func borderColor(hex: Int, alpha a: Float = 1) -> Self {
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(isCALayer: true,#selector(setter:CALayer.borderColor),value.cgColor)
        return self;
    }
    
    /// Clip this view to circle.
    /// - Returns: Self
    @discardableResult
    public func circle()->Self{
        _ = self.clipsToBounds(true)
        self.node?.maskLayerOperation?.circle()
        self.node?.borderLayerOperation?.circle()
        return self;
    }
    
    /// Sets the color of the layer’s shadow. Animatable.
    /// - Parameter value: The color of the layer’s shadow.
    /// - Returns: Self
    @discardableResult
    public func shadowColor(_ value: UIColor?) -> Self {
        self.node?.shadowOperation?.updateShadowColor(value)
        return self
    }
    
    /// Sets the color of the layer’s shadow. Animatable.
    /// - Parameters:
    ///   - r: The red value of the color object. 0~255
    ///   - g: The green value of the color object. 0~255
    ///   - b: The blue value of the color object. 0~255
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func shadowColor(red r: Int, green g: Int, blue b: Int, alpha a: CGFloat = 1) -> Self {
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        self.node?.shadowOperation?.updateShadowColor(value)
        return self;
    }
    
    /// Sets the color of the layer’s shadow. Animatable.
    /// - Parameters:
    ///   - hex: The hex value of the color object
    ///   - a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: Self
    @discardableResult
    public func shadowColor(hex: Int, alpha a: Float = 1) -> Self {
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        self.node?.shadowOperation?.updateShadowColor(value)
        return self;
    }
    
    /// Sets the the offset, radius and opacity of the layer’s shadow. Animatable.
    /// - Parameters:
    ///   - offset: The offset of the layer’s shadow.
    ///   - radius: The radius of the layer’s shadow.
    ///   - opacity: The opacity of the layer’s shadow.
    /// - Returns: Self
    @discardableResult
    public func shadow(offset: CGSize, radius: CGFloat, opacity: Float) -> Self {
        self.node?.shadowOperation?.updateShadow(offset: offset, radius: radius, opacity: opacity)
        return self
    }
    
    /// Config the layer’s shadow. Animatable.
    /// - Parameters:
    ///   - color: The color of the layer’s shadow.
    ///   - offset: The offset of the layer’s shadow.
    ///   - radius: The radius of the layer’s shadow.
    ///   - opacity: The opacity of the layer’s shadow.
    ///   - corners: The radius of this view's corner.
    /// - Returns: Self
    @discardableResult
    public func shadow(color: UIColor? = .gray, offset: CGSize, radius: CGFloat, opacity: Float, corners: UIRectCorner = .allCorners) -> Self {
        self.node?.shadowOperation?.updateCornersRadius(shadowColor: color, shadowOffset: offset, shadowRadius: radius, shadowOpacity: opacity, corners: corners)
        return self;
    }
    
    /// Sets the view’s background gradient color.
    /// - Parameters:
    ///   - startColor: The start color of the gradient.
    ///   - endColor: The end color of the gradient.
    ///   - direction: The direction of the gradient.
    /// - Returns: Self
    @discardableResult
    public func gradientColor(startColor: UIColor?, endColor: UIColor?, direction: ArgoKitGradientType?) -> Self {
        self.node?.gradientLayerOperation?.updateGradientLayer(startColor: startColor, endColor: endColor, direction: direction)
        return self
    }
    
    /// Clean the view’s background gradient color.
    /// - Returns: Self
    @discardableResult
    public func cleanGradientLayer() -> Self {
        self.node?.gradientLayerOperation?.cleanGradientLayerIfNeed()
        return self
    }
}

extension View{
    
    /// Adds blur effect to this view.
    /// - Parameters:
    ///   - style: The intensity of the blur effect. See UIBlurEffect.Style for valid options.
    ///   - alpha: The alpha of the blur effect.
    ///   - color: The color of the blur effect.
    /// - Returns: Self
    @discardableResult
    public func addBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat? = nil, color: UIColor? = nil) -> Self {
        self.node?.blurEffectOperation?.addBlurEffect(style: style,alpha: alpha,color: color)
        return self
    }
    
    /// Removes blur effect.
    /// - Returns: Self
    @discardableResult
    public func removeBlurEffect() -> Self {
        self.node?.blurEffectOperation?.removeBlurEffect()
        return self
    }
}
