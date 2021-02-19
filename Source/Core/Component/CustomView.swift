//
//  CustomView.swift
//  ArgoKit
//
//  Created by Bruce on 2021/2/19.
//

import Foundation
class CustomViewNode: ArgoKitNode {
    deinit {
        if let view = self.view {
            view.removeObserver(self, forKeyPath: "frame")
        }
    }
    override init(view: UIView) {
        super.init(view: view)
        view.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let view = self.view {
            return view.sizeThatFits(size)
        }
        return size
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            if let new = change?[NSKeyValueChangeKey.newKey] as? CGRect,
               let old = change?[NSKeyValueChangeKey.oldKey] as? CGRect{
                if !new.size.equalTo(old.size) {
                    self.markDirty()
                }
            }
        }
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
public struct CustomView:View{
    private var pNode: CustomViewNode
    public var node: ArgoKitNode?{
        return pNode
    }
    /// Initializer
    /// - Parameter view: stom view for UIKit.
    public init(view:UIView) {
        pNode = CustomViewNode(view: view)
    }
}
