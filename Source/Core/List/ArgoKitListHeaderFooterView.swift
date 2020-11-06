//
//  ArgoKitListHeaderFooterView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/11/5.
//

import Foundation

class ArgoKitListHeaderFooterView: UITableViewHeaderFooterView {
  
    var contentNode: ArgoKitNode?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentNode = ArgoKitNode(view: contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentNode = ArgoKitNode(view: contentView)
        self.contentNode?.width()
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
