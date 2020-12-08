//___FILEHEADER___

import ArgoKit

// view model
class ___FILEBASENAMEASIDENTIFIER___Model {

}

// view
class ___FILEBASENAMEASIDENTIFIER___: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
struct ___FILEBASENAMEASIDENTIFIER____Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ___FILEBASENAMEASIDENTIFIER___()
        }
    }
}
#endif