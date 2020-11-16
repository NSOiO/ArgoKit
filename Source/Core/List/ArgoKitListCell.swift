//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation
class ArgoKitCellNode: ArgoKitNode {
    public var indexPath:IndexPath = IndexPath(row: 0, section: 0)
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
    deinit {
        print("cell deinit")
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
