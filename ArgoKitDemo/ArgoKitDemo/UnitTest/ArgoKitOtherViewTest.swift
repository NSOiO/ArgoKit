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
        ScrollView {
            Slider(value: 1.9, in: 1...1000) { value in
                print("\(value)")
            }
            .margin(edge: .top, value: 50)
            .thumbTintColor(.red)
            .minimumTrackTintColor(.yellow)
            .maximumTrackTintColor(.green)
            .height(100)
            .width(80%)

            //步近器
            Stepper(value: 1, in: 0...10, step: 3) { value in
                print("\(value)")
            }
            .margin(edge: .top, value: 50)
            .backgroundColor(.yellow)
            .setIncrementImage(UIImage(named: "lakemcdonald.lpg"), for: UIControl.State.normal)

            // switch
            Toggle(false){ result in
                print("\(result)")
            }.margin(edge: .top, value: 50)


            // pageControl
            PageControl(currentPage: 0, numberOfPages: 10){selecedIndex in
                print("\(selecedIndex)")
            }
            .currentPageIndicatorTintColor(.yellow)
            .backgroundColor(.orange)
            .width(300)
            .height(50)
            .margin(edge: .top, value: 30)


            SegmenteControl (onSegmentedChange:{ index in

            }){
                Text("1")
                Text("2")
                Text("4")
                Text("5")
            }
            .selectedSegmentIndex(1)
            .width(300)
            .height(50)
            .margin(edge: .top, value: 30)

            ActivityIndicatorView(style: .whiteLarge)
                .hidesWhenStopped(false)
                .color(.purple)
                .backgroundColor(.red)
                .margin(edge: .top, value: 30)
                .startAnimating()
            
            ActivityIndicatorView(style: .whiteLarge)
                .hidesWhenStopped(false)
                .color(.purple)
                .width(100)
                .height(100)
                .backgroundColor(.red)
                .margin(edge: .top, value: 30)
                .startAnimating()
            
            ProgressView(0.5)
                .width(100)
                .height(10)
                .backgroundColor(.brown)
                .margin(edge: .top, value: 300)
            
            
            EmptyView()
                .width(100)
                .height(400)
                .backgroundColor(.yellow)
            
            ForEach(0..<100){index in
                Text("\(index)")
            }
//            .margin(edge: .bottom, value: 50)
        
        }
        .height(100%)
        .width(100%)
//        .grow(1)
        .backgroundColor(.red)
        
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
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitOtherViewTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitOtherViewTest(model: ArgoKitOtherViewTestModel_Previews()).height(100%)
            
        }
    }
}
#endif
