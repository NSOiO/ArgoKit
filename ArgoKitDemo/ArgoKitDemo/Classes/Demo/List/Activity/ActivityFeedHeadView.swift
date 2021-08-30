//
//  ActivityFeedHeadView.swift
//  ArgoKitTutorial
//
//  Created by Bruce on 2021/6/22.
//

import ArgoKit

// view model.
protocol ActivityFeedHeadViewModelProtocol: ViewModelProtocol {
    var icon:String {get set}
    var name:String {get set}
    var sex:String {get set}
    var age:String {get set}
    var glass:String {get set}
    var state:String {get set}
    var node:ArgoKitNodeAlias? {get set}
    func onclick()
}

// view
struct ActivityFeedHeadView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ActivityFeedHeadViewModelProtocol
    init(model: ActivityFeedHeadViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack{
            Image(model.icon)
                .size(width:40.0,height:40.0)
                .circle()
                .nodeAlias(variable: &model.node)
                .onTapGesture {
                    model.onclick()
                }
            VStack{
                Text(model.name).font(size:15.0).font(style:.bold)
                HStack{
                    Text(model.sex + " " + model.age)
                        .font(size:12.0)
                    Text(model.glass)
                        .margin(edge:.left,value:6.0)
                        .font(size:12.0)
                    Text(model.state)
                        .margin(edge:.left,value:6.0)
                        .font(size:12.0)
                } .margin(edge:.top,value:3.0)
            }.margin(edge:.left,value:9.0)
        }
    }
}

extension ActivityFeedHeadViewModelProtocol {
    func makeView() -> ArgoKit.View {
        ActivityFeedHeadView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ActivityFeedHeadViewModel_Previews:  ActivityFeedHeadViewModelProtocol {
    var icon: String = "img_avatar_8"
    
    var name: String = "魔女同同"
    
    var sex: String = "女"
    
    var age: String = "30"
    
    var glass:String = "年|SVP1"
    
    var state: String = "在线"
    var node: ArgoKitNodeAlias? = nil
    func onclick() {
        if let view = node?.nodeView() {
            UIView.animate(withDuration: 3) {
                view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            }
        }
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
struct ActivityFeedHeadView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ActivityFeedHeadViewModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

