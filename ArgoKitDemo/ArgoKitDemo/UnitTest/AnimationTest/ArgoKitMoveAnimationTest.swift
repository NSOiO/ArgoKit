//
//  ArgoKitMoveAnimationTest.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/12/18.
//

import ArgoKit

// view model.
class ArgoKitMoveAnimationTestModel {

}

// view
struct ArgoKitMoveAnimationTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitMoveAnimationTestModel
    init(model: ArgoKitMoveAnimationTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Hello, ArgoKit!")
//            .addAnimation {
//                ArgoKit.Animation(type: .positionX)
//                    .duration(3.0)
//                    .to(200)
//            }
            .addAnimationGroup {
                ArgoKit.Animation(type: .positionX)
                    .duration(3.0)
                    .to(200)
                ArgoKit.Animation(type: .positionY)
                    .duration(3.0)
                    .to(200)
            }
            .startAnimation()
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitMoveAnimationTestModel_Previews:  ArgoKitMoveAnimationTestModel {
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
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitMoveAnimationTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ArgoKitMoveAnimationTest(model: ArgoKitMoveAnimationTestModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
