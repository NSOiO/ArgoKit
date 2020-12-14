//
//  ArgoKitView10.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/9.
//

import ArgoKit

// view model
class ArgoKitView10Model {

}

// view
struct ArgoKitView10: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    typealias View = ArgoKit.View
    private var model: ArgoKitView10Model
    init(model: ArgoKitView10Model) {
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

// mock view model
class ArgoKitView10Model_Previews:  ArgoKitView10Model {

}

@available(iOS 13.0.0, *)
struct ArgoKitView10_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitView10(model: ArgoKitView10Model_Previews())
        }
    }
}
#endif
