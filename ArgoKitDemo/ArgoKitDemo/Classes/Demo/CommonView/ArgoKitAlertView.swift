//
//  ArgoKitAlertView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/27.
//

import ArgoKit

// view model.
protocol ArgoKitAlertViewModelProtocol: ViewModelProtocol {

}

// view
struct ArgoKitAlertView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitAlertViewModelProtocol
    init(model: ArgoKitAlertViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Button(text: "Tap to show AlertView") {
                AlertView(title: "Title", message: "Message", preferredStyle: .alert)
                    .destructive(title: "Cancel", handler: { _ in
                        
                    })
                    .default(title: "OK") { _ in
                        
                    }
                    .show()
            }
            .padding(top: 10, right: 15, bottom: 10, left: 15)
            .borderWidth(2)
            .borderColor(.blue)
            .cornerRadius(10)
            
            Button(text: "Tap to show ActionSheet") {
                AlertView(title: "Title", message: "Message", preferredStyle: .actionSheet)
                    .default(title: "OK") { _ in
                        
                    }
                    .destructive(title: "Cancel") { _ in
                        
                    }
                    .show()
            }
            .margin(edge: .top, value: 30)
            .padding(top: 10, right: 15, bottom: 10, left: 15)
            .borderWidth(2)
            .borderColor(.blue)
            .cornerRadius(10)
        }
        .height(100%)
        .justifyContent(.center)
        .alignItems(.center)
    }
}

extension ArgoKitAlertViewModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitAlertView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitAlertViewModelPreviews: ArgoKitAlertViewModelProtocol {

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
struct ArgoKitAlertViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitAlertViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

