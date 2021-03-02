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
    }
    
    /// Initializer
    /// - Parameters:
    ///   - action: The action to perform when the user triggers the button.
    ///   - builder: A view builder that creates the content of this button.
    public init(action: @escaping () -> Void, @ArgoKitViewBuilder builder: @escaping () -> View) {
        self.init()
        self.addAction(action: action)
        addSubViews(builder: builder)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - text: A string that describes the purpose of the button’s action.
    ///   - action: The action to perform when the user triggers the button.
    public init(text: @escaping @autoclosure () -> String?, action: @escaping () -> Void) {
        self.init()
        self.addAction(action: action)
        
        label = Text(text()).alignSelf(.center).textAlign(.center).grow(1)
        self.bindCallback({ [self] in
            setValue(pNode, #selector(setter: UILabel.text), text())
        }, forKey: #function)
        if let node = label?.node {
            pNode.addChildNode(node)
        }

    }
    private func addAction(action: @escaping () -> Void){
        self.onTapGesture(action: action)
    }
}

extension Button {
    func setValue(_ node: ArgoKitNode, _ selector: Selector, _ value: Any?) -> Void {
        if let nodes = node.childs{
            for subNode in nodes {
                if let lableNode = label?.node,let node = subNode as? NSObject,node == lableNode  {
                    ArgoKitNodeViewModifier.addAttribute(isDirty:true,lableNode as? ArgoKitTextBaseNode, selector, value)
                    continue
                }
                if subNode is ArgoKitTextBaseNode {
                    if let _ =  (subNode as! ArgoKitTextBaseNode).value(with: selector){
                    }else{
                        ArgoKitNodeViewModifier.addAttribute(subNode as? ArgoKitTextBaseNode, selector, value)
                    }
                }else{
                    setValue(subNode as! ArgoKitNode, selector, value)
                }
            }
        }
    }
}

