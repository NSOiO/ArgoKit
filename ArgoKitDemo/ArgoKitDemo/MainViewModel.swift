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
    @Observable var action: Action = Empty()
    var bag = DisposeBag()
    init() {
        self.$action.watch { new in
            if let action = new as? MainViewAction {
                if case let MainViewAction.cellSelected(_, indexPath) = action {
                    print("click on ",indexPath.row)
                }
            }
        }.disposed(by: self.bag)
    }
}

