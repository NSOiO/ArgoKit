//
//  ArgoKitDemo1.swift
//  ArgoKitPreviewPodDemo
//
//  Created by Dai on 2020-12-15.
//

import ArgoKit

// view model.
class ArgoKitDemo1Model {

}

// view
struct ArgoKitDemo1: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitDemo1Model
    init(model: ArgoKitDemo1Model) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text("aaaaa")
            MySpacer(height: 11)
                .backgroundColor(.blue)
            Text("bbbbb")
        }
        .justifyContent(.between)
        .height(50%)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitDemo1Model_Previews:  ArgoKitDemo1Model {
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
struct ArgoKitDemo1_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitDemo1(model: ArgoKitDemo1Model_Previews())
        }
    }
}
#endif
