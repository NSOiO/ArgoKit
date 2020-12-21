//
//  VStackAlignTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
class VStackAlignTestsModel {

}

// view
struct VStackAlignTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: VStackAlignTestsModel
    init(model: VStackAlignTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text("Hello, World! 1")
            Text("Hello, World! 2")
            Text("Hello, World! 3")
            Text("Hello, World! 4")
                .backgroundColor(.orange)
            Text("Hello, World! 5")
                .backgroundColor(.blue)
        }
        .backgroundColor(.red)
        .alignItems(.center)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class VStackAlignTestsModel_Previews:  VStackAlignTestsModel {

}

@available(iOS 13.0.0, *)
struct VStackAlignTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            VStackAlignTests(model: VStackAlignTestsModel_Previews())
        }
    }
}
#endif
