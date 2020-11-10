//
//  ArgoKitListHeaderFooterView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/5.
//

import Foundation

class ArgoKitListHeaderFooterView: UITableViewHeaderFooterView {
  
    var contentNode: ArgoKitNode?
        
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
