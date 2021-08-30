//
//  Lesson4GridHeaderView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/15.
//

import ArgoKit

// view model.
protocol Lesson4GridHeaderViewModelProtocol: ViewModelProtocol {
    var dataSource: DataSource<[Lesson4GridHeaderCellModelProtocol]> {get set}
}

// view
struct Lesson4GridHeaderView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson4GridHeaderViewModelProtocol
    init(model: Lesson4GridHeaderViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Grid(data: model.dataSource) { cellViewModel in
                cellViewModel.makeView()
            }
            .height(112.5)
            .scrollDirection(.horizontal)
            .bounceVertical(false)
            .showsHorizontalScrollIndicator(false)
            .layoutInset(top: 0, left: 15, bottom: 0, right: 15)
            .lineSpacing(25.5)
            .cellItemWith { cellViewModel, indexPath in
                return 67
            }
            
            EmptyView()
                .height(0.5)
                .backgroundColor(red: 235, green: 235, blue: 235)
                .margin(edge: .horizontal, value: 15)
        }
    }
}

extension Lesson4GridHeaderViewModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson4GridHeaderView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson4GridHeaderViewModelPreviews: Lesson4GridHeaderViewModelProtocol {
    var dataSource: DataSource<[Lesson4GridHeaderCellModelProtocol]> = DataSource([Lesson4GridHeaderCellModelPreviews]())
    
    init() {
        for index in 0...9 {
            let model = Lesson4GridHeaderCellModelPreviews()
            model.avatarImg = "img_avatar_" + "\(index)"
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
struct Lesson4GridHeaderViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson4GridHeaderViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

