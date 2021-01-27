//
//  ADCellModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

enum CellBaseAction: Action {
    case tapIcon(ADCellModelProtocol)
    case longPressIcon(ADCellModelProtocol)
}

// view model.
class ADCellModel: ADCellModelProtocol {
    
    @Observable var action: Action = EmptyAction()
    @Observable var isFavorite: Bool = false
    
    var title: String = ""
    var icon: String = ""
    
    init() {}
    init(action: Observable<Action>) {
        self._action = action
    }
    
    func tapIcon() {
        self.action = CellBaseAction.tapIcon(self)
    }
    
    func longPressIcon() {
        self.action = CellBaseAction.longPressIcon(self)
    }
}

