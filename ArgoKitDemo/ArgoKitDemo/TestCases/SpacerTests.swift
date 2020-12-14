//
//  SpacerTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit

// view model.
class SpacerTestsModel {

}

// view
struct SpacerTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: SpacerTestsModel
    init(model: SpacerTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text("Text 1")
            Spacer()
                .backgroundColor(.red)
            
            Text("Text 2")
            Text("Text 3")
            Text("Text 4")
            Text("Text 5")
        }
        .backgroundColor(.lightGray)
        .height(80%)
//        .justifyContent(.between)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class SpacerTestsModel_Previews:  SpacerTestsModel {

}

@available(iOS 13.0.0, *)
struct SpacerTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            SpacerTests(model: SpacerTestsModel_Previews())
        }
    }
}
#endif
