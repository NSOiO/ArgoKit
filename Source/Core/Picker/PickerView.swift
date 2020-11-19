//
//  PickerView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public class PickerView<T>: View {
    
    private var pickerView : UIPickerView
    private var pNode : ArgoKitPickerNode
    
    public var body: View {
        ViewEmpty()
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    private init() {
        pickerView = UIPickerView();
        pNode = ArgoKitPickerNode(view: pickerView)
    }
    
    public convenience init(_ data: [T], @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.dataList = [data]
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    public convenience init(_ data: [[T]], @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.dataList = data
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
}

extension PickerView {
    
    public func reloadAllComponents() -> Self {
        pNode.reloadAllComponents()
        return self
    }
    
    public func reloadComponent(_ value: Int) -> Self {
        pNode.reloadComponent(value)
        return self
    }
    
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) -> Self {
        pickerView.selectRow(row, inComponent: component, animated: animated)
        return self
    }
    
    public func didSelectRowInComponent(_ action: @escaping (_ data: T, _ row: Int, _ component: Int) -> Void) -> Self {
        self.pNode.observeAction(pickerView) { target, paramter in
            if paramter?.count ?? 0 >= 3 {
                let data: T = paramter![0] as! T
                let row: Int = paramter![1] as! Int
                let component: Int = paramter![2] as! Int
                action(data, row, component)
            }
            return nil
        }
        return self
    }
}
