//
//  PickerView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public struct PickerView : View {
    
    private var pickerView : UIPickerView
    private var pNode : ArgoKitNode
    
    public var body: View {
        self
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init() {
        self.init(nil, delegate: nil)
    }
    
    public init(_ dataSource: UIPickerViewDataSource?, delegate: UIPickerViewDelegate?) {
        pickerView = UIPickerView();
        pNode = ArgoKitNode(view: pickerView)
        pickerView.dataSource = dataSource
        pickerView.delegate = delegate
    }
}

extension PickerView {
    
    public func dataSource(_ value: UIPickerViewDataSource?) -> Self {
        pickerView.dataSource = value
        return self
    }
    
    public func delegate(_ value: UIPickerViewDelegate?) -> Self {
        pickerView.delegate = value
        return self
    }
    
    public func reloadAllComponents() -> Self {
        pickerView.reloadAllComponents()
        return self
    }
    
    public func reloadComponent(_ value: Int) -> Self {
        pickerView.reloadComponent(value)
        return self
    }
    
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) -> Self {
        pickerView.selectRow(row, inComponent: component, animated: animated)
        return self
    }
}
