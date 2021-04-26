//
//  PickerView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/28.
//

import Foundation

/// Wrapper of UIPickerView.
///
/// A view that uses a spinning-wheel or slot-machine metaphor to show one or more sets of values.
///
///```
///         PickerView($pickerData) { item in
///             Text(item).grow(1).textAlign(.center)
///         }
///         .width(100%)
///         .height(50)
///         .widthForComponent({ (component) -> Float in
///             return 50
///         })
///         .rowHeightForComponent({ (component) -> Float in
///             return 44
///         })
///         .didSelectRow({ (text, row, component) in
///             // Did select action
///         })
///```
public struct PickerView<T>: View {
    
    private var pickerView: UIPickerView
    private var pNode: PickerNode<T>
    
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
        pNode = PickerNode(view: pickerView)
    }
    
    /// init the PickerView
    /// - Parameters:
    ///   - data: data source of the picker view
    ///   - rowContent: View Builder for the picker view
    public init(_ data: DataSource<DataList<T>>, @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.dataSourceList = data
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
    
    /// init the PickerView
    /// - Parameters:
    ///   - data: data source of the picker view
    ///   - rowContent: View Builder for the picker view
    public init(_ data: DataSource<SectionDataList<T>>, @ArgoKitViewBuilder rowContent: @escaping (T) -> View) {
        self.init()
        self.pNode.dataSourceHelper.sectionDataSourceList = data
        self.pNode.dataSourceHelper.buildNodeFunc = { item in
            return rowContent(item)
        }
    }
}

extension PickerView {
    
    /// reload all components of the picker view
    ///
    /// Calling this method causes the picker view to query the delegate for new data for all components.
    /// - Parameter data: the new data source
    /// - Returns: self
    @discardableResult
    public func reloadAllComponents() -> Self {
        pNode.reloadData()
        return self
    }
    
    /// Reloads a particular component of the picker view.
    ///
    /// Calling this method causes the picker view to query the delegate for new data for the given component.
    /// - Parameters:
    ///   - data: the new data source
    ///   - component: A zero-indexed number identifying a component of the picker view.
    /// - Returns: self
    @discardableResult
    public func reloadComponent(_ component: Int) -> Self {
        pNode.reloadComponent(component)
        return self
    }
    
    /// A zero-indexed number identifying a component of the picker view.
    ///
    /// - Parameters:
    ///   - row: A zero-indexed number identifying a row of component.
    ///   - component: A zero-indexed number identifying a component of the picker view.
    ///   - animated: true to animate the selection by spinning the wheel (component) to the new value; if you specify false, the new selection is shown immediately.
    /// - Returns: self
    @discardableResult
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) -> Self {
        pickerView.selectRow(row, inComponent: component, animated: animated)
        return self
    }
    
    /// set the callback called when it needs the row width to use for drawing row content.
    /// - Parameter action: the callback
    /// - Returns: Self
    @discardableResult
    public func widthForComponent(_ action: @escaping (_ component: Int) -> Float) -> Self {
        let sel = #selector(PickerNode<T>.pickerView(_:widthForComponent:))
        self.pNode.observeAction(String(_sel: sel)) { target, paramter in
            if paramter?.count ?? 0 >= 1,
               let component = paramter![0] as? Int {
                return action(component)
            }
            return 0
        }
        return self
    }
    
    /// set the callback called when it needs the row height to use for drawing row content.
    /// - Parameter action: the callback
    /// - Returns: Self
    @discardableResult
    public func rowHeightForComponent(_ action: @escaping (_ component: Int) -> Float) -> Self {
        let sel = #selector(PickerNode<T>.pickerView(_:rowHeightForComponent:))
        self.pNode.observeAction(String(_sel: sel)) { target, paramter in
            if paramter?.count ?? 0 >= 1,
               let component = paramter![0] as? Int {
                return action(component)
            }
            return 0
        }
        return self
    }
    
    /// set the callback called when the row is selected
    /// - Parameter action: the callback
    /// - Returns: self
    @discardableResult
    public func didSelectRow(_ action: @escaping (_ data: T, _ row: Int, _ component: Int) -> Void) -> Self {
        let sel = #selector(PickerNode<T>.pickerView(_:didSelectRow:inComponent:))
        self.pNode.observeAction(String(_sel: sel)) { target, paramter in
            if paramter?.count ?? 0 >= 3,
               let data = paramter![0] as? T,
               let row = paramter![1] as? Int,
               let component = paramter![2] as? Int {
                action(data, row, component)
            }
            return nil
        }
        return self
    }
}
