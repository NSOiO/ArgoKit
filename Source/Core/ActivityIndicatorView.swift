//
//  ActivityIndicatorView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct ActivityIndicatorView : View {
    
    private var activityIndicatorView : UIActivityIndicatorView
    private var pNode : ArgoKitNode
    
    public var body: View {
        ViewEmpty()
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init(style: UIActivityIndicatorView.Style) {
        activityIndicatorView = UIActivityIndicatorView(style: style);
        pNode = ArgoKitNode(view: activityIndicatorView)
    }
}

extension ActivityIndicatorView {
    
    public func style(_ value: UIActivityIndicatorView.Style) -> Self {
        activityIndicatorView.style = value
        return self
    }
    
    public func hidesWhenStopped(_ value: Bool) -> Self {
        activityIndicatorView.hidesWhenStopped = value
        return self
    }
    
    public func color(_ value: UIColor!) -> Self {
        activityIndicatorView.color = value
        return self
    }
    
    public func startAnimating() -> Self {
        activityIndicatorView.startAnimating()
        return self
    }
    
    public func stopAnimating() -> Self {
        activityIndicatorView.stopAnimating()
        return self
    }
}
