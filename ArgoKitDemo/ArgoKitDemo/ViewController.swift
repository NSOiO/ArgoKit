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
        model.$action.watch { [weak self] new in
            if let action = new as? MainViewAction {
                if case let MainViewAction.cellSelected(cellModel, _) = action {
                    if cellModel.title == "ListDemo" {
//                        let content = ArgoKitGridTest(model: ArgoKitGridTestModel())
                        let content = ListDemo()//ArgoKitTextTest(model: ArgoKitTextTestModel())//FeedListModel_Previews().makeView().padding(edge: .horizontal, value: 10)
                        let vc = UIHostingController(rootView: content, useSafeArea: true)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    if cellModel.title == "GrideDemo" {
                        let content = ArgoKitGridTest(model: ArgoKitGridTestModel())
                        let vc = UIHostingController(rootView: content, useSafeArea: true)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    if cellModel.title == "TextDemo" {
                        let content = ArgoKitTextTest(model: ArgoKitTextTestModel())
                        let vc = UIHostingController(rootView: content, useSafeArea: true)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        .disposed(by: self.bag)
        
        let cellModel1 = MainCellModel()
        cellModel1.title = "ListDemo"
        model.datas.append(cellModel1)
        
        let cellModel2 = MainCellModel()
        cellModel2.title = "GrideDemo"
        model.datas.append(cellModel2)
        
        let cellModel3 = MainCellModel()
        cellModel3.title = "TextDemo"
        model.datas.append(cellModel3)
        
        let view = UIHostingView(content: model.makeView(), frame: self.view.bounds, useSafeArea: true)
        self.view.addSubview(view)
        super.viewDidLoad()
    }
}
