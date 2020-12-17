//
//  ArgoKitTextViewTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitTextViewTestModel {

}

// view
struct ArgoKitTextViewTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitTextViewTestModel
    init(model: ArgoKitTextViewTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        
        let getstur = PanPressGesture(minimumNumberOfTouches: 1, maximumNumberOfTouches: 1) { pangesture in
            print("\(pangesture)")
        }
        
        Text("Hello, World!")
        
        TextView(text: "Hello, World!")
            .height(100)
            .font(size: 20)
            .font(style: .bold)
            .margin(edge: .left, value: 10)
            .margin(edge: .right, value: 10)
            .margin(edge: .top, value: 96)
            .backgroundColor(.yellow)
            .cornerRadius(10)
            .didEndEditing { text in
                print("\(String(describing: text))")
            }
            .shouldEndEditing { text -> Bool in
                print("\(String(describing: text))")
                return true
            }
            .didChangeText { text in
                print("\(String(describing: text))")
            }.gesture(gesture: getstur)
            .onTapGesture {
                
            }.onLongPressGesture(numberOfTaps: 1, numberOfTouches: 3) {
                
            }
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitTextViewTestModel_Previews:  ArgoKitTextViewTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitTextViewTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitTextViewTest(model: ArgoKitTextViewTestModel_Previews())
        }
    }
}
#endif
