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
    
    @DataSource var pickerData = [["1","2","3","4","5"],["1","2","3","4","5"],["1","2","3","4","5"]]
    @Alias var label: Text?
    
    private var model: ArgoKitDatePickerTestModel
    init(model: ArgoKitDatePickerTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Hello, World!")
        DatePicker{ date in
            print("\(date)")
        }
        .width(300)
        .height(100)
        
        Text("11111").alias(variable: $label)
        PickerView($pickerData) { item in
            Text(item).backgroundColor(.red).grow(1).textAlign(.center)
        }.width(100%)
        .height(200)
        .widthForComponent({ (component) -> Float in
            switch component {
            case 1:
                return 50
            case 2:
                return 60
            default:
                return 40
            }
        })
        .rowHeightForComponent({ (component) -> Float in
            return 44
        })
        .didSelectRow({ (text, row, component) in
            self.label?.text("\(text) \(row) \(component)")
        })
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
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
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
