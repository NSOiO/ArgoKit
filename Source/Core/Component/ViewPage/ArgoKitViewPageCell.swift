//
//  ArgoKitViewPageCell.swift
//  ArgoKit
//
//  Created by sun-zt on 2020/12/5.
//

import Foundation

class ArgoKitViewPageCell: UICollectionViewCell {
    
    var contentNode: ArgoKitCellNode?
    var tempNode: ArgoKitCellNode?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        ArgoKitNodeViewModifier.prepare(forReuse: self.contentNode)
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
        ArgoKitReusedLayoutHelper.addLayoutNode(node)
    }
}
