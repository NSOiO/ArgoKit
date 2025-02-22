//
//  FeedCell.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

enum FeedCellAction: Action {
    case likeButtonClick
}

// view model.
protocol FeedCellModelProtocol: ViewModelProtocol {
    var content: String { get }
    var userName: String { get }
    var userAge: Int { get }
    var placeHolder: String { get }
    var iconURL: URL? { get }
    var photoURLs: [URL] { get }
    var time: Int { get }
    var distance: Float { get }
    
    var likes: Int { get }
    var isLiked: Bool { get }
    var comments: Int { get }
    var conversation: String { get }
    
    var action: Action { get set }
}

// view
struct FeedCell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: FeedCellModelProtocol
    init(model: FeedCellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            HStack { //header
                Image(url: model.iconURL, placeholder: model.placeHolder)
                    .size(width: 40, height: 40).circle()
                    .margin(edge: .right, value: 10)
                VStack {
                    Text(model.userName).font(size: 16)
                    Text("\(model.userAge)").font(size: 14).textAlign(.center).circle()
                        .backgroundColor(red: 239, green: 66, blue: 66)
                        .padding(top: 0, right: 10, bottom: 0, left: 10)
                }
            }
            .margin(edge: .bottom, value: 5)
            // content
            Text(model.content).font(size: 14).lineLimit(0)
                .margin(edge: .bottom, value: 5)
            HStack {//photos
                ForEach(model.photoURLs) { item in
                    Image(url: item, placeholder: model.placeHolder)
                        .aspect(ratio: 1)
                        .width(30%).cornerRadius(5)
                        .margin(edge: .bottom, value: 10)
                        .onTapGesture{
                            let controller = ViewPagerController()
                            viewController()?.navigationController?.pushViewController(controller, animated: true)
                        }
                }
            }
            .wrap(.wrap).justifyContent(.around).margin(edge: .bottom, value: 5)
            
            Text("\(model.time)小时前发布 · \(model.distance)km")
                .font(size: 10).textColor(.init(60, 60, 60))
                .margin(edge: .bottom, value: 5)
            EmptyView()//spite line
                .size(width: 100%, height: 0.5).backgroundColor(.lightGray)
                .margin(edge: .bottom, value: 5)
                
            HStack {// bottom buttons
                bottomButton(action: {
                    model.action = FeedCellAction.likeButtonClick
                }, imageName: model.isLiked ? "like.press" : "like", title: "\(model.likes)")
                bottomButton(action: {
                    
                }, imageName: "conversation", title: "\(model.comments)")
                
                bottomButton(action: {
                    
                }, imageName: "conversation", title: "\(model.conversation)")
                
            }
            .width(100%).justifyContent(.between)
            .padding(edge: .horizontal, value: 30)
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

extension FeedCellModelProtocol {
    func makeView() -> ArgoKit.View {
        FeedCell(model: self)
    }
}

//#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class FeedCellModel_Previews:  FeedCellModel {
    override init() {
        super.init()
//        self.content = "    军用枪射击技能培训～～第一次拿枪，教练超吃惊，完全不相信我第一次打枪～～(o^^o)开森，射击技能点有加成～～"
        self.iconURL = URL(string: "http://img.momocdn.com/feedimage/A1/D2/A1D2FE38-F933-4758-924C-CD5AC0E7AD8720201213_400x400.webp")
        let array = [
            URL(string: "http://img.momocdn.com/feedimage/A1/24/A124B7A3-AF51-43B2-9DB0-D56E32D1809520201211_400x400.webp")!,
            URL(string: "http://img.momocdn.com/feedimage/D6/A4/D6A45519-EC44-47B8-8032-658F40F5F26120201211_400x400.webp")!,
            URL(string: "http://img.momocdn.com/feedimage/82/8B/828BA59B-6A93-F96B-D467-FC22243F5BD120201211_L.webp")!
        ]
        for _ in 0...2 {
            self.photoURLs.append(contentsOf: array)
        }
        
        self.time = 5
        self.distance = 12.56
        self.likes = 134
        self.comments = 9
    }
}
#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
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
struct FeedCell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                FeedCell(model: FeedCellModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
