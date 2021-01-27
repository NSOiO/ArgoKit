//
//  PickerNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

func calculateLayoutSize(_ node: ArgoKitNode) -> CGSize {
    let width = node.width() > 0 ? node.width() : CGFloat.nan
    let heigth = node.height() > 0 ? node.height() : CGFloat.nan
    return CGSize(width: width, height: heigth)
}

class ArgoKitPickerRowView: UIView {
    
    var contentNode: ArgoKitNode?
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = UIView(frame: self.bounds)
        addSubview(contentView!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView = UIView(frame: self.bounds)
        addSubview(contentView!)
    }
    
    override var frame: CGRect {
        didSet {
            contentView?.frame = self.bounds
        }
    }
    
    public func linkCellNode(_ node: ArgoKitNode) {
        if node.size.width == 0 || node.size.height == 0 {
            let size = calculateLayoutSize(node)
            node.calculateLayout(size: size)
        }
        if self.contentView?.subviews.count != 0 && self.contentNode != nil {
            if node.frame.equalTo(.zero) {
                node.applyLayoutAferCalculation(withView:false)
            }
            ArgoKitNodeViewModifier.reuseNodeViewAttribute(self.contentNode!, reuse: node)
        } else {
            node.bindView(self.contentView!)
            self.contentNode = node
            self.contentNode?.applyLayoutAferCalculation(withView: true)
        }
        ArgoKitReusedLayoutHelper.addLayoutNode(node)
    }
}

class PickerNode<D>: ArgoKitNode, UIPickerViewDataSource, UIPickerViewDelegate, DataSourceReloadNode {

    

    
    
    lazy var dataSourceHelper:DataSourceHelper<D> = {
        let _dataSourceHelper = DataSourceHelper<D>()
        _dataSourceHelper._rootNode = self
        return _dataSourceHelper
    }()

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
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let pickerView = UIPickerView(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataSourceHelper.numberOfSection()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSourceHelper.numberOfRows(section: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let sel = #selector(self.pickerView(_:widthForComponent:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [component]) as? CGFloat ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let sel = #selector(self.pickerView(_:rowHeightForComponent:))
        return self.sendAction(withObj: String(_sel: sel), paramter: [component]) as? CGFloat ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 有bug view 始终是nil 没有复用
        if let node = self.dataSourceHelper.nodeForRowNoCache(row, at: component) {
            let width = self.pickerView(pickerView, widthForComponent: component)
            let rowHeight = self.pickerView(pickerView, rowHeightForComponent: component)
            node.width(point: width)
            node.height(point: rowHeight)
            let rowView = view as? ArgoKitPickerRowView ?? ArgoKitPickerRowView()
            rowView.linkCellNode(node)
            return rowView
        }
        return view ?? ArgoKitPickerRowView()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let node = self.dataSourceHelper.dataForRow(row, at: component) {
            let sel = #selector(self.pickerView(_:didSelectRow:inComponent:))
            self.sendAction(withObj: String(_sel: sel), paramter: [node, row, component])
        }
    }
    
    // MARK: - DataSourceReloadNode
    func reloadComponent(_ component: Int) {
        self.pickerView?.reloadComponent(component)
    }
    
    func reloadData() {
        self.pickerView?.reloadAllComponents()
    }
    
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func moveSection(_ section: Int, toSection newSection: Int) {
        self.pickerView?.reloadAllComponents()
    }
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        self.pickerView?.reloadAllComponents()
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        self.pickerView?.reloadAllComponents()
    }
    
    func removeNode(_ node: Any?) {
        dataSourceHelper.removeNode(node)
    }
    
    func removeAll() {
        dataSourceHelper.removeAll()
    }
}
