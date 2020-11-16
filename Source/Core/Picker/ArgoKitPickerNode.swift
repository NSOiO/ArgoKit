//
//  ArgoKitPickerNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitPickerRowView: UIView {
    
    var contentNode: ArgoKitNode?
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = UIView(frame: self.bounds)
        contentView?.backgroundColor = .red
        addSubview(contentView!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView = UIView(frame: self.bounds)
        contentView?.backgroundColor = .red
        addSubview(contentView!)
    }
    
    override var frame: CGRect {
        didSet {
            contentView?.frame = self.bounds
        }
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {
        if node.size.width == 0 || node.size.height == 0 {
            node.calculateLayout(size: CGSize(width: node.width(), height: node.height()))
        }
        if self.contentView?.subviews.count != 0 && self.contentNode != nil {
            if node.frame.equalTo(.zero) {
                node.applyLayoutAferCalculationWithoutView()
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        } else {
            node.bindView(self.contentView!)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation()
        }
        ArgoReusedLayoutHelper.addLayoutNode(node)
    }
}

class ArgoKitPickerNode: ArgoKitNode, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var dataSourceHelper: ArgoKitDataSourceHelper = ArgoKitDataSourceHelper()

    public var pickerView: UIPickerView? {
        
        if let pickerView = self.view as? UIPickerView {
            return pickerView
        }
        return nil
    }
        
    override init(view: UIView) {
        super.init(view: view)
        if let pickerView = view as? UIPickerView {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
}

extension ArgoKitPickerNode {
    
    open func reloadAllComponents() {
        self.dataSourceHelper.removeAllCache()
        self.pickerView?.reloadAllComponents()
    }

    open func reloadComponent(_ component: Int) {
        self.dataSourceHelper.removeAllCache()
        self.pickerView?.reloadComponent(component)
    }
}

extension ArgoKitPickerNode {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataSourceHelper.numberOfSection()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSourceHelper.numberOfRows(section: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if let node = self.dataSourceHelper.nodeForRow(0, at: component) {
            if node.size.width == 0 || node.size.height == 0 {
                node.calculateLayout(size: CGSize(width: CGFloat.nan, height: CGFloat.nan))
            }
            return node.size.width
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if let node = self.dataSourceHelper.nodeForRow(0, at: component) {
            if node.size.width == 0 || node.size.height == 0 {
                node.calculateLayout(size: CGSize(width: CGFloat.nan, height: CGFloat.nan))
            }
            return node.size.height
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // TODO: 有bug
        if let node = self.dataSourceHelper.nodeForRowNoCache(row, at: component) {
            let rowView = view as? ArgoKitPickerRowView ?? ArgoKitPickerRowView()
            rowView.linkCellNode(node)
            return rowView
        }
        return view ?? ArgoKitPickerRowView()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sendAction(withObj: pickerView, paramter: [row,component])
    }
}
