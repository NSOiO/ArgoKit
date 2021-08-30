//
//  ArgoKitTextView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/24.
//

import ArgoKit

// view model.
protocol ArgoKitTextViewModelProtocol: ViewModelProtocol {

}

// view
struct ArgoKitTextView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitTextViewModelProtocol
    init(model: ArgoKitTextViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            TextView(text: "HelloArgoKit")
                .height(100)
                .font(size: 20)
                .font(style: .bold)
                .margin(edge: .horizontal, value: 10)
                .backgroundColor(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
                .cornerRadius(10)
                .didEndEditing { text in
                    print("\(String(describing: text))")
                }
                .shouldEndEditing { text -> Bool in
                    print("\(String(describing: text))")
                    return true
                }
                .didChangeText { text in
                    print("\(String(describing: text))")
                }
                .margin(edge: .top, value: 100)
        }
        .height(100%)
        .width(100%)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension ArgoKitTextView {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension ArgoKitTextViewModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitTextView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitTextViewModelPreviews: ArgoKitTextViewModelProtocol {
    
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
struct ArgoKitTextViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitTextViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

