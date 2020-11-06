//
//  ArgoKitListCell.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

class ArgoKitListCell: UITableViewCell {
  
    public var contentNode: ArgoKitNode?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.contentNode = ArgoKitNode(view: contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentNode = ArgoKitNode(view: contentView)
    }
    
    deinit {
        self.contentNode?.removeAllChildNodes()
        self.contentNode = nil
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentNode?.removeAllChildNodes()
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {
        self.contentNode?.addChildNode(node)
        node.applyLayout()
    }
}
