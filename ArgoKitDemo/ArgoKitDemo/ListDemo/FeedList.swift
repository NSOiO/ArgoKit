//
//  FeedList.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
protocol FeedListModelProtocol: ViewModelProtocol {
    var name: String { get }
    var dataSource: DataSource<[FeedBaseProtocol]> { get }
}

// view
struct FeedList: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: FeedListModelProtocol
    init(model: FeedListModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.dataSource) { cellModel in
            cellModel.makeView()
                .padding(edge: .bottom, value: 10)
        }
        .height(100%)
    }
}

extension FeedListModelProtocol {
    func makeView() -> ArgoKit.View {
        FeedList(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class FeedListModel_Previews:  FeedListModel {
    override init() {
        super.init()
        var datas = [FeedBaseProtocol]()
        for idx in 0..<10 {
            datas.append(FeedCellModel_Previews())
            let ad = ADCellModel_Previews(action: self.$action)
            ad.isFavorite = idx % 2 == 1
            datas.append(ad)
        }
        self.dataSource.append(contentsOf: datas)
        self.addListener()
    }
    
    func addListener() {
        self.$action.watchAction(type: CellBaseAction.self) { action in
            switch action {
            case .tapIcon(let model):
                print("tap ",model.icon)
                model.isFavorite.toggle()
                break
            case .longPressIcon(let model):
                print("long press ",model.icon)
                break
            }
        }.disposed(by: self.bag)
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
struct FeedList_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                FeedList(model: FeedListModel_Previews())
                    .padding(edge: .horizontal, value: 10)
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
