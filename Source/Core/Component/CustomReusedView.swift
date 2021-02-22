//
//  CustomReusedView.swift
//  ArgoKit
//
//  Created by Bruce on 2021/2/22.
//

import Foundation
import Foundation
class CustomReuseViewNode<D>: ArgoKitNode {
    deinit {
        print("CustomReuseViewNode")
    }
    var data:D? = nil
    var createView:((D)->UIView)? = nil
    var reuseView:((UIView,D)->())? = nil
    var preForUse:((UIView)->())? = nil
    
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        createView = nil
        reuseView = nil
        preForUse = nil
    }

    init(data:D) {
        super.init(viewClass: UIView.self)
        self.data = data
    }

    override func createNodeView(withFrame frame: CGRect) -> UIView {
        if let contentView =  self.createView, let data_ = data{
            let view = contentView(data_)
            view.frame = frame
            if let reuseView =  self.reuseView{
                reuseView(view,data_)
            }
            return view
        }
        return UIView()
    }
    
    override func prepareForUse() {
        super.prepareForUse()
        if let view = self.view,
           let preForUse = self.preForUse {
            preForUse(view)
        }
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
    public init(data:D) {
        pNode = CustomReuseViewNode(data: data)
    }
    /// create UIKit Custom View
    /// - Parameter Self.
    public func createView(_ value:@escaping (D)->UIView) -> Self{
        pNode.createView = value
        return self
    }
    
    /// reuse UIKit Custom View in List
    /// - Parameter Self.
    public func reuseView(_ value:@escaping (UIView,D)->()) -> Self{
        pNode.reuseView = value
        return self
    }
    
    /// prepare  use UIKit Custom View in List
    /// - Parameter Self.
    public func prepareForUse(_ value:@escaping (UIView)->()) -> Self{
        pNode.preForUse = value
        return self
    }
}

