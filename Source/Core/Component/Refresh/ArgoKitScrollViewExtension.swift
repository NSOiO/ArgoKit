//
//  ArgoKitScrollViewExtension.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/2.
//

import Foundation
import UIKit


public extension UIView {
    var argokit_x: CGFloat {
        set(newX) {
            var frame = self.frame
            if frame.origin.x !=  newX{
                frame.origin.x = newX
                self.frame = frame
            }
        }
        get {
            return self.frame.origin.x
        }
    }
    var argokit_y: CGFloat {
        set(newY) {
            var frame = self.frame
            if frame.origin.y != newY {
                frame.origin.y = newY
                self.frame = frame
            }
        }
        get {
            return self.frame.origin.y
        }
    }
    var argokit_width: CGFloat {
        set(newWidth) {
            var frame = self.frame
            if frame.size.width != newWidth {
                frame.size.width = newWidth
                self.frame = frame
            }
        }
        get {
            return self.frame.size.width
        }
    }
    var argokit_height: CGFloat {
        set(newHeight) {
            var frame = self.frame
            if frame.size.height != newHeight {
                frame.size.height = newHeight
                self.frame = frame
            }
        }
        get {
            return self.frame.size.height
        }
    }
    var argokit_size: CGSize {
        set(newSize) {
            var frame = self.frame
            if !frame.size.equalTo(newSize) {
                frame.size = newSize
                self.frame = frame
            }
        }
        get {
            return self.frame.size
        }
    }
    var argokit_origin: CGPoint {
        set(newOrigin) {
            var frame = self.frame
            if !frame.origin.equalTo(newOrigin) {
                frame.origin = newOrigin
                self.frame = frame
            }
        }
        get {
            return self.frame.origin
        }
    }
}

public extension UIScrollView {
    var argokit_inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            } else {
                return self.contentInset
            }
        }
    }
    
    var argokit_insetTop: CGFloat {
        set(newTop) {
            var inset = self.contentInset
            var top = newTop
            if #available(iOS 11.0, *) {
                top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            if inset.top !=  top{
                inset.top = top
                self.contentInset = inset
            }
        }
        get {
            return argokit_inset.top
        }
    }
    
    var argokit_insetRight: CGFloat {
        set(newRight) {
            var inset = self.contentInset
            var right = newRight
            if #available(iOS 11.0, *) {
                right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            
            if inset.right !=  right{
                inset.right = right
                self.contentInset = inset
            }
            self.contentInset = inset
        }
        get {
            return argokit_inset.right
        }
    }
    
    var argokit_insetBottom: CGFloat {
        set(newBottom) {
            var inset = self.contentInset
            var bottom = newBottom
            if #available(iOS 11.0, *) {
                bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            if inset.bottom !=  bottom{
                inset.bottom = bottom
                self.contentInset = inset
            }
        }
        get {
            return argokit_inset.bottom
        }
    }
    
    var argokit_insetLeft: CGFloat {
        set(newLeft) {
            var inset = self.contentInset
            var left = newLeft
            if #available(iOS 11.0, *) {
                left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            if inset.left !=  left{
                inset.left = left
                self.contentInset = inset
            }
        }
        get {
            return argokit_inset.left
        }
    }
    
    var argokit_offset: CGPoint {
        set(newOffset) {
            if !self.contentOffset.equalTo(newOffset) {
                self.contentOffset = newOffset
            }
        }
        get {
            return self.contentOffset
        }
    }
    
    var argokit_offsetX: CGFloat {
        set(newOffsetX) {
            var offset = self.contentOffset
            if offset.x != newOffsetX {
                offset.x = newOffsetX
                self.contentOffset = offset
            }
        }
        get {
            return self.contentOffset.x
        }
    }
    
    var argokit_offsetY: CGFloat {
        set(newOffsetY) {
            var offset = self.contentOffset
            if offset.y != newOffsetY {
                offset.y = newOffsetY
                self.contentOffset = offset
            }
        }
        get {
            return self.contentOffset.y
        }
    }
    
    var argokit_contentW: CGFloat {
        set(newContentW) {
            var size = self.contentSize
            if  size.width != newContentW {
                size.width = newContentW
                self.contentSize = size
            }
        }
        get {
            return self.contentSize.width
        }
    }
    var argokit_contentH: CGFloat {
        set(newContentH) {
            var size = self.contentSize
            if size.height != newContentH {
                size.height = newContentH
                self.contentSize = size
            }
        }
        get {
            return self.contentSize.height
        }
    }
}

extension ScrollView{
    
    @discardableResult
    public func refreshHeaderView(_ headerView:()->RefreshHeaderView)->Self{
        let view_ = headerView()
        if let node = view_.type.viewNode(),let superNode = self.node{
            superNode.addChildNode(node)
        }
        return self
    }
    
    @discardableResult
    public func refreshFooterView(_ footerView:()->RefreshFooterView)->Self{
        let view_ = footerView()
        if let node = view_.type.viewNode(),let superNode = self.node{
            superNode.addChildNode(node)
        }
        return self
    }
}
