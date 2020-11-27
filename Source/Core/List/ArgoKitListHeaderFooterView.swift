//
//  ArgoKitListHeaderFooterView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/5.
//

import Foundation

class ArgoKitListHeaderFooterView: UITableViewHeaderFooterView {
  
    var contentNode: ArgoKitCellNode?
        
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
        ArgoKitReusedLayoutHelper.addLayoutNode(node)
    }
}
