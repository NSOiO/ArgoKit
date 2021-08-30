//
//  HomeMainView.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-27.
//

import ArgoKit

// view model.
protocol MainViewModelProtocol: ViewModelProtocol {
    var datas: DataSource<[MainCellViewModel]> { get }
}

// view
struct HomeMainView: ArgoKit.ViewProtocol {
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: MainViewModelProtocol
    init(model: MainViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.datas) { cellModel in
            cellModel.makeView()
                .height(50)
                .margin(edge: .left, value: 20)
        }
        .height(100%)
        .cellSelected { (cellModel, indexPath) in
            cellModel.clickAction()
        }
        .separatorStyle(.singleLine)
        .tableFooterView { () -> View? in
            EmptyView() }
    }
}

extension MainViewModelProtocol {
    func makeView() -> ArgoKit.View {
        HomeMainView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class MainViewModel_Previews: MainViewModelProtocol {
    var datas = DataSource([MainCellViewModel]())
    init() {
        let cellViewModel = MainCellViewModel()
        cellViewModel.title = "List"
        datas.append(cellViewModel)
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct MainView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                HomeMainView(model: MainViewModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
