//
//  FeedDetailView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/7.
//

import ArgoKit

// view model.
protocol FeedDetailViewModelProtocol: ViewModelProtocol {
    var avatarImg: String {get set} // 用户头像图片名称
    var name: String {get set} // 用户昵称
    var isVip: Bool {get set} // 是否会员
    var userExtraInfo: String {get set} // 用户额外信息
    var feedContent: String {get set} // feed 内容
    var feedImg: String {get set} // feed 图片
    var isLiked: Bool {get set} // 是否对 feed 点赞
    var likeCount: Int {get set} // feed 获赞数
    var likeCountStr: String {get set} // 展示的 feed 获赞数文本
    var likeImg: String {get set} // 点赞图片
    var commentCount: Int {get set} // feed 评论数
    var commentCountStr: String {get set} // 展示的 feed 评论数文本
    var contentImgAciton: () -> Void {get set} // feed 图片点击事件
    var moreAciton: () -> Void {get set} // 更多按钮点击事件
    var likeAction: () -> Void {get set} // 点赞按钮点击事件
    var commentAction: () -> Void {get set} // 评论按钮点击事件
}

// view
struct FeedDetailView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: FeedDetailViewModelProtocol
    init(model: FeedDetailViewModelProtocol) {
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

extension FeedDetailView{
    
    private func headerInfo() -> ArgoKit.View {
        let view = HStack {
            Image(model.avatarImg) // 头像图片
                .width(40)
                .aspect(ratio: 1)
                .circle()
            
            VStack {
                HStack {
                    Text(model.name) // 昵称
                        .textColor(.red)
                        .font(.boldSystemFont(ofSize: 16))

                    Image("power") // 会员标识
                        .width(12)
                        .aspect(ratio: 1)
                        .margin(edge: .left, value: 2)
                        .gone(!model.isVip)
                }
                .alignItems(.center)
                
                Text(model.userExtraInfo) // 额外信息
                    .textColor(red: 170, green: 170, blue: 170)
                    .font(.systemFont(ofSize: 12))
                    .margin(edge: .top, value: 3)
            }
            .margin(edge: .left, value: 10)
            .justifyContent(.center)
            
            Spacer()
            
            Button {
                model.moreAciton()
            } builder: {
                Image("more2") // 更多图片
                    .height(36)
                    .aspect(ratio: 1)
            }
            .alignSelf(.center)

        }
        return view
    }
    
    private func contentInfo() -> ArgoKit.View {
        let view = VStack {
            Text(model.feedContent) // 内容文本
                .font(.systemFont(ofSize: 15))
                .margin(edge: .top, value: 15)
            
            Image(model.feedImg) // 内容图片
                .cornerRadius(4)
                .aspect(ratio: 1)
                .width(80%)
                .margin(edge: .top, value: 10)
                .onTapGesture {
                    model.contentImgAciton()
                }
        }
        return view
    }
    
    private func bottomInfo() -> ArgoKit.View {
        let view = HStack {
            Button {
                model.likeAction()
            } builder: {
                Image(model.likeImg) //点赞图片
                    .width(24)
                Text(model.likeCountStr) // 点赞文本
                    .font(.boldSystemFont(ofSize: 12))
                    .textColor(red: 170, green: 170, blue: 170)
                    .margin(edge: .left, value: 3)
            }
            .minWidth(81)
            
            Button {
                model.commentAction()
            } builder: {
                Image("comment") // 评论图片
                    .width(24)
                Text(model.commentCountStr) // 评论文本
                    .font(.boldSystemFont(ofSize: 12))
                    .textColor(red: 170, green: 170, blue: 170)
                    .margin(edge: .left, value: 3)
            }
            .margin(edge: .left, value: 30)
            .minWidth(81)
        }
        .margin(edge: .top, value: 10)
        .height(40)
        .alignItems(.center)
        return view
    }
}

extension FeedDetailViewModelProtocol {
    func makeView() -> ArgoKit.View {
        FeedDetailView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class FeedDetailViewModelPreviews: FeedDetailViewModelProtocol {
    var avatarImg = "img_avatar_1"
    var name: String = "魔女同同"
    var isVip: Bool = true
    var userExtraInfo: String = "很高兴认识你"
    var feedContent: String = "今天天气真不错😄。"
    var feedImg: String = "img_detail"
    var isLiked: Bool = false {
        didSet {
            likeCount = isLiked ? likeCount + 1 : likeCount - 1
            likeImg = isLiked ? "liked" : "like"
        }
    }
    var likeCount: Int = 0 {
        didSet {
            likeCountStr = likeCount > 0 ? String(likeCount) : "点赞"
        }
    }
    @Observable var likeCountStr: String = "点赞"
    @Observable var likeImg: String = "like"
    var commentCount: Int = 0 {
        didSet {
            commentCountStr = commentCount > 0 ? String(commentCount) : "评论"
        }
    }
    @Observable var commentCountStr: String = "评论"
    var contentImgAciton: () -> Void = {}
    var moreAciton: () -> Void = {}
    var likeAction: () -> Void = {}
    var commentAction: () -> Void = {}
    
    init() {
        contentImgAciton = {
            AlertView(title: "点击图片", message: nil, preferredStyle: .alert)
                .default(title: "好的", handler: nil)
                .show()
        }
        
        moreAciton = {
            AlertView(title: "点击更多按钮", message: nil, preferredStyle: .alert)
                .default(title: "好的", handler: nil)
                .show()
        }

        likeAction = {
            self.isLiked = !self.isLiked
        }

        commentAction = {
            self.commentCount += 1
        }
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
struct FeedDetailViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                FeedDetailViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

