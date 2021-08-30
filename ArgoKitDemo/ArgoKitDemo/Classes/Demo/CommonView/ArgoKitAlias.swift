//
//  ArgoKitAlias.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2020/12/22.
//

import ArgoKit

// view model.
protocol ArgoKitAliasModelProtocol : ViewModelProtocol {
    var titleText: Text?{get set}
    var count: Int{get set}
}
extension ArgoKitAliasModelProtocol{
    func makeView() -> View {
        ArgoKitAlias(model: self)
    }
}
// view
struct ArgoKitAlias: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitAliasModelProtocol
    init(model: ArgoKitAliasModelProtocol) {
        self.model = model
    }
    var body: ArgoKit.View {
        Text("Hello, ArgoKit!")
            .alias(variable: &model.titleText)
            .borderWidth(1)
            .borderColor(.blue)
            .onTapGesture {
                model.count += 1
                model.titleText?.text("click \(model.count)")
            }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class AliasTestsModel_Previews:  ArgoKitAliasModelProtocol {
    var titleText: Text? = nil
    var count: Int = 0
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
struct AliasTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                AliasTestsModel_Previews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
