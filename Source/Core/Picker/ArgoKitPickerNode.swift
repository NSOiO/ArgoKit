//
//  ArgoKitPickerNode.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

import Foundation

class ArgoKitPickerNode: ArgoKitDataSourceNode, UIPickerViewDataSource, UIPickerViewDelegate {

    public var pickerView : UIPickerView? {
        
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
        self.nodeCahe?.removeAllObjects()
        self.pickerView?.reloadAllComponents()
    }

    open func reloadComponent(_ component: Int) {
        self.nodeCahe?.removeAllObjects()
        self.pickerView?.reloadComponent(component)
    }
}

extension ArgoKitPickerNode {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfSection()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numberOfRowsInSection(section: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if let node = self.nodeForRowAtSection(0, at: component) {
            //TODO
//            return node.width()
            return 100
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if let node = self.nodeForRowAtSection(0, at: component) {
            //TODO
//            return node.height()
            return 44
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // TODO 不能正常展示
        if let node = self.nodeForRowAtSection(row, at: component) {
            return node.view ?? view ?? UIView()
        }
        return view ?? UIView()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.nodeAction(pickerView,paramter: [row,component])
    }
}
