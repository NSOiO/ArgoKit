//
//  ActivityFeedThem1Cell.swift
//  ArgoKitTutorial
//
//  Created by Bruce on 2021/6/22.
//

import ArgoKit

// view model.
protocol ActivityFeedThem1CellModelProtocol: ViewModelProtocol {
    var headViewMode:ActivityFeedHeadViewModelProtocol{get set}
    var footViewMode:ActivityFeedFootViewModelProtocol{get set}
    var contentViewMode:ActivityFeedCellContentModelProtocol{get set}
}

// view
struct ActivityFeedThem1Cell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ActivityFeedThem1CellModelProtocol
    init(model: ActivityFeedThem1CellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        model.headViewMode.makeView()
        model.contentViewMode.makeView()
            .margin(edge: .top, value: 8.0)
        model.footViewMode.makeView().margin(edge: .top, value: 15.0)
        
        EmptyView().backgroundColor(red: 249, green: 249, blue: 249)
            .height(4.0)
            .margin(edge: .top, value: 13.0)
    }
}

extension ActivityFeedThem1CellModelProtocol {
    func makeView() -> ArgoKit.View {
        ActivityFeedThem1Cell(model: self)
            .margin(edge: .left, value: 15.0)
            .margin(edge: .right, value: 15.0)
            .margin(edge: .top, value: 15.0)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ActivityFeedThem1CellModel_Previews:  ActivityFeedThem1CellModelProtocol {
    var headViewMode:ActivityFeedHeadViewModelProtocol
    var footViewMode:ActivityFeedFootViewModelProtocol
    var contentViewMode:ActivityFeedCellContentModelProtocol
    init() {
        headViewMode = ActivityFeedHeadViewModel_Previews()
        footViewMode = ActivityFeedFootViewModel_Previews()
        contentViewMode = ActivityFeedCellContentModel_Previews()
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
struct ActivityFeedThem1Cell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ActivityFeedThem1CellModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

