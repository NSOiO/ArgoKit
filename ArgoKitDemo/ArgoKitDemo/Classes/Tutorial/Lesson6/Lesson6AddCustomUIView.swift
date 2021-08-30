//
//  Lesson6AddCustomUIView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/20.
//

import ArgoKit

// view model.
protocol Lesson6AddCustomUIViewModelProtocol: ViewModelProtocol {
    var customViewModel1: Lesson6CustomViewDataModel { get set }
    var customViewModel2: Lesson6CustomViewDataModel { get set }
}

// view
struct Lesson6AddCustomUIView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson6AddCustomUIViewModelProtocol
    init(model: Lesson6AddCustomUIViewModelProtocol) {
        self.model = model
    }
    
var body: ArgoKit.View {
    VStack {
        Text("Hello, ArgoKit!")
        
        UIViewRepresentation(data: model.customViewModel1)
            .createUIView { customViewModel in
                var view = UIView()
                if let model = customViewModel {
                    view = Lesson6CustomView(frame: CGRect(x: 0, y: 0, width: 300, height: 200), model: model)
                }
                return view
            }
            .margin(edge: .top, value: 20)
        
        UIViewRepresentation(data: model.customViewModel2)
            .createUIView { customViewModel in
                var view = UIView()
                if let model = customViewModel {
                    view = Lesson6CustomView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), model: model)
                }
                return view
            }
            .updateUIView({ customView, customViewModel in
                if let view = customView as? Lesson6CustomView {
                    view.updateFrame()
                }
            })
            .margin(edge: .top, value: 20)
            .width(200)
            .height(200)
        
        Text("Hello, ArgoKit!")
            .margin(edge: .top, value: 20)
    }
}
}

extension Lesson6AddCustomUIViewModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson6AddCustomUIView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson6AddCustomUIViewModelPreviews: Lesson6AddCustomUIViewModelProtocol {
    var customViewModel1 = Lesson6CustomViewDataModel(imgName: "img_avatar_0", textStr: "Custom UIView 1")
    var customViewModel2 = Lesson6CustomViewDataModel(imgName: "img_avatar_2", textStr: "Custom UIView 2")
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
struct Lesson6AddCustomUIViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson6AddCustomUIViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

