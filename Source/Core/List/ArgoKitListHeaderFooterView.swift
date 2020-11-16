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
