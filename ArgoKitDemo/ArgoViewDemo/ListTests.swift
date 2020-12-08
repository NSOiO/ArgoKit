//
//  ListTests.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-08.
//

import ArgoKit

// view model
class ListTestsModel {

}

// view
class ListTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
//        Text("Hello, World!")
       
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock view model
class ListTestsModel_Previews:  ListTestsModel {

}

@available(iOS 13.0.0, *)
struct ListTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ListTests()
        }
    }
}
#endif
