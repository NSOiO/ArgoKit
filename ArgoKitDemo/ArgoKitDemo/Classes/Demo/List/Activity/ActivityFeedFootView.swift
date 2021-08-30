//
//  ActivityFeedFootView.swift
//  ArgoKitTutorial
//
//  Created by Bruce on 2021/6/22.
//

import ArgoKit

// view model.
protocol ActivityFeedFootViewModelProtocol: ViewModelProtocol {
    var icon1:String {get set}
    var titile1:String {get set}
    
    var icon2:String {get set}
    var titile2:String {get set}
    
    var icon3:String {get set}
    var titile3:String {get set}
    
    var more:String {get set}
}

// view
struct ActivityFeedFootView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ActivityFeedFootViewModelProtocol
    init(model: ActivityFeedFootViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Button {
            
        } builder: {
            Image(model.icon1)
                .margin(edge: .right, value: 3)
            Text(model.titile1)
                .font(size: 12.0)
                .textColor(red: 50, green: 51, blue: 51)
        }.margin(edge: .right, value: 30)
        
        Button {
            
        } builder: {
            Image(model.icon2)
                .margin(edge: .right, value: 3)
            Text(model.titile2)
                .font(size: 12.0)
                .textColor(red: 50, green: 51, blue: 51)
        }.margin(edge: .right, value: 30)
        
        Button {
            
        } builder: {
            Image(model.icon3)
                .margin(edge: .right, value: 3)
            Text(model.titile3)
                .font(size: 12.0)
                .textColor(red: 50, green: 51, blue: 51)
        }.margin(edge: .right, value: .auto)
        
        Button {
            
        } builder: {
            Image(model.more)
        }


    }
}

extension ActivityFeedFootViewModelProtocol {
    func makeView() -> ArgoKit.View {
        ActivityFeedFootView(model: self).flexDirection(.row)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ActivityFeedFootViewModel_Previews:  ActivityFeedFootViewModelProtocol {
    var icon1: String = "like"
    
    var titile1: String = "点赞"
    
    var icon2: String = "comment"
    
    var titile2: String = "评论"
    
    var icon3: String = "hello"
    
    var titile3: String = "招呼"
    
    var more:String = "more"
    init() {
        
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
struct ActivityFeedFootView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ActivityFeedFootViewModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

