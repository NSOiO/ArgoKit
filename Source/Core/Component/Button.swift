//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation

/// Wrapper of UIButton
/// A control that executes your custom code in response to user interactions.
///
///```
///         Button {
///             // click action
///         } builder: {
///             // content
///         }
///```
///
public struct Button: View {
    private let pNode:ArgoKitArttibuteNode
    private var label:Text?
    
    /// The node behind the button.
    public var node: ArgoKitNode? {
        pNode
    }
    
    private init() {
        pNode = ArgoKitArttibuteNode(viewClass: UIButton.self)
        pNode.row()
        pNode.alignItemsCenter()
    }
    
    /// Initializer
    /// - Parameters:
    ///   - action: The action to perform when the user triggers the button.
    ///   - builder: A view builder that creates the content of this button.
    public init(action: @escaping () -> Void, @ArgoKitViewBuilder builder: @escaping () -> View) {
        self.init(text: nil, action: action)
        addSubViews(builder: builder)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - text: A string that describes the purpose of the button’s action.
    ///   - action: The action to perform when the user triggers the button.
    public init(text: String?, action: @escaping () -> Void) {
        self.init()
        pNode.addAction({ (obj, paramter) -> Any? in
            action();
        }, for: UIControl.Event.touchUpInside)
        
        if let t = text {
            label = Text(t).alignSelf(.center).textAlign(.center).grow(1)
            if let node = label?.node {
                pNode.addChildNode(node)
            }
            setValue(pNode, #selector(setter: UILabel.text), t)
        }
    }
}


extension Button {
    
    /// Sets the color of the text.
    /// - Parameter color: The color of the text.
    /// - Returns: self
    @discardableResult
    public func textColor(_ color: UIColor?) -> Self {
        setValue(pNode, #selector(setter: UILabel.textColor), color)
        return self
    }
    
    /// Sets the font of the text.
    /// - Parameter value: The font of the text.
    /// - Returns: self
    @discardableResult
    public func font(_ value: UIFont!) -> Self {
        setValue(pNode, #selector(setter: UILabel.font), value)
        return self
    }
    
    /// Sets the font of the text.
    /// - Parameters:
    ///   - name: The fully specified name of the font. This name incorporates both the font family name and the specific style information for the font.
    ///   - style: The text style for which to return a font. See AKFontStyle for recognized values.
    ///   - size: The size (in points) to which the font is scaled. This value must be greater than 0.0.
    /// - Returns: self
    @discardableResult
    public func font(name: String? = nil, style: AKFontStyle, size: CGFloat) -> Self {
        pNode.fontName = name
        pNode.fontSize = size
        pNode.fontStyle = style
        let f = UIFont.font(fontName:name, fontStyle:style, fontSize:size)
        return font(f)
    }
}

extension Button {
    
    func setValue(_ node: ArgoKitNode, _ selector: Selector, _ value: Any?) -> Void {
        if let nodes = node.childs{
            for subNode in nodes {
                if let lableNode = label?.node {
                    if subNode as! NSObject == lableNode {
                        ArgoKitNodeViewModifier.addAttribute(lableNode as? ArgoKitTextNode, selector, value)
                        continue
                    }
                }
                
                if subNode is ArgoKitTextNode {
                    if let _ =  (subNode as! ArgoKitTextNode).value(with: selector){
                    }else{
                        ArgoKitNodeViewModifier.addAttribute(subNode as? ArgoKitTextNode, selector, value)
                    }
                }else{
                    setValue(subNode as! ArgoKitNode, selector, value)
                }
            }
        }
    }
}

