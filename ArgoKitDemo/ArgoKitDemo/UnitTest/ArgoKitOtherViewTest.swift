//
//  ArgoKitOtherViewTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitOtherViewTestModel {

}

// view
struct ArgoKitOtherViewTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
  
    private var model: ArgoKitOtherViewTestModel
    init(model: ArgoKitOtherViewTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        
        Slider(value: 1.9, in: 1...1000) { value in
            print("\(value)")
        }
        .margin(edge: .top, value: 96)
        .thumbTintColor(.red)
        .minimumTrackTintColor(.yellow)
        .maximumTrackTintColor(.green)
        
        //步近器
        Stepper(value: 1, in: 0...10, step: 3) { value in
            print("\(value)")
        }
        .margin(edge: .top, value: 96)
        .backgroundColor(.yellow)
        .setIncrementImage(UIImage(named: "lakemcdonald.lpg"), for: UIControl.State.normal)
        
        Toggle(false){ result in
            print("\(result)")
        }.margin(edge: .top, value: 96)
        
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitOtherViewTestModel_Previews:  ArgoKitOtherViewTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitOtherViewTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitOtherViewTest(model: ArgoKitOtherViewTestModel_Previews())
        }
    }
}
#endif
