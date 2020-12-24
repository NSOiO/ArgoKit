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
public struct ActivityIndicatorView : View {
    private var pNode : ArgoKitIndicatorViewNode
    
    /// The node behind the activityIndicator view.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    /// - Parameter style: A constant that specifies the style of the object to be created. See UIActivityIndicatorView.Style for descriptions of the style constants.
    public init(style: UIActivityIndicatorView.Style) {
        pNode = ArgoKitIndicatorViewNode(viewClass: UIActivityIndicatorView.self)
        pNode.style = style
    }
}

extension ActivityIndicatorView {
    
    /// Sets the basic appearance of the activity indicator.
    /// - Parameter value: The basic appearance of the activity indicator.
    /// - Returns: Self
    @discardableResult
    public func style(_ value: UIActivityIndicatorView.Style) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.style),value.rawValue)
        return self
    }
    
    /// Sets a Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Parameter value: A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    /// - Returns: Self
    @discardableResult
    public func hidesWhenStopped(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.hidesWhenStopped),value)
        return self
    }
    
    /// Sets the color of the activity indicator.
    /// - Parameter value: The color of the activity indicator.
    /// - Returns: Self
    @discardableResult
    public func color(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.color),value)
        return self
    }
    
    /// Starts the animation of the progress indicator.
    /// - Returns: Self
    @discardableResult
    public func startAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.startAnimating))
        return self
    }
    
    /// Stops the animation of the progress indicator.
    /// - Returns: Self
    @discardableResult
    public func stopAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.stopAnimating))
        return self
    }
}
