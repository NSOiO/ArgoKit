//
//  AliasTests.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2020/12/22.
//

import ArgoKit

// view model.
class AliasTestsModel {

}

// view
struct AliasTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: AliasTestsModel
    init(model: AliasTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Hello, ArgoKit!")
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class AliasTestsModel_Previews:  AliasTestsModel {
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
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct AliasTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                AliasTests(model: AliasTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
