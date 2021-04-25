//___FILEHEADER___

import ArgoKit

// view model.
protocol ___FILEBASENAMEASIDENTIFIER___ModelProtocol: ViewModelProtocol {

}

// view
struct ___FILEBASENAMEASIDENTIFIER___: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ___FILEBASENAMEASIDENTIFIER___ModelProtocol
    init(model: ___FILEBASENAMEASIDENTIFIER___ModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Hello, ArgoKit!")
    }
}

extension ___FILEBASENAMEASIDENTIFIER___ModelProtocol {
    func makeView() -> ArgoKit.View {
        ___FILEBASENAMEASIDENTIFIER___(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ___FILEBASENAMEASIDENTIFIER___Model_Previews:  ___FILEBASENAMEASIDENTIFIER___Model {
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
struct ___FILEBASENAMEASIDENTIFIER____Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ___FILEBASENAMEASIDENTIFIER___(model: ___FILEBASENAMEASIDENTIFIER___Model_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
