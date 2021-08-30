//
//  ArgoKitToggle.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/28.
//

import ArgoKit

// view model.
protocol ArgoKitToggleModelProtocol: ViewModelProtocol {
    var isToggleOn: Bool { get set }
}

// view
struct ArgoKitToggle: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitToggleModelProtocol
    init(model: ArgoKitToggleModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            Text("Toggle Switch: " + "\(model.isToggleOn)")
            Toggle(model.isToggleOn) { isOn in
                model.isToggleOn = isOn
            }
        }
        .margin(edge: .top, value: 50)
        .margin(edge: .horizontal, value: 20)
        .justifyContent(.between)
    }
}

extension ArgoKitToggleModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitToggle(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitToggleModelPreviews: ArgoKitToggleModelProtocol {
    @Observable var isToggleOn: Bool = false
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
struct ArgoKitTogglePreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitToggleModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

