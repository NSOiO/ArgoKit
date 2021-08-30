//
//  Lesson4GridHeaderCell.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/14.
//

import ArgoKit

// view model.
protocol Lesson4GridHeaderCellModelProtocol: ViewModelProtocol {
    var avatarImg: String {get set}
    var detailStr: String {get set}
    
}

// view
struct Lesson4GridHeaderCell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson4GridHeaderCellModelProtocol
    init(model: Lesson4GridHeaderCellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Image(model.avatarImg)
                .height(67)
                .width(67)
                .circle()
            
            Text(model.detailStr)
                .margin(edge: .top, value: 9.5)
                .font(.systemFont(ofSize: 12))
                .textColor(red: 50, green: 51, blue: 51)
        }
        .alignItems(.center)
        .width(67)
        .margin(edge: .top, value: 5)
    }
}

extension Lesson4GridHeaderCellModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson4GridHeaderCell(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson4GridHeaderCellModelPreviews: Lesson4GridHeaderCellModelProtocol {
    var avatarImg: String = "img_avatar_0"
    var detailStr: String = "有新动态"
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
struct Lesson4GridHeaderCellPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson4GridHeaderCellModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

