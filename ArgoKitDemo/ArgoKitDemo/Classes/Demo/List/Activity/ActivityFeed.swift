//
//  ActivityFeed.swift
//  ArgoKitTutorial
//
//  Created by Bruce on 2021/6/22.
//

import ArgoKit

// view model.
protocol ActivityFeedModelProtocol: ViewModelProtocol {
    var dataSource:DataSource<DataList<ActivityFeedThem1CellModelProtocol>> {get set}
}

// view
struct ActivityFeed: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ActivityFeedModelProtocol
    init(model: ActivityFeedModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.dataSource) { data in
            data.makeView()
        }
    }
}

extension ActivityFeedModelProtocol {
    func makeView() -> ArgoKit.View {
        ActivityFeed(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ActivityFeedModel_Previews:  ActivityFeedModelProtocol {
    var dataSource: DataSource<DataList<ActivityFeedThem1CellModelProtocol>>
    init() {
        dataSource = DataSource(DataList<ActivityFeedThem1CellModelProtocol>())
        for _ in 0 ... 20{
            dataSource.append(ActivityFeedThem1CellModel_Previews())
        }
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
struct ActivityFeed_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ActivityFeedModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

