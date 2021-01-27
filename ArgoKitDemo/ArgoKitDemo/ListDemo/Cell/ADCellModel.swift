//
//  ADCellModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
class ADCellModel: ADCellModelProtocol {
    
    @Property var action: Action = Empty()
    @Property var isFavorite: Bool = false
    
    var title: String = ""
    var icon: String = ""
    
}

