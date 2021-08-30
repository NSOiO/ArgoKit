//
//  Lesson3Cell.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/10.
//

import ArgoKit

// view model.
protocol Lesson3CellModelProtocol: ViewModelProtocol {
    var avatarImg: String {get set} // 头像图片名
    var nameStr: String {get set} // 昵称
    var detailStr: String {get set} // 详情
    var timeStr: String {get set} // 时间
    var isTop: Bool {get set} //是否被指定
}

// view
struct Lesson3Cell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson3CellModelProtocol
    init(model: Lesson3CellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            Image(model.avatarImg)
                .width(55)
                .aspect(ratio: 1)
                .circle()
            VStack {
                HStack {
                    Text(model.nameStr)
                        .font(.systemFont(ofSize: 16))
                        .textColor(red: 50, green: 51, blue: 51)
                    Text("置顶")
                        .font(.systemFont(ofSize: 9))
                        .textAlign(.center)
                        .backgroundColor(red: 170, green: 170, blue: 170)
                        .textColor(.white)
                        .height(12)
                        .cornerRadius(8)
                        .padding(top: 0, right: 4, bottom: 0, left: 4)
                        .margin(edge: .left, value: 4)
                        .gone(!model.isTop)
                    Spacer()
                    Text(model.timeStr)
                        .font(.systemFont(ofSize: 12))
                        .textColor(red: 170, green: 170, blue: 170)
                }
                .alignItems(.center)
                Text(model.detailStr)
                    .font(.systemFont(ofSize: 13))
                    .textColor(red: 170, green: 170, blue: 170)
                    .margin(edge: .top, value: 4)
            }
            .margin(edge: .left, value: 10.5)
            .justifyContent(.center)
            .grow(1)
        }
        .margin(edge: .horizontal, value: 15)
        .margin(edge: .vertical, value: 9)
    }
}

extension Lesson3CellModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson3Cell(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson3CellModelPreviews: Lesson3CellModelProtocol {
    var avatarImg: String = "img_avatar_0"
    var nameStr: String = "我是 Cell 位置：0"
    var detailStr: String = "很高兴认识你"
    var timeStr: String = "1小时前"
    @Observable var isTop: Bool = false
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
struct Lesson3CellPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson3CellModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

