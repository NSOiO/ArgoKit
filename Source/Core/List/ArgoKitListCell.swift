//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ArgoKitCellNode: ArgoKitNode {
    
    var frameObserber: NSKeyValueObservation?
    
    public func observeFrameChanged(changeHandler: @escaping (ArgoKitCellNode, NSKeyValueObservedChange<CGRect>) -> Void) {
        removeObservingFrameChanged()
        frameObserber = observe(\.frame, options: .new, changeHandler: changeHandler)
    }
    
    public func removeObservingFrameChanged() {
        if frameObserber != nil {
            frameObserber?.invalidate()
            frameObserber = nil
        }
    }
}

class ArgoKitListCell: UITableViewCell {
  
    var contentNode: ArgoKitCellNode?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func linkCellNode(_ node: ArgoKitCellNode) {
        if self.contentView.subviews.count != 0 && self.contentNode != nil {
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculation(withView:false)
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        }else{
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
        }
        ArgoReusedLayoutHelper.addLayoutNode(node)
    }
}
