//
//  ArgoKitView13.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/10.
//

import ArgoKit

// view model
class ArgoKitView13Model {

}

// view
struct ArgoKitView13: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    typealias View = ArgoKit.View
    private var model: ArgoKitView13Model
    init(model: ArgoKitView13Model) {
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
class ArgoKitView13Model_Previews:  ArgoKitView13Model {

}

@available(iOS 13.0.0, *)
struct ArgoKitView13_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitView13(model: ArgoKitView13Model_Previews())
        }
    }
}
#endif
