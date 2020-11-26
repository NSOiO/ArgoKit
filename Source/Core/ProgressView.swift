//
//  ProgressView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

open class ProgressView : View {
    
    private var pNode : ArgoKitNode
    public var node: ArgoKitNode? {
        pNode
    }
    
    public convenience init(_ progress: Float?) {
        self.init(progressViewStyle: .default)
        addAttribute(#selector(setter:UIProgressView.progress),progress ?? 0.0)
    }
    
    @available(iOS 9.0, *)
    public convenience init(_ observedProgress: Progress) {
        self.init(progressViewStyle: .default)
        addAttribute(#selector(setter:UIProgressView.observedProgress),observedProgress)
    }
    
    public init(progressViewStyle style: UIProgressView.Style) {
        pNode = ArgoKitNode(viewClass:UIProgressView.self)
        addAttribute(#selector(setter:UIProgressView.progressViewStyle),style.rawValue)
    }
    
    public init?(_ configuration: ProgressViewStyleConfiguration) {
        if (configuration.node.view as? UIProgressView) != nil {
            pNode = configuration.node
        } else {
            return nil
        }
    }
}

extension ProgressView {
    
    public func progressViewStyle(_ value: UIProgressView.Style) -> Self {
        addAttribute(#selector(setter:UIProgressView.progressViewStyle),value.rawValue)
        return self
    }
    
    public func progress(_ value: Float) -> Self {
        addAttribute(#selector(setter:UIProgressView.progress),value)
        return self
    }
    
    public func progressTintColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UIProgressView.progressTintColor),value)
        return self
    }
    
    public func trackTintColor(_ value: UIColor?) -> Self {
        addAttribute(#selector(setter:UIProgressView.trackTintColor),value)
        return self
    }
    
    public func progressImage(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIProgressView.progressImage),value)
        return self
    }
    
    public func trackImage(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIProgressView.trackImage),value)
        return self
    }
    
    public func setProgress(_ value: Float, animated: Bool) -> Self {
        addAttribute(#selector(UIProgressView.setProgress),value,animated)
        return self
    }
    
    @available(iOS 9.0, *)
    public func observedProgress(_ value: Progress?) -> Self {
        addAttribute(#selector(setter:UIProgressView.observedProgress),value)
        return self
    }
}


extension View {

    public func progressViewStyle<S>(style: S) -> View where S : ProgressViewStyle {
        if let nodes = self.type.viewNodes() {
            self.remakeProgressView(style, nodes: nodes)
        }
        return self
    }
    
    private func remakeProgressView<S>(_ style: S, nodes: [ArgoKitNode]) where S : ProgressViewStyle {
        for node in nodes {
            if (node.view != nil) && node.view!.isKind(of: UIProgressView.self) {
                let _ = style.makeBody(configuration: ProgressViewStyleConfiguration(node: node))
            } else if node.childs?.count != nil {
                self.remakeProgressView(style, nodes: node.childs as! [ArgoKitNode])
            }
        }
    }
}

public protocol ProgressViewStyle {

    associatedtype Body : View

    func makeBody(configuration: Self.Configuration) -> Self.Body?

    typealias Configuration = ProgressViewStyleConfiguration
}

public class ProgressViewStyleConfiguration {

    public let node: ArgoKitNode
    init(node:ArgoKitNode) {
        self.node = node
    }
}
