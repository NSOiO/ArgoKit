//
//  HVStackTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit

// view model.
class HVStackTestsModel {

}


// view
struct HVStackTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: HVStackTestsModel
    init(model: HVStackTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            HStack {
                Text("HStack 1")
                    .margin(edge: .right, value: 10)
                    .backgroundColor(.brown)
                
                Text("HStack 2")
                    .margin(edge: .right, value: 10)
                    .backgroundColor(.brown)

                Text("HStack 3dddddddddddddddddd")
                    .backgroundColor(.brown)
                    .flex(1)
            }
            .backgroundColor(.red)
            .justifyContent(.between)
            .margin(edge: .right, value: 20)
            .margin(edge: .left, value: 20)
            .padding(edge: .right, value: 20)
            
            VStack {
                Text("VStack 1fdfafdd")
                Text("VStack fdafdfafdafda2")
                Text("VStack 1")
                Text("VStack 2")
                Text("VStack 1")
                Text("VStack 2")
//                Text("VStack 1")
                    .backgroundColor(.blue)
                Text("VStack 2")
                    .width(200)
                    .backgroundColor(.orange)
            }
            .backgroundColor(.red)
            .alignItems(.end)
        }
        .backgroundColor(.lightGray)
        .width(100%)
        .height(100%)
        .justifyContent(.evenly)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class HVStackTestsModel_Previews:  HVStackTestsModel {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct HVStackTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoKitRender {
            HVStackTests(model: HVStackTestsModel_Previews())
        }
    }
}
#endif
