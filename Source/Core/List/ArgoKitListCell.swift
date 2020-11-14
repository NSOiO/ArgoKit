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
