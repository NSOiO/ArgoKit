//
//  ButtonTests.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2021/1/5.
//

import ArgoKit

// view model.
class ButtonTestsModel {
    @Alias var likeButton: Button? = nil
    @Alias var commentButton: Button? = nil
    @Alias var conversationButton: Button? = nil
    
    var likes: Int = 0
    @Observable var isLiked: Bool = false
    var comments: Int = 0
    var conversation: String = "对话"
}

// view
struct ButtonTests: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ButtonTestsModel
    init(model: ButtonTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            bottomButton(action: {
                model.isLiked = !model.isLiked                
            }, imageName: model.isLiked ? "like.press" : "like", title: "\(model.likes)")
            .alias(variable: model.$likeButton)
            .margin(edge: .right, value: 10)
            
            bottomButton(action: {
                
            }, imageName: "conversation", title: "\(model.comments)")
            .alias(variable: model.$commentButton)
            .margin(edge: .right, value: 10)

            bottomButton(action: {
                
            }, imageName: "conversation", title: "\(model.conversation)")
            .alias(variable:model.$conversationButton)
            .margin(edge: .right, value: 10)

            Button(text: "test button") {
                model.isLiked = !model.isLiked
            }
        }
    }
    
    private func bottomButton(action: @escaping () -> Void, imageName: @escaping @autoclosure () -> String, title: @escaping @autoclosure () -> String) -> ArgoKit.Button {
        Button(action: action) {
            HStack {
                Image()
                    .image(UIImage(named: imageName()))
                    .height(24)
                    .width(24)
                
                Text(title())
                    .font(size: 10)
                    .textColor(.init(60, 60, 60))
            }
            .alignItems(.center)
        }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ButtonTestsModel_Previews:  ButtonTestsModel {
    override init() {
        super.init()
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ButtonTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ButtonTests(model: ButtonTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
