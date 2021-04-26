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
//                .grow(0)
                .height(100)
            
            
            Spacer()
                .backgroundColor(.blue)
//                .grow(0)
                .height(10)
                .shrink(1)
            
            
            
            Text("Text 2")
            Text("Text 3")
            Text("Text 4")
            Text("Text 5")
        }
        .backgroundColor(.lightGray)
        .height(100%)
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
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct SpacerTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoKitRender {
            SpacerTests(model: SpacerTestsModel_Previews())
        }
    }
}
#endif
