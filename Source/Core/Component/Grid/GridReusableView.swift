//
//  GridReusableView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/18.
//

import Foundation
class GridReusableViewNode: ArgoKitNode {
    
}
class GridReusableView: UICollectionReusableView {
    var contentNode: ArgoKitCellNode?
    override func prepareForReuse() {
        
    }
    public func linkCellNode(_ node: ArgoKitCellNode) {
        if self.subviews.count != 0 && self.contentNode != nil {
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculation(withView:false)
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        }else{
            node.bindView(self)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
        }
        ArgoKitReusedLayoutHelper.addLayoutNode(node)
    }
}
