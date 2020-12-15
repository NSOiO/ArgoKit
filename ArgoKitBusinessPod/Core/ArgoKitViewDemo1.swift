//
//  ArgoKitViewDemo1.swift
//  ArgoKitBusinessPod
//
//  Created by Dai on 2020-12-15.
//

import ArgoKit

// view model.
class ArgoKitViewDemo1Model {

}

// view
struct ArgoKitViewDemo1: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitViewDemo1Model
    init(model: ArgoKitViewDemo1Model) {
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
class ArgoKitViewDemo1Model_Previews:  ArgoKitViewDemo1Model {
    override init() {
        super.init()
    }
}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitViewDemo1_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitViewDemo1(model: ArgoKitViewDemo1Model_Previews())
        }
    }
}
#endif
