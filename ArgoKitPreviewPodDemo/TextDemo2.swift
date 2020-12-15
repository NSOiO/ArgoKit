//
//  TextDemo2.swift
//  ArgoKitPreviewPodDemo
//
//  Created by Dai on 2020-12-15.
//

import ArgoKit

// view model.
class TextDemo2Model {

}

// view
struct TextDemo2: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: TextDemo2Model
    init(model: TextDemo2Model) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


//#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class TextDemo2Model_Previews:  TextDemo2Model {
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
struct TextDemo2_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            TextDemo2(model: TextDemo2Model_Previews())
        }
    }
}
//#endif
