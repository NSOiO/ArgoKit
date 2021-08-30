//
//  Lesson1View.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/6.
//

import ArgoKit

// view model.
protocol Lesson1ViewModelProtocol: ViewModelProtocol {

}

// view
struct Lesson1View: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: Lesson1ViewModelProtocol
    init(model: Lesson1ViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            headerInfo() // 顶部区域
            contentInfo() // 内容区域
            bottomInfo() // 底部区域
        }
        .margin(edge: .top, value: 10)
        .margin(edge: .horizontal, value: 10)
    }
}

extension Lesson1View {
    
    private func headerInfo() -> ArgoKit.View {
        let view = HStack {
            Image("img_avatar_1") // 头像图片
                .width(40)
                .aspect(ratio: 1)
                .circle()
            
            VStack {
                HStack {
                    Text("魔女同同") // 昵称
                        .textColor(.red)
                        .font(.boldSystemFont(ofSize: 16))

                    Image("power") // 会员标识
                        .width(12)
                        .aspect(ratio: 1)
                        .margin(edge: .left, value: 2)
                }
                .alignItems(.center)
                
                Text("很高兴认识你") // 额外信息
                    .textColor(red: 170, green: 170, blue: 170)
                    .font(.systemFont(ofSize: 12))
                    .margin(edge: .top, value: 3)
            }
            .margin(edge: .left, value: 10)
            .justifyContent(.center)
            
            Spacer()
            
            Image("more2") // 更多图片
                .height(36)
                .aspect(ratio: 1)
                .alignSelf(.center)
        }
        return view
    }
    
    private func contentInfo() -> ArgoKit.View {
        let view = VStack {
            Text("今天天气真不错😄。") // 内容文本
                .font(.systemFont(ofSize: 15))
                .margin(edge: .top, value: 15)
            
            Image("img_detail") // 内容图片
                .cornerRadius(4)
                .aspect(ratio: 1)
                .width(80%)
                .margin(edge: .top, value: 10)
        }
        return view
    }
    
    private func bottomInfo() -> ArgoKit.View {
        let view = HStack {
            Button {
                print("点赞")
            } builder: {
                Image("like") //点赞图片
                    .width(24)
                Text("点赞") // 点赞文本
                    .font(.boldSystemFont(ofSize: 12))
                    .textColor(red: 170, green: 170, blue: 170)
                    .margin(edge: .left, value: 3)
            }
            
            Button {
                print("评论")
            } builder: {
                Image("comment") // 评论图片
                    .width(24)
                Text("评论") // 评论文本
                    .font(.boldSystemFont(ofSize: 12))
                    .textColor(red: 170, green: 170, blue: 170)
                    .margin(edge: .left, value: 3)
            }
            .margin(edge: .left, value: 30)
        }
        .margin(edge: .top, value: 10)
        .height(40)
        .alignItems(.center)
        return view
    }
}

extension Lesson1ViewModelProtocol {
    func makeView() -> ArgoKit.View {
        Lesson1View(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class Lesson1ViewModelPreviews: Lesson1ViewModelProtocol {

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
struct Lesson1ViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                Lesson1ViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

