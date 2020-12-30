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
    /// Clip this view to circle.
    /// - Returns: Self
    @discardableResult
    public func circle()->Self{
        _ = self.clipsToBounds(true)
        self.node?.maskLayerOperation?.circle()
        self.node?.borderLayerOperation?.circle()
        return self;
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
