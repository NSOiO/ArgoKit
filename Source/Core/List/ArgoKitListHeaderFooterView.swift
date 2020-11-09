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
        
        node.removeFromSuperNode()
        self.contentNode?.addChildNode(node)
        self.contentNode?.applyLayout()
    }
}
