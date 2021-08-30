//
//  Lesson4Grid.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/14.
//

import ArgoKit

// view model.
protocol Lesson4GridModelProtocol: ViewModelProtocol {
    var dataSource: DataSource<[Lesson4GridCellModelProtocol]> {get set}
}

// view
struct Lesson4Grid: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson4GridModelProtocol
    init(model: Lesson4GridModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Grid(waterfall: true,
             data: model.dataSource) { cellViewModel in
            cellViewModel.makeView()
        }
        .sectionHeader(headerContent: {
            Lesson4GridHeaderViewModelPreviews().makeView()
        })
        .columnCount(2)
        .lineSpacing(20)
        .columnSpacing(7)
        .layoutInset(top: 7, left: 15, bottom: 0, right: 15)
    }
}

extension Lesson4GridModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson4Grid(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson4GridModelPreviews: Lesson4GridModelProtocol {
    var dataSource: DataSource<[Lesson4GridCellModelProtocol]> = DataSource([Lesson4GridCellModelPreviews]())
    
    var titleStrs = ["夏日炎炎，有你真甜！甜到你了吗？",
                     "后备箱需要装备什么？",
                     "周末地毯开箱vol.3「徕卡M10-P & VM35/2」",
                     "夏装推荐-短袖短裤穿呼起来🔥"]
    
    init() {
        for index in 0...30 {
            let model = Lesson4GridCellModelPreviews()
            model.imgStr = "img_avatar_" + "\(index % 10)"
            model.titleStr = titleStrs[index % 4]
            model.detailStr = "index: " + "\(index)"
            dataSource.append(model)
        }
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
private func argoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct Lesson4GridPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11, .iPhone8]) { item in
            argoKitRender {
                Lesson4GridModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

