//
//  Lesson4GridCell.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/15.
//

import ArgoKit

// view model.
protocol Lesson4GridCellModelProtocol: ViewModelProtocol {
    var imgStr: String {get set}
    var titleStr: String {get set}
    var detailStr: String {get set}
}

// view
struct Lesson4GridCell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson4GridCellModelProtocol
    init(model: Lesson4GridCellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Image(model.imgStr)
                .cornerRadius(6)
                .contentMode(.scaleAspectFill)
            
            Text(model.titleStr)
                .font(.boldSystemFont(ofSize: 14))
                .textColor(red: 50, green: 51, blue: 51)
                .lineLimit(0)
                .margin(edge: .top, value: 10)
            
            Text(model.detailStr)
                .font(.systemFont(ofSize: 11))
                .textColor(red: 170, green: 170, blue: 170)
                .margin(edge: .top, value: 7)
        }
    }
}

extension Lesson4GridCellModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson4GridCell(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson4GridCellModelPreviews: Lesson4GridCellModelProtocol {
    var imgStr: String = "img_avatar_1"
    var titleStr: String = "夏日炎炎，有你真甜！甜到你了吗？"
    var detailStr: String = "index"
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
struct Lesson4GridCellPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson4GridCellModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

