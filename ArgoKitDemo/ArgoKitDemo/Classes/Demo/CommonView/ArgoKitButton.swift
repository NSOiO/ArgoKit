//
//  ArgoKitButton.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/27.
//

import ArgoKit

// view model.
protocol ArgoKitButtonModelProtocol: ViewModelProtocol {
    var btn1Text: String { get set }
    var btn2Img: String { get set }
    var btn3Text: String { get set }
    var btn3Img: String { get set }
    var btn4Text: String { get set }
    var btn4Img: String { get set }
}

// view
struct ArgoKitButton: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitButtonModelProtocol
    init(model: ArgoKitButtonModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Button(text: model.btn1Text) {
                btn1ClickAction()
            }
            .borderWidth(2)
            .borderColor(.blue)
            .cornerRadius(5)
            .padding(top: 10, right: 15, bottom: 10, left: 15)
            
            Button {
                btn2ClickAciton()
            } builder: {
                Image(model.btn2Img)
                    .width(100)
                    .aspect(ratio: 1)
            }
            .margin(edge: .top, value: 20)
            .cornerRadius(20)
            
            Button {
                btn3ClickAction()
            } builder: {
                HStack {
                    Text(model.btn3Text)
                    Image(model.btn3Img)
                        .width(30)
                        .aspect(ratio: 1)
                        .margin(edge: .left, value: 5)
                        .cornerRadius(5)
                }
            }
            .borderWidth(1)
            .borderColor(.red)
            .cornerRadius(10)
            .padding(top: 10, right: 15, bottom: 10, left: 15)
            .margin(edge: .top, value: 20)
            
            Button {
                btn4ClickAciton()
            } builder: {
                VStack {
                    Image(model.btn4Img)
                        .width(30)
                        .aspect(ratio: 1)
                        .cornerRadius(5)
                    Text(model.btn4Text)
                        .margin(edge: .top, value: 5)
                }
                .alignItems(.center)
            }
            .margin(edge: .top, value: 20)
            .borderWidth(1)
            .borderColor(.red)
            .cornerRadius(10)
            .padding(top: 5, right: 15, bottom: 5, left: 15)
        }
        .alignItems(.center)
        .height(100%)
        .justifyContent(.center)
    }
}

extension ArgoKitButton {
    
    func btn1ClickAction() {
        model.btn1Text = "Button1Clicked"
    }
    
    func btn2ClickAciton() {
        model.btn2Img = "img_avatar_2"
    }
    
    func btn3ClickAction() {
        model.btn3Text = "Button3Clicked"
    }
    
    func btn4ClickAciton() {
        model.btn4Text = "Button4Clicked"
    }
}

extension ArgoKitButtonModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitButton(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitButtonModelPreviews: ArgoKitButtonModelProtocol {
    @Observable var btn1Text: String = "Button1"
    @Observable var btn2Img: String = "img_avatar_0"
    @Observable var btn3Text: String = "Button3"
    @Observable var btn3Img: String = "img_avatar_2"
    @Observable var btn4Text: String = "Button4"
    @Observable var btn4Img: String = "img_avatar_3"
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
struct ArgoKitButtonPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitButtonModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

