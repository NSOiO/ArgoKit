//
//  ArgoKitButtonTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitButtonTestModel {

}

// view
struct ArgoKitButtonTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitButtonTestModel
    init(model: ArgoKitButtonTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Button {
            
        } builder: {
            Text("Hello, World!")
                .backgroundColor(.cyan)
            
        }.width(300)
        
        Button(text: "Hello, World!") {
            
        }.backgroundColor(.red)
//        .width(299)
        
        
        

       
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitButtonTestModel_Previews:  ArgoKitButtonTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitButtonTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitButtonTest(model: ArgoKitButtonTestModel_Previews())
        }
    }
}
#endif
