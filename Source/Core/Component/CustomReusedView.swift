//
//  CustomReusedView.swift
//  ArgoKit
//
//  Created by Bruce on 2021/2/22.
//

import Foundation
import Foundation
class CustomReuseViewNode<D>: ArgoKitNode {
//    deinit {
//        if let view = self.view {
//            view.removeObserver(self, forKeyPath: "frame")
//        }
//    }
    var data:D? = nil
    var contentView:((D)->UIView)? = nil
    var reuseView:((UIView,D)->())? = nil

    init(data:D,view:@escaping (D)->UIView,reuseView:@escaping (UIView,D)->()) {
        super.init(viewClass: UIView.self)
        self.data = data
        self.contentView = view
        self.reuseView = reuseView
    }
    
    init(data:D) {
        super.init(viewClass: UIView.self)
        self.data = data
    }

    override func createNodeView(withFrame frame: CGRect) -> UIView {
        if let contentView =  self.contentView, let data_ = data{
            let view = contentView(data_)
            view.frame = frame
            if let reuseView =  self.reuseView{
                reuseView(view,data_)
            }
//            view.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
            return view
        }
        return UIView()
    }

    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        if let reuseView =  self.reuseView,
           let node_ = node as? CustomReuseViewNode,
           let view_ =  view,
           let data = node_.data{
                reuseView(view_,data)
           }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let view = self.nodeView() {
            return view.sizeThatFits(size)
        }
        return CGSize.zero
    }
//    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "frame" {
//            if let new = change?[NSKeyValueChangeKey.newKey] as? CGRect,
//               let old = change?[NSKeyValueChangeKey.oldKey] as? CGRect{
//                if !new.size.equalTo(old.size) {
//                    self.markDirty()
//                }
//            }
//        }
//    }
}

/// Wrapper of custom view for UIKit
/// A view that displays a single custom view for UIKit.
///
///```
///        CustomView(view:customView)
///        .backgroundColor(.yellow)
///        margin(edge: .top, value: 100)
///```
///
public struct CustomReusedView<D>:View{
    private var pNode: CustomReuseViewNode<D>
    public var node: ArgoKitNode?{
        return pNode
    }
    /// Initializer
    /// - Parameter view: stom view for UIKit.
    public init(data:D,createdView:@escaping (D)->UIView,reuseView:@escaping (UIView,D)->()) {
        pNode = CustomReuseViewNode(data: data, view: createdView, reuseView: reuseView)
    }
    
    /// Initializer
    /// - Parameter view: stom view for UIKit.
    public init(data:D) {
        pNode = CustomReuseViewNode(data: data)
    }
    
    public func createView(_ value:@escaping (D)->UIView) -> Self{
        pNode.contentView = value
        return self
    }
    
    public func reuseView(_ value:@escaping (UIView,D)->()) -> Self{
        pNode.reuseView = value
        return self
    }
}

