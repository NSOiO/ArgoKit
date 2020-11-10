//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ArgoKitListCell: UITableViewCell {
  
    var contentNode: ArgoKitNode?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {
        if self.contentNode != nil {
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculationForReused()
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!.childs as? [ArgoKitNode], reuse: node.childs as? [ArgoKitNode]);
        } else {
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation()
        }
    }
}
