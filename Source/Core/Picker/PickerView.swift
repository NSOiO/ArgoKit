//
//  PickerView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

public struct PickerView : View {
    
    private var pickerView : UIPickerView
    private var pNode : ArgoKitPickerNode
    
    public var body: View {
        self
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
    
    public init(@ArgoKitViewBuilder content: () -> View) {
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            self.pNode.dataSourceHelper.nodeList = [nodes]
        }
    }

    public init<T>(_ data: [T], @ArgoKitViewBuilder rowContent: @escaping (Any) -> View) where T:ArgoKitModelProtocol{
        self.init()
        if (data.first as? Array<Any>) != nil {
            self.pNode.dataSourceHelper.dataList = data as? [[ArgoKitModelProtocol]]
        } else {
            self.pNode.dataSourceHelper.dataList = [data]
        }
        self.pNode.dataSourceHelper.buildNodeFunc = rowContent
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
    
    public func didSelectRowInComponent(_ action: @escaping (_ row: Int, _ component: Int)->Void) -> Self {
        self.pNode.observeAction(pickerView) { target, paramter in
            if paramter?.count ?? 0 >= 2 {
                let row: Int = paramter![0] as? Int ?? 0
                let component: Int = paramter![1] as? Int ?? 0
                action(row, component)
            }
            return nil
        }
        return self
    }
}
