//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ArgoKitCellNode: ArgoKitNode {
    
    weak var frameObserber: NSObject?
        
    public func observeFrameChanged(_ observer: NSObject) {
        if frameObserber != nil {
            self .removeObservingFrameChanged(frameObserber!)
        }
        addObserver(observer, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        frameObserber = observer
    }
    
    public func removeObservingFrameChanged(_ observer: NSObject) {
        if observationInfo != nil {
            removeObserver(observer, forKeyPath: "frame")
        }
        frameObserber = nil
    }
    
    deinit {
        if frameObserber != nil {
            removeObservingFrameChanged(frameObserber!)
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
                node.applyLayoutAferCalculationWithoutView()
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        }else{
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation()
        }
        ArgoReusedLayoutHelper.addLayoutNode(node)
    }
}
