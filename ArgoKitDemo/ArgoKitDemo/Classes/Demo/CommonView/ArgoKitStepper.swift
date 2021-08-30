//
//  ArgoKitStepper.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/27.
//

import ArgoKit

// view model.
protocol ArgoKitStepperModelProtocol: ViewModelProtocol {
    var stepValue: Double { get set }
    var textStr: String { get set }
}

// view
struct ArgoKitStepper: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitStepperModelProtocol
    init(model: ArgoKitStepperModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            Text("Step Value " + model.textStr)
            Spacer()
            //步近器
            Stepper(stepValue: 1, in: 0...100) { value in
                model.stepValue = value
                model.textStr = "\(model.stepValue)"
            }
            .isContinuous(true)
        }
        .margin(edge: .top, value: 50)
        .margin(edge: .horizontal, value: 20)
        .alignItems(.center)
    }
}

extension ArgoKitStepperModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitStepper(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitStepperModelPreviews: ArgoKitStepperModelProtocol {
    @Observable var stepValue: Double = 0
    @Observable var textStr: String = ""
    init() {
        textStr = "\(stepValue)"
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
struct ArgoKitStepperPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitStepperModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

