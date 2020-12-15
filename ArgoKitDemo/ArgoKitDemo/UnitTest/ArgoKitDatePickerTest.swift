//
//  ArgoKitDatePickerTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/15.
//

import ArgoKit

// view model.
class ArgoKitDatePickerTestModel {

}

// view
struct ArgoKitDatePickerTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitDatePickerTestModel
    init(model: ArgoKitDatePickerTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        DatePicker{ date in
            print("\(date)")
        }
        .width(300)
        .height(100)
        
        Text("11111")
        PickerView(["1","2","3","4","5"]){item in
            Text(item)
        }.width(100)
        .height(200)
        .backgroundColor(.yellow)
        
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitDatePickerTestModel_Previews:  ArgoKitDatePickerTestModel {
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
struct ArgoKitDatePickerTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitDatePickerTest(model: ArgoKitDatePickerTestModel_Previews())
        }
    }
}
#endif
