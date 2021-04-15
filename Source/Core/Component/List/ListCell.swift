//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ListCell: UITableViewCell {
    var contentNode: ArgoKitCellNode?
    var sourceData: Any? // 数据源
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 清空视图属性
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceData = nil
        ArgoKitNodeViewModifier.prepare(forReuse: self.contentNode)
    }
    
    func linkCellNode(_ node: ArgoKitCellNode,isReused:Bool) {
        if node.isPreviewing {
            node.bindView(self.contentView)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
            ArgoKitReusedLayoutHelper.addLayoutNode(node)
            return
        }
        if isReused {
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
