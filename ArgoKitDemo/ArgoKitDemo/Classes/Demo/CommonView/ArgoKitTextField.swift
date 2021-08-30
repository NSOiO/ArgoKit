//
//  ArgoKitTextField.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/24.
//

import ArgoKit

// view model.
protocol ArgoKitTextFieldModelProtocol: ViewModelProtocol {

}

// view
struct ArgoKitTextField: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitTextFieldModelProtocol
    init(model: ArgoKitTextFieldModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            TextField(placeholder: "姓名")
                .width(200)
                .height(40)
                .margin(edge: .top, value: 90)
                .padding(edge: .left, value: 5)
                .didEndEditing({ (text, reason) in
                    print(text as Any)
                })
                .shouldReturn({ text -> Bool in
                    print(text ?? "")
                    hideKeyboard()
                    return true
                })
                .shouldEndEditing({ text -> Bool in
                    print(text ?? "")
                    return true
                })
                .shouldChangeCharacters({ (text1, rang, text2) -> Bool in
                    print(text1 ?? "")
                    print(text2)
                    return true
                })
                .keyboardType(.default)
                .returnKeyType(.done)
                .rightView {
                    Button(text: "left") {
                        print("Click right button")
                    }
                    .backgroundColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
                }
                .leftView {
                    Button(text: "right") {
                        print("Click left button")
                    }
                    .backgroundColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
                }
                .backgroundColor(#colorLiteral(red: 0.8983770814, green: 0.8983770814, blue: 0.8983770814, alpha: 1))
                .cornerRadius(5)
                .font(.boldSystemFont(ofSize: 20))
                .textColor(.black)
                .placeholderColor(#colorLiteral(red: 0.949587427, green: 0.949587427, blue: 0.949587427, alpha: 1))
                .margin(edge: .left, value: 30)
        }
        .width(100%)
        .height(100%)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension ArgoKitTextField {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension ArgoKitTextFieldModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitTextField(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitTextFieldModelPreviews: ArgoKitTextFieldModelProtocol {

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
struct ArgoKitTextFieldPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitTextFieldModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

