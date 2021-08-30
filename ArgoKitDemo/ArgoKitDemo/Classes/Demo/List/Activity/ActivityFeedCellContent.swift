//
//  ActivityFeedCellContent.swift
//  ArgoKitTutorial
//
//  Created by Bruce on 2021/6/22.
//

import ArgoKit

// view model.
protocol ActivityFeedCellContentModelProtocol: ViewModelProtocol {
    var content:String {get set}
    var contentImage:String {get set}
    var imageAspect:CGFloat {get set}
    var state:String {get set}
}

// view
struct ActivityFeedCellContent: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ActivityFeedCellContentModelProtocol
    init(model: ActivityFeedCellContentModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text(model.content).lineLimit(0)
            .font(size: 15.0)
            .textColor(red: 50, green: 51, blue: 51)
        Image(model.contentImage)
            .width(60%)
            .aspect(ratio: model.imageAspect)
            .margin(edge: .top, value: 8)
            .cornerRadius(4.0)
        Text(model.state)
            .textColor(red: 170, green: 170, blue: 170)
            .margin(edge: .top, value: 8)
            .font(size: 12.0)
    }
}

extension ActivityFeedCellContentModelProtocol {
    func makeView() -> ArgoKit.View {
        ActivityFeedCellContent(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ActivityFeedCellContentModel_Previews:  ActivityFeedCellContentModelProtocol {
    var content: String = "拍了一天的广告视频，各位有什么更好的创意想法随时给我留言哦，等你们的好消息"
    
    var contentImage: String = "pic_1"
    
    var state:String = "15分钟前 · 廊坊市"
    
    var imageAspect:CGFloat = 1.0
    let images = ["img_avatar_4", "img_avatar_5", "img_avatar_6", "img_avatar_7"]
    let titles = ["拍了一天的广告视频，各位有什么更好的创意想法随时给我留言哦，等你们的好消息", "从中午睡到下午5点，好像没有睡过这么长时间了，还是一个人太无聊了", "上午和顾客互动半天，下午鼾睡的熊们，都挤成了一团了", "今天和同事们出去团建了，这个地方好美，强烈推荐大家出来旅游来这打卡"]
    init() {
        let index = Int.random(in: 0...3)
        contentImage = images[index]
        content = titles[index]
        let image:UIImage = UIImage(named: contentImage) ?? UIImage()
        imageAspect = image.size.width / image.size.height
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
struct ActivityFeedCellContent_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ActivityFeedCellContentModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

