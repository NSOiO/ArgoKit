//
//  ArgoKitAnimationSpringTest.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/12/22.
//

import ArgoKit

// view model.
class ArgoKitAnimationSpringTestModel {

}

// view
struct ArgoKitAnimationSpringTest: ArgoKit.View {
    typealias View = ArgoKit.View
    @Alias var text: Text?
    
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitAnimationSpringTestModel
    init(model: ArgoKitAnimationSpringTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            
            Button(text: "开始") {
                self.text?
                    .startAnimation()
            }.margin(edge: .left, value: 15)
            
            Button(text: "暂停") {
                self.text?
                    .pauseAnimation()
            }.margin(edge: .left, value: 5)
            
            Button(text: "恢复") {
                self.text?
                    .resumeAnimation()
            }.margin(edge: .left, value: 5)
            
            Button(text: "结束") {
                self.text?
                    .stopAnimation()
            }.margin(edge: .left, value: 5)
        }
         
        Text("Hello, ArgoKit!")
            .alias(variable: $text)
            .margin(edge: .top, value: 50)
            .addAnimation { () -> AnimationBasic in
                SpringAnimation(type: .position)
                    .duration(3.0)
                    .from(0,0)
                    .to(200,200)
                    .springVelocity(5.0)
                    .springBounciness(0.5)
                    .springSpeed(2.0)
//                    .springTension(0.5)
                    .springFriction(2.0)
            }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitAnimationSpringTestModel_Previews:  ArgoKitAnimationSpringTestModel {
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
struct ArgoKitAnimationSpringTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ArgoKitAnimationSpringTest(model: ArgoKitAnimationSpringTestModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
