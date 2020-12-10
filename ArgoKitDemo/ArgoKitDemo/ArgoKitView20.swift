//
//  ArgoKitView20.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/10.
//

import ArgoKit

// view model
class ArgoKitView20Model {
    

}

// view
struct ArgoKitView20: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNodeBuilder.defaultViewNode
    typealias View = ArgoKit.View
    private var model: ArgoKitView20Model
    init(model: ArgoKitView20Model) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Hello, Worldcdscdscd!").margin(edge: .top, value: 100)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock view model
class ArgoKitView20Model_Previews:  ArgoKitView20Model {

}

@available(iOS 13.0.0, *)
struct ArgoKitView20_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitView20(model: ArgoKitView20Model_Previews())
        }
    }
}
#endif
