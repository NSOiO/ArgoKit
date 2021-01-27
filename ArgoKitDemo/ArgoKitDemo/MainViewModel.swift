//
//  MainViewModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-27.
//

import ArgoKit

class MainCellModel: ViewModelProtocol {
    var title: String = ""
    func makeView() -> View {
        Text(self.title)
    }
}

// view model.
class MainViewModel: MainViewModelProtocol {
    var datas = DataSource([MainCellModel]())
    @Property var action: Action = None()
}

