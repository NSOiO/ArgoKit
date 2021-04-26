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
    @Observable var action: Action = EmptyAction()
    var bag = DisposeBag()
    init() {
        self.$action.watch(type: MainViewAction.self) { action in
            if case let MainViewAction.cellSelected(_, indexPath) = action {
                print("click on ",indexPath.row)
            }
        }.disposed(by: self.bag)



    }
}

