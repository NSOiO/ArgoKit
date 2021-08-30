//
//  ArgoKitGesture.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/27.
//

import ArgoKit

// view model.
protocol ArgoKitGestureModelProtocol: ViewModelProtocol {
    var tapGestureText: String { get set }
    var twoTapGestureText: String { get set }
    var longPressGestureText: String { get set }
}

// view
struct ArgoKitGesture: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitGestureModelProtocol
    init(model: ArgoKitGestureModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text(model.tapGestureText)
                .onTapGesture {
                    model.tapGestureText = "did tap"
                }
                .backgroundColor(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
                .textAlign(.center)
                .padding(top: 20, right: 10, bottom: 20, left: 10)

            Text(model.twoTapGestureText)
                .onTapGesture(numberOfTaps: 2, numberOfTouches: 1, enabled: true) {
                    model.twoTapGestureText = "did two tap"
                }
                .margin(edge: .top, value: 40)
                .backgroundColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
                .textAlign(.center)
                .padding(top: 20, right: 10, bottom: 20, left: 10)

            Text(model.longPressGestureText)
                .onLongPressGesture {
                    model.longPressGestureText = "did long press"
                }
                .margin(edge: .top, value: 40)
                .backgroundColor(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
                .textAlign(.center)
                .padding(top: 20, right: 10, bottom: 20, left: 10)
        }
        .height(100%)
        .alignItems(.center)
        .justifyContent(.center)
    }
}

extension ArgoKitGestureModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitGesture(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitGestureModelPreviews: ArgoKitGestureModelProtocol {
    @Observable var tapGestureText: String = "tapGesture"
    @Observable var twoTapGestureText: String = "twoTapGesture"
    @Observable var longPressGestureText: String = "longPressGesture"
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
struct ArgoKitGesturePreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitGestureModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

