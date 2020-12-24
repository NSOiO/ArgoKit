//
//  PickerView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

/// Wrapper of UIPickerView.
///
///A view that uses a spinning-wheel or slot-machine metaphor to show one or more sets of values.
///```
/// PickerView(["1","2","3","4","5"]){item in
///       Text(item)
///  }
///  .width(100)
///  .height(200)
///  .backgroundColor(.yellow)
///```
public struct PickerView<T>: View {
    
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
    
    /// init the PickerView
    /// - Parameters:
    ///   - data: data source of the picker view
    ///   - rowContent: View Builder for the picker view
    public init(_ data: [T], @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.dataList = [data]
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
    
    /// init the PickerView
    /// - Parameters:
    ///   - data: data source of the picker view
    ///   - rowContent: View Builder for the picker view
    public init(_ data: [[T]], @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.dataList = data
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item as! T)
        }
    }
}

extension PickerView {
    
    /// reload all components of the picker view
    ///
    /// Calling this method causes the picker view to query the delegate for new data for all components.
    /// - Parameter data: the new data source
    /// - Returns: Self
    @discardableResult
    public func reloadAllComponents(_ data: [[T]]?) -> Self {
        pNode.reloadAllComponents(data)
        return self
    }
    
    /// Reloads a particular component of the picker view.
    ///
    /// Calling this method causes the picker view to query the delegate for new data for the given component.
    /// - Parameters:
    ///   - data: the new data source
    ///   - component: A zero-indexed number identifying a component of the picker view.
    /// - Returns: Self
    @discardableResult
    public func reloadComponent(_ data: [Any]?, inComponent component: Int) -> Self {
        pNode.reloadComponent(data, inComponent:component)
        return self
    }
    
    /// A zero-indexed number identifying a component of the picker view.
    ///
    /// - Parameters:
    ///   - row: A zero-indexed number identifying a row of component.
    ///   - component: A zero-indexed number identifying a component of the picker view.
    ///   - animated: true to animate the selection by spinning the wheel (component) to the new value; if you specify false, the new selection is shown immediately.
    /// - Returns: Self
    @discardableResult
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) -> Self {
        pickerView.selectRow(row, inComponent: component, animated: animated)
        return self
    }
    
    /// set the callback called when the row is selected
    /// - Parameter action: the callback
    /// - Returns: Self
    @discardableResult
    public func didSelectRow(_ action: @escaping (_ data: T, _ row: Int, _ component: Int) -> Void) -> Self {
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
