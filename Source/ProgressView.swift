//
//  ProgressView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

public struct ProgressView : View {
    
    private var progressView : UIProgressView
    private var pNode : ArgoKitNode
    
    public var body: View {
        self
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init(_ progress: Float?) {
        self.init(progressViewStyle: .default)
        progressView.progress = progress ?? 0.0
    }
    
    @available(iOS 9.0, *)
    public init(_ observedProgress: Progress) {
        self.init(progressViewStyle: .default)
        progressView.observedProgress = observedProgress
    }
    
    public init(progressViewStyle style: UIProgressView.Style) {
        progressView = UIProgressView(progressViewStyle: style);
        pNode = ArgoKitNode(view: progressView)
        self.node?.width(point: progressView.frame.width)
        self.node?.height(point: progressView.frame.height)
    }
}

extension ProgressView {
    
    public func progressViewStyle(_ value: UIProgressView.Style) -> Self {
        progressView.progressViewStyle = value
        return self
    }
    
    public func progress(_ value: Float) -> Self {
        progressView.progress = value
        return self
    }
    
    public func progressTintColor(_ value: UIColor?) -> Self {
        progressView.progressTintColor = value
        return self
    }
    
    public func trackTintColor(_ value: UIColor?) -> Self {
        progressView.trackTintColor = value
        return self
    }
    
    public func progressImage(_ value: UIImage?) -> Self {
        progressView.progressImage = value
        return self
    }
    
    public func trackImage(_ value: UIImage?) -> Self {
        progressView.trackImage = value
        return self
    }
    
    public func setProgress(_ value: Float, animated: Bool) -> Self {
        progressView.setProgress(value, animated: animated)
        return self
    }
    
    @available(iOS 9.0, *)
    public func observedProgress(_ value: Progress?) -> Self {
        progressView.observedProgress = value
        return self
    }
}
