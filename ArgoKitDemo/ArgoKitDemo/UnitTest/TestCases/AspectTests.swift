//
//  AspectTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
class AspectTestsModel {
    var url: URL = URL(string: "http://img.momocdn.com/feedimage/A1/D2/A1D2FE38-F933-4758-924C-CD5AC0E7AD8720201213_400x400.webp")!
    var placeHolder: String = "turtlerock"
}

// view
struct AspectTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: AspectTestsModel
    init(model: AspectTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            Image(url: model.url, placeholder: model.placeHolder)
                .height(60)
                .aspect(ratio: 1)
                .margin(edge: .all, value: 10)
                .grow(1)
            
            Image(url: model.url, placeholder: model.placeHolder)
                .height(60)
                .aspect(ratio: 1)
                .margin(edge: .all, value: 10)
                .grow(1)
        }
        .wrap(.wrap) //wrap的时候，第一个Image的aspect没有生效？
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class AspectTestsModel_Previews:  AspectTestsModel {

}

@available(iOS 13.0.0, *)
struct AspectTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            AspectTests(model: AspectTestsModel_Previews())
        }
    }
}
#endif
