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
public struct ActivityIndicatorView : View {
    private var pNode : ArgoKitIndicatorViewNode
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init(style: UIActivityIndicatorView.Style) {
        pNode = ArgoKitIndicatorViewNode(viewClass: UIActivityIndicatorView.self)
        pNode.style = style
    }
}

extension ActivityIndicatorView {
    @discardableResult
    public func style(_ value: UIActivityIndicatorView.Style) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.style),value.rawValue)
        return self
    }
    @discardableResult
    public func hidesWhenStopped(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.hidesWhenStopped),value)
        return self
    }
    @discardableResult
    public func color(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIActivityIndicatorView.color),value)
        return self
    }
    @discardableResult
    public func startAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.startAnimating))
        return self
    }
    @discardableResult
    public func stopAnimating() -> Self {
        addAttribute(#selector(UIActivityIndicatorView.stopAnimating))
        return self
    }
}
