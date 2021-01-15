//
//  YYTextTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-15.
//

import ArgoKit

// view model.
class YYTextTestsModel {

}

// view
struct YYTextTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: YYTextTestsModel
    init(model: YYTextTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        YYText("YYText 单行文本粗体.")
            .font(size: 25)
            .font(style: .bold)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
            .alignSelf(.stretch)
        
        Text("Text 单行文本粗体.")
            .font(size: 25)
            .font(style: .bold)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
            .alignSelf(.stretch)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class YYTextTestsModel_Previews:  YYTextTestsModel {
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
struct YYTextTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                YYTextTests(model: YYTextTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
