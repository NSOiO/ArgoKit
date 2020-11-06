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
        self.contentNode = ArgoKitNode(view: contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentNode = ArgoKitNode(view: contentView)
    }
    
    override var frame: CGRect {
        didSet {
            self.contentNode?.width(point: frame.width)
            self.contentNode?.height(point: frame.height)
        }
    }
    
    public func linkCellNodes(_ nodes: [ArgoKitNode]) {
        if ((self.contentNode?.childs?.count) != 0) {
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!.childs as! [ArgoKitNode], reuse: nodes);
        } else {
            self.contentNode?.addChildNodes(nodes)
            self.contentNode?.applyLayout()
        }
    }
}
