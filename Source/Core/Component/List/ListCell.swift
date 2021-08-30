//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ListCell: UITableViewCell {
    var vCount:Int = 0
    var contentNode: ArgoKitCellNode?
    var reusedCellNode: ArgoKitCellNode?
    var sourceData: Any? // 数据源
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        self.contentView.backgroundColor = .clear
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
            if node.frame.equalTo(.zero) || node.isDirty {
                self.contentNode?.applyLayout(size: CGSize(width: self.contentView.frame.width, height: CGFloat.nan))
            }
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
        viewCount(view: self.contentView)
        vCount = 0
    }
    
    func viewCount(view:UIView){
        let count = view.subviews.count
        vCount = vCount + count
        for view_ in view.subviews {
            let count = view_.subviews.count
            if count > 0 {
                viewCount(view: view_)
            }
        }
    }
}
