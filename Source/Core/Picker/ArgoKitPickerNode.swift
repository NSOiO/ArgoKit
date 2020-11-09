//
//  ArgoKitPickerNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitPickerRowView: UIView {
    
    var contentNode: ArgoKitNode?
    
    override var frame: CGRect {
        didSet {
            self.contentNode?.width(point: frame.width)
            self.contentNode?.height(point: frame.height)
        }
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {

        if ((self.contentNode?.childs?.count) != 0) {
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!.childs as? [ArgoKitNode], reuse: [node]);
        } else {
            self.contentNode?.addChildNode(node)
            self.contentNode?.applyLayout(size: CGSize(width: node.width(), height: node.height()))
        }
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
        if let width = self.dataSourceHelper.nodeForRow(0, at: component)?.width() {
            if !width.isNaN {
                return width
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if let height = self.dataSourceHelper.nodeForRow(0, at: component)?.height() {
            if !height.isNaN {
                return height
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let node = self.dataSourceHelper.nodeForRow(row, at: component) {
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
