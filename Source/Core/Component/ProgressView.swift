//
//  ProgressView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/27.
//

import Foundation

/// Wrapper of UIProgressView
///A view that depicts the progress of a task over time.
///
///The UIProgressView class provides properties for managing the style of the progress bar and for getting and setting values that are pinned to the progress of a task.
///For an indeterminate progress indicator—or, informally, a “spinner”—use an instance of the UIActivityIndicatorView class.
///
///```
/// ProgressView(0.5)
///     .width(100)
///     .height(10)
///     .backgroundColor(.brown)
///```

public struct ProgressView : View {
    
    private var pNode : ArgoKitNode
    /// the node behind the ProgressView
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// init the ProgressView
    ///
    /// The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
    /// - Parameter progress: The current progress shown by the receiver.
    public init(_ progress: Float?) {
        self.init(progressViewStyle: .default)
        addAttribute(#selector(setter:UIProgressView.progress),progress ?? 0.0)
    }
    
    /// init the ProgressView use the progress object to use for updating the progress view.
    ///
    /// When this property is set, the progress view updates its progress value automatically using information it receives from the Progress object. (Progress updates are animated.) Set the property to nil when you want to update the progress manually. The default value of this property is nil.
    /// For more information about configuring a progress object to manage progress information, see Progress.
    /// - Parameter observedProgress: the progress object
    @available(iOS 9.0, *)
    public init(_ observedProgress: Progress) {
        self.init(progressViewStyle: .default)
        addAttribute(#selector(setter:UIProgressView.observedProgress),observedProgress)
    }
    
    /// init the ProgressView use the current graphical style of the receiver.
    ///
    ///The value of this property is a constant that specifies the style of the progress view. The default style is UIProgressView.Style.default. For more on these constants, see UIProgressView.Style.
    /// - Parameter style: the style
    public init(progressViewStyle style: UIProgressView.Style) {
        pNode = ArgoKitNode(viewClass:UIProgressView.self)
        addAttribute(#selector(setter:UIProgressView.progressViewStyle),style.rawValue)
    }
    
    /// init the ProgressView use the ProgressViewStyleConfiguration
    /// - Parameter configuration: the configauration
    public init?(_ configuration: ProgressViewStyleConfiguration) {
        if (configuration.node.view as? UIProgressView) != nil {
            pNode = configuration.node
        } else {
            return nil
        }
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

extension ProgressView{
    @available(*, unavailable, message: "ProgressView does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, unavailable, message: "ProgressView does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
