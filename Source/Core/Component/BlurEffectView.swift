//
//  VisualEffectView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/28.
//

import Foundation

/// Wrapper of UIVisualEffectView
/// An object that implements some complex visual effects.
///
///```
///         BlurEffectView(style:.dark) {
///             // content
///         }
///```
///
public class BlurEffectView: View {
    private var pNode:ArgoKitNode
    
    /// The node behind the visual effect view.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    /// - Parameters:
    ///   - style: The intensity of the blur effect. See UIBlurEffect.Style for valid options.
    ///   - builder: A view builder that creates the content of this visual effect view.
    public init(style:UIBlurEffect.Style, @ArgoKitViewBuilder _ builder:@escaping () -> View) {
        let blurEffect:UIBlurEffect = UIBlurEffect(style: style)
        pNode = ArgoKitNode(viewClass: UIVisualEffectView.self)
        addSubViews(builder:builder)
        addAttribute(#selector(setter:UIVisualEffectView.effect), blurEffect)
    }
}
