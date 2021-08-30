//
//  HomeMainViewController.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit

class HomeMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeMainViewModel = homeViewModel()
        let hotingView = UIHostingView(content: homeMainViewModel.makeView(), frame: self.view.bounds, useSafeArea: true)
        view.addSubview(hotingView)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "ArgoKit Demo"
    }
}

extension HomeMainViewController {
    
    private func homeViewModel() -> MainViewModel {
        let model = MainViewModel()
        let cellModel1 = MainCellViewModel()
        cellModel1.title = "Tutorial"
        cellModel1.clickAction = { [weak self] in
            let content = self?.tutorialHomeViewModel().makeView() ?? EmptyView()
            self?.pushToVc(rootView: content, title: cellModel1.title)
        }
        model.datas.append(cellModel1)
        
        let cellModel2 = MainCellViewModel()
        cellModel2.title = "Demo"
        cellModel2.clickAction = { [weak self] in
            let content = self?.demoHomeViewModel().makeView() ?? EmptyView()
            self?.pushToVc(rootView: content, title: cellModel2.title)
        }
        model.datas.append(cellModel2)
        
        return model
    }
    
    private func tutorialHomeViewModel() -> MainViewModel {
        let model = MainViewModel()
        let cellModel1 = MainCellViewModel()
        cellModel1.title = "Lesson 1: Layout Views"
        cellModel1.clickAction = { [weak self] in
            let content = Lesson1ViewModelPreviews().makeView()
            self?.pushToVc(rootView: content, title: cellModel1.title)
        }
        model.datas.append(cellModel1)
        
        let cellModel2 = MainCellViewModel()
        cellModel2.title = "Lesson 2: Binding Data"
        cellModel2.clickAction = {  [weak self] in
            let viewModel = FeedDetailViewModel()
            viewModel.contentImgAciton = {
                AlertView(title: "点击图片", message: nil, preferredStyle: .alert)
                    .default(title: "好的", handler: nil)
                    .show()
            }
            
            viewModel.moreAciton = {
                AlertView(title: "点击更多按钮", message: nil, preferredStyle: .alert)
                    .default(title: "好的", handler: nil)
                    .show()
            }

            viewModel.likeAction = {
                viewModel.isLiked = !viewModel.isLiked
            }

            viewModel.commentAction = {
                viewModel.commentCount += 1
            }
            let content = viewModel.makeView()
            self?.pushToVc(rootView: content, title: cellModel2.title)
        }
        model.datas.append(cellModel2)
        
        let cellModel3 = MainCellViewModel()
        cellModel3.title = "Lesson 3: List"
        cellModel3.clickAction = { [weak self] in
            let content = Lesson3ListModelPreviews().makeView()
            self?.pushToVc(rootView: content, title: cellModel3.title)
        }
        model.datas.append(cellModel3)
        
        let cellModel4 = MainCellViewModel()
        cellModel4.title = "Lesson 4: Grid"
        cellModel4.clickAction = { [weak self] in
            let content = Lesson4GridModelPreviews().makeView()
            self?.pushToVc(rootView: content, title: cellModel4.title)
        }
        model.datas.append(cellModel4)
        
        let cellModel5 = MainCellViewModel()
        cellModel5.title = "Lesson 5: Animaiton"
        cellModel5.clickAction = { [weak self] in
            let content = ArgoKitAnimationModelPreviews().makeView()
            self?.pushToVc(rootView: content, title: cellModel5.title)
        }
        model.datas.append(cellModel5)
        
        let cellModel6 = MainCellViewModel()
        cellModel6.title = "Lesson 6: Add Custom UIView"
        cellModel6.clickAction = { [weak self] in
            let content = Lesson6AddCustomUIViewModelPreviews().makeView()
            self?.pushToVc(rootView: content, title: cellModel6.title)
        }
        model.datas.append(cellModel6)
        
        return model
    }
    
    private func demoHomeViewModel() -> MainViewModel {
        let model = MainViewModel()
        let titleArray = ["List", "Grid", "ScrollView", "Button", "AlertView", "TextField", "TextView", "Toggle", "Stepper", "DatePicker", "Gesture", "Animation"]
        
        for title in titleArray {
            let cellModel = MainCellViewModel()
            cellModel.title = title
            cellModel.clickAction = demoListClickAciton(title)
            model.datas.append(cellModel)
        }
        
        return model
    }
    
    private func pushToVc(rootView : View, title: String?) {
        let vc = UIHostingController(rootView: rootView, useSafeArea: true)
        vc.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func demoListClickAciton(_ title: String) -> (() -> ()) {
        let action = { [weak self] in
            guard let `self` = self else { return }
            var content: View = EmptyView()
            if title == "List" {
                content = ActivityFeedModel_Previews().makeView()
            }
            
            if title == "Grid" {
                content = Lesson4GridModelPreviews().makeView()
            }
            
            if title == "ScrollView" {
                content = ArgoKitScrollViewModelPreviews().makeView()
            }
            
            if title == "Toggle" {
                content = ArgoKitToggleModelPreviews().makeView()
            }
            
            if title == "Stepper" {
                content = ArgoKitStepperModelPreviews().makeView()
            }
            
            if title == "AlertView" {
                content = ArgoKitAlertViewModelPreviews().makeView()
            }
            
            if title == "DatePicker" {
                content = ArgoKitDatePickerModelPreviews().makeView()
            }
            
            if title == "Gesture" {
                content = ArgoKitGestureModelPreviews().makeView()
            }
            
            if title == "TextField" {
                content = ArgoKitTextFieldModelPreviews().makeView()
            }
            
            if title == "TextView" {
                content = ArgoKitTextViewModelPreviews().makeView()
            }
            
            if title == "Button" {
                content = ArgoKitButtonModelPreviews().makeView()
            }
            
            if title == "Animation" {
                content = ArgoKitAnimationModelPreviews().makeView()
            }
        
            self.pushToVc(rootView: content, title: title)
        }
        return action
    }
}
