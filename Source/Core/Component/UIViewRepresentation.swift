//
//  UIViewRepresentation.swift
//  ArgoKit
//
//  Created by Bruce on 2021/2/22.
//

import Foundation

class UIViewRepresentationNode<D>: ArgoKitNode {
    var data: D? = nil
    var createView: ((D?) -> UIView)? = nil
    var reuseView: ((UIView, D?) -> ())? = nil
    var preForUse:( (UIView) -> ())? = nil
    private var gestures: [UIGestureRecognizer]?
    
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        createView = nil
        reuseView = nil
        preForUse = nil
        data = nil
    }

    init(data: D?) {
        super.init(viewClass: UIView.self)
        self.data = data
    }

    override func createNodeView(withFrame frame: CGRect) -> UIView {
        if let createViewBlock = self.createView {
            let view = createViewBlock(data)
            self.gestures = view.gestureRecognizers
            
            let size = view.frame.size
            let frameZero = (frame.size.width == 0 || frame.size.height == 0)
            if !frameZero {
                view.frame = frame
            }
            if frameZero && !size.equalTo(CGSize.zero){
                self.width(point: size.width)
                self.height(point: size.height)
            }
            return view
        }
        return UIView()
    }
    
    override func prepareForUse(view: UIView?) {
        super.prepareForUse(view: view)
        if let view = view,
           let gestures = self.gestures {
            for gesture in gestures {
                view.addGestureRecognizer(gesture)
            }
        }
        if let view_ = view,
           let preForUseBlock = self.preForUse {
            preForUseBlock(view_)
        }
    }

    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
        guard let node_ = node as? UIViewRepresentationNode else {
            return
        }
        
        if let reuseViewBlock = node_.reuseView,
           let view_ = view {
            let startSize = view_.frame.size
            reuseViewBlock(view_, node_.data)
            let endSize = view_.frame.size
            
            if startSize.width != endSize.width {
                node.width(point: endSize.width)
            }
            if startSize.height != endSize.height {
                node.height(point: endSize.height)
            }
            
            if let rootNode = node.root,
               let _ = rootNode.nodeView(),
               rootNode.isDirty {
                var maxWidth = rootNode.size.width
                if maxWidth == 0 {
                    maxWidth = UIScreen.main.bounds.size.width
                }
                rootNode.calculateLayout(size: CGSize(width: maxWidth, height: CGFloat.nan))
                rootNode.applyLayoutAferCalculation(withView: false)
                ArgoKitNodeViewModifier.resetNodeViewFrame(rootNode)
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let view = self.nodeView() {
            return view.sizeThatFits(size)
        }
        return CGSize.zero
    }
}

/// Wrapper of custom view for UIKit
/// A view that displays a single custom view for UIKit.
public struct UIViewRepresentation<D>: View {
    private var pNode: UIViewRepresentationNode<D>
    public var node: ArgoKitNode? {
        return pNode
    }
    
    /// Initializer
    /// - Parameter data: UIView used model .
    public init(data: D? = nil) {
        pNode = UIViewRepresentationNode(data: data)
    }
    
    /// create UIKit custom view
    /// - Parameter Self.
    public func createUIView(_ value: @escaping (D?) -> UIView) -> Self {
        pNode.createView = value
        return self
    }
    
    /// update  the View
    /// - Parameter Self.
    public func updateUIView(_ value: @escaping (UIView, D?) -> ()) -> Self {
        pNode.reuseView = value
        return self
    }
    
    /// prepare  use UIKit custom view in List
    /// - Parameter Self.
    public func prepareForUse(_ value: @escaping (UIView)-> ()) -> Self {
        pNode.preForUse = value
        return self
    }
}

extension UIViewRepresentation{
    
    @available(*, deprecated, message: "CustomReusedView does not support padding!")
    public func padding(top: ArgoValue, right: ArgoValue, bottom: ArgoValue, left: ArgoValue) -> Self {
        return self
    }
    
    @available(*, deprecated, message: "CustomReusedView does not support padding!")
    public func padding(edge: ArgoEdge, value: ArgoValue) -> Self {
        return self
    }
}
