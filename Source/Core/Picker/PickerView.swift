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
        self.node?.width(point: pickerView.frame.width)
        self.node?.height(point: pickerView.frame.height)
    }
    
    public init(@ArgoKitViewBuilder content: () -> View) {
        self.init()
        let container = content()
        if let nodes = container.type.viewNodes() {
            self.pNode.nodeList = [nodes]
        }
    }

    public init(_ data: [Any], @ArgoKitViewBuilder rowContent: @escaping (Any) -> View) {
        self.init()
        if (data.first as? Array<Any>) != nil {
            self.pNode.dataList = data as? [[Any]]
        } else {
            self.pNode.dataList = [data]
        }
        self.pNode.buildNodeFunc = rowContent
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
        self.pNode.setNodeActionBlock(pickerView) { items in
            if items.count >= 2 {
                let row: Int = items[0] as? Int ?? 0
                let component: Int = items[1] as? Int ?? 0
                action(row, component)
            }
        }
        return self
    }
}
