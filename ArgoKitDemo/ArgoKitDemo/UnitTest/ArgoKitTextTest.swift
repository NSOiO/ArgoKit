//
//  ArgoKitTextTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitTextTestModel {

}

// view
struct ArgoKitTextTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitTextTestModel
    init(model: ArgoKitTextTestModel) {
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

// mock data.
class ArgoKitTextTestModel_Previews:  ArgoKitTextTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitTextTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitTextTest(model: ArgoKitTextTestModel_Previews())
        }
    }
}
#endif
