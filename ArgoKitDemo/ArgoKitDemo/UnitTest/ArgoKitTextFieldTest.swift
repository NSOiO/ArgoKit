//
//  ArgoKitTextFieldTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitTextFieldTestModel {

}

// view
struct ArgoKitTextFieldTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitTextFieldTestModel
    init(model: ArgoKitTextFieldTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        TextField(placeholder: "姓名")
            .width(200)
            .height(40)
            .margin(edge: .top, value: 90)
            .padding(edge: .left, value: 5)
            .didEndEditing({ (text, reason) in
                print(text as Any)
            })
            .shouldReturn({ text -> Bool in
                print(text ?? "")
                return true
            })
            .shouldEndEditing({ text -> Bool in
                print(text ?? "")
                return true
            })
            .shouldChangeCharacters({ (text1, rang, text2) -> Bool in
                print(text1 ?? "")
                print(text2)
                return true
            })
            .rightView{
                Button(text: "left") {
                    print("left")
                }
                .backgroundColor(.cyan)
                
            }
            .leftView{ () -> View in
                Button(text: "right") {
                    print("right")
                }
                .backgroundColor(.cyan)
            }
            .backgroundColor(.red)
            .cornerRadius(5)
            .font(style: .bold)
            .font(size: 30)
            .margin(edge: .left, value: 30)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitTextFieldTestModel_Previews:  ArgoKitTextFieldTestModel {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitTextFieldTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitTextFieldTest(model: ArgoKitTextFieldTestModel_Previews())
        }
    }
}
#endif
