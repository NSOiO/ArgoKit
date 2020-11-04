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
        
        self.contentNode = ArgoKitNode(view: contentView)
        
        self.contentNode?.width(point: contentView.frame.size.width)
        self.contentNode?.height(point: contentView.frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.contentNode = ArgoKitNode(view: contentView)
        self.contentNode?.width(point: contentView.frame.size.width)
        self.contentNode?.height(point: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentNode?.removeAllChildNodes()
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {
        
        self.contentNode?.addChildNode(node)
        ArgoLayoutHelper.addLayoutNode(self.contentNode);
    }
}
