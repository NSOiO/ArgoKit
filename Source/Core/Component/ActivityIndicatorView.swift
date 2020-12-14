//
//  ActivityIndicatorView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public class ActivityIndicatorView : View {
    
    private var activityIndicatorView : UIActivityIndicatorView
    private var pNode : ArgoKitNode
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init(style: UIActivityIndicatorView.Style) {
        activityIndicatorView = UIActivityIndicatorView(style: style);
        pNode = ArgoKitNode(view: activityIndicatorView)
    }
}

extension ActivityIndicatorView {
    @discardableResult
    public func style(_ value: UIActivityIndicatorView.Style) -> Self {
        activityIndicatorView.style = value
        return self
    }
    @discardableResult
    public func hidesWhenStopped(_ value: Bool) -> Self {
        activityIndicatorView.hidesWhenStopped = value
        return self
    }
    @discardableResult
    public func color(_ value: UIColor!) -> Self {
        activityIndicatorView.color = value
        return self
    }
    @discardableResult
    public func startAnimating() -> Self {
        activityIndicatorView.startAnimating()
        return self
    }
    @discardableResult
    public func stopAnimating() -> Self {
        activityIndicatorView.stopAnimating()
        return self
    }
}
