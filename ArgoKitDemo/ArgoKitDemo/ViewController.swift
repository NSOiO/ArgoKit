//
//  ViewController.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit

class ViewController: UIViewController {
    var bag = DisposeBag()
    override func viewDidLoad() {
        
        let model = MainViewModel()
        let cellModel = MainCellModel()
        cellModel.title = "ListDemo"
        model.$action.watch { [weak self] new in
            if let action = new as? MainViewAction {
                if case let MainViewAction.cellSelected(cellModel, _) = action {
                    if cellModel.title == "ListDemo" {
                        let content = FeedListModel_Previews().makeView().padding(edge: .horizontal, value: 10)
                        let vc = UIHostingController(rootView: content, useSafeArea: true)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        .disposed(by: self.bag)
        
        model.datas.append(cellModel)
        
        let view = UIHostingView(content: model.makeView(), frame: self.view.bounds, useSafeArea: true)
        self.view.addSubview(view)
        super.viewDidLoad()
    }
}
