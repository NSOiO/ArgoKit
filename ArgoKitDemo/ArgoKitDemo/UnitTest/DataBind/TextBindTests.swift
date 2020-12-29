//
//  TextBindTests.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2020/12/28.
//

import ArgoKit

// view model.
class TextBindTestsModel {
    @Property var fontSize = 12
    @Property var fontStyle: AKFontStyle = AKFontStyle.default
    @Property var myTitle: String = "text"
}

// view
struct TextBindTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: TextBindTestsModel
    init(model: TextBindTestsModel) {
        self.model = model
    }
    
    func getTitle() -> String {
        return model.$myTitle.wrappedValue
    }
    
    var body: ArgoKit.View {
        Text()
            .text(model.myTitle)
            .onTapGesture {
                model.myTitle = "change"
            }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class TextBindTestsModel_Previews:  TextBindTestsModel {
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
struct TextBindTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                TextBindTests(model: TextBindTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
