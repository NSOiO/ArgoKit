//___FILEHEADER___

import ArgoKit

// view model.
class ___FILEBASENAMEASIDENTIFIER___Model {

}

// view
struct ___FILEBASENAMEASIDENTIFIER___: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ___FILEBASENAMEASIDENTIFIER___Model
    init(model: ___FILEBASENAMEASIDENTIFIER___Model) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ___FILEBASENAMEASIDENTIFIER___Model_Previews:  ___FILEBASENAMEASIDENTIFIER___Model {
    override init() {
        super.init()
    }
}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ___FILEBASENAMEASIDENTIFIER____Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ___FILEBASENAMEASIDENTIFIER___(model: ___FILEBASENAMEASIDENTIFIER___Model_Previews())
        }
    }
}
#endif
