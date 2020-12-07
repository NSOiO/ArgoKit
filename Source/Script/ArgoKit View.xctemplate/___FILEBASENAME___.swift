//___FILEHEADER___

import ArgoKit

class ___FILEBASENAMEASIDENTIFIER___: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct ___FILEBASENAMEASIDENTIFIER____Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            ___FILEBASENAMEASIDENTIFIER___()
        }
    }
}
#endif