//
//  GridCell.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation

class GridCellNode: ArgoKitNode {
    
    var cellSourceData: Any?
    
    var frameObserber: NSKeyValueObservation?
    var indexpath:IndexPath = IndexPath(row: 0, section: 0)
    public func observeFrameChanged(changeHandler: @escaping (GridCellNode, NSKeyValueObservedChange<CGRect>) -> Void) {
        removeObservingFrameChanged()
        frameObserber = observe(\.frame, options: .new, changeHandler: changeHandler)
    }
    
    public func removeObservingFrameChanged() {
        if frameObserber != nil {
            frameObserber?.invalidate()
            frameObserber = nil
        }
    }
}

class GridCell: UICollectionViewCell {
  
    var contentNode: GridCellNode?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .green
    }
    
    override func prepareForReuse() {
        ArgoKitNodeViewModifier.prepare(forReuse: self.contentNode)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func linkCellNode(_ node: GridCellNode) {
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
