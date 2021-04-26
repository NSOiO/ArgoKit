//
//  ArgoKitAnimationProgressTest.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/12/22.
//

import ArgoKit

// view model.
class ArgoKitAnimationProgressTestModel {

}

// view
struct ArgoKitAnimationProgressTest: ArgoKit.View {
    typealias View = ArgoKit.View
    @Alias var text: Text?
    
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitAnimationProgressTestModel
    init(model: ArgoKitAnimationProgressTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            
            Slider(value: 0.0, in: 0.0...1.0) { value in
                self.text?.updateAnimation(progress: value)
            }
            .margin(edge: .top, value: 50)
            .height(100)
            .width(100%)
        }
         
        Text("Hello, ArgoKit!")
            .alias(variable: $text)
            .margin(edge: .top, value: 50)
            .textAlign(.center)
            .addAnimation { () -> AnimationBasic in
                Animation(type: .rotation)
                    .timingFunc(.linear)
                    .duration(3.0)
                    .from(0)
                    .to(360)
                
                Animation(type: .textColor)
                    .timingFunc(.linear)
                    .duration(3.0)
                    .from(UIColor.black)
                    .to(UIColor.red)
                
                Animation(type: .scale)
                    .timingFunc(.linear)
                    .duration(3.0)
                    .from(1,1)
                    .to(2,2)
            }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitAnimationProgressTestModel_Previews:  ArgoKitAnimationProgressTestModel {
    override init() {
        super.init()
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitAnimationProgressTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ArgoKitAnimationProgressTest(model: ArgoKitAnimationProgressTestModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
