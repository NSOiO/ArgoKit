//
//  MainViewModel.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-27.
//

import ArgoKit

class MainCellViewModel: ViewModelProtocol {
    @Observable var title: String = ""
    func makeView() -> View {
        Text(self.title)
    }
    var clickAction: () -> () = {}
}

// view model.
class MainViewModel: MainViewModelProtocol {
    var datas = DataSource([MainCellViewModel]())
}

