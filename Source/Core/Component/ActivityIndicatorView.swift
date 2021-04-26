//
//  ActivityIndicatorView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

class ArgoKitIndicatorViewNode: ArgoKitNode {
    var style: UIActivityIndicatorView.Style = .whiteLarge
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.frame = frame
        return indicatorView
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
}

/// Wrapper of UIActivityIndicatorView
/// A view that shows that a task is in progress.
///
///```
///         ActivityIndicatorView(style: .large)
///             .hidesWhenStopped(false)
///             .startAnimating()
///```
///
public struct ActivityIndicatorView : View {
    private var pNode : ArgoKitIndicatorViewNode
    
    /// The node behind the activityIndicator view.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    /// - Parameter style: A constant that specifies the style of the object to be created. See UIActivityIndicatorView.Style for descriptions of the style constants.
    public init(style: UIActivityIndicatorView.Style) {
        pNode = ArgoKitIndicatorViewNode(viewClass: UIActivityIndicatorView.self, type: Self.self)
        pNode.style = style
    }
}

extension ActivityIndicatorView {
    /// Starts the animation of the progress indicator.
    /// - Returns: self
    @discardableResult
    public func startAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.startAnimating))
        return self
    }
    
    /// Stops the animation of the progress indicator.
    /// - Returns: self
    @discardableResult
    public func stopAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.stopAnimating))
        return self
    }
}

extension ActivityIndicatorView{
   @available(*, deprecated, message: "ActivityIndicatorView does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "ActivityIndicatorView does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
