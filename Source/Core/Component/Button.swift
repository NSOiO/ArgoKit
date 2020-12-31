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
    let pNode:ArgoKitArttibuteNode
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

