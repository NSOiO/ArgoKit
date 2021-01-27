//
//  MainView.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-27.
//

import ArgoKit

enum MainViewAction: Action {
    case cellSelected(MainCellModel, IndexPath)
}

// view model.
protocol MainViewModelProtocol: ViewModelProtocol {
    var datas: DataSource<[MainCellModel]> { get }
    var action:Action { get set }
}

// view
struct MainView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: MainViewModelProtocol
    init(model: MainViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.datas) { cellModel in
            cellModel.makeView()
        }
        .height(100%)
        .cellSelected { (cellModel, indexPath) in
            model.action = MainViewAction.cellSelected(cellModel, indexPath)
        }
        
    }
}

extension MainViewModelProtocol {
    func makeView() -> ArgoKit.View {
        MainView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class MainViewModel_Previews:  MainViewModel {
    override init() {
        super.init()
        let model = MainCellModel()
        model.title = "ListDemo"
        self.datas.append(model)
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
                MainView(model: MainViewModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
