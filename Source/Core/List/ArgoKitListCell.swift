//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ArgoKitCellNode: ArgoKitNode {
    
    private var in_indexPath : IndexPath = IndexPath(row: 0, section: 0)
    
    public var indexPath: IndexPath {
        in_indexPath
    }
    
    public func observeFrameChanged(_ observer: NSObject, indexPath: IndexPath) {
        in_indexPath = indexPath
        addObserver(observer, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    public func removeObservingFrameChanged(_ observer: NSObject) {
        if observationInfo != nil {
            removeObserver(observer, forKeyPath: "frame")
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
        if let contentNode =  self.contentNode{
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculationWithoutView()
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(contentNode, reuse: node)
        }else{
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation()
        }
        ArgoReusedLayoutHelper.addLayoutNode(node)
    }
}
