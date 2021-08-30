//
//  GridCell.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation

class GridCell: UICollectionViewCell {
    var contentNode: ArgoKitCellNode?
    var reusedCellNode: ArgoKitCellNode?
    var sourceData: Any? // 数据源
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        sourceData = nil
        ArgoKitNodeViewModifier.prepare(forReuse: self.contentNode)
    }
    
    public func linkCellNode(_ node: ArgoKitCellNode) {
        if node.isPreviewing {
            node.bindView(self.contentView)
            self.contentNode = node
            if node.frame.equalTo(.zero) || node.isDirty {
                self.contentNode?.applyLayout(size: CGSize(width: self.contentView.frame.width, height: CGFloat.nan))
            }
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            return
        }
        if self.contentView.subviews.count != 0 && self.contentNode != nil{
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculation(withView:false)
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        }else{
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
        }
    }
    
    func linkCellNode(_ node: ArgoKitCellNode,isReused:Bool) {
        if node.isPreviewing {
            node.bindView(self.contentView)
            self.contentNode = node
            if node.frame.equalTo(.zero) || node.isDirty {
                self.contentNode?.applyLayout(size: CGSize(width: self.contentView.frame.width, height: CGFloat.nan))
            }
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            return
        }
        if isReused{
            if node.frame.equalTo(.zero) || node.isDirty {
                node.applyLayoutAferCalculation(withView:false)
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        }else{
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
        }
    }
      
}
