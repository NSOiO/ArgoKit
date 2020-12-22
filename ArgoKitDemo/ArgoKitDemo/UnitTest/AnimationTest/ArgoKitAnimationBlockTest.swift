//
//  ArgoKitAnimationBlockTest.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/12/21.
//

import ArgoKit

// view model.
class ArgoKitAnimationBlockTestModel {

}

// view
struct ArgoKitAnimationBlockTest: ArgoKit.View {
    typealias View = ArgoKit.View
    @Alias var text: Text?
    
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitAnimationBlockTestModel
    init(model: ArgoKitAnimationBlockTestModel) {
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
            .textAlign(.center)
            .addAnimation { () -> AnimationBasic in
                Animation(type: .rotation)
                    .duration(3.0)
                    .from(0)
                    .to(360)
                    .repeatForever(true)
                    .repeatCallback { (animation, count) in
                        print("[Animation] repeat count:\(count)")
                    }
                    .startCallback { animation in
                        print("[Animation] start")
                    }
                    .resumeCallback { animation in
                        print("[Animation] resume")
                    }
                    .pauseCallback { animation in
                        print("[Animation] pause")
                    }
                    .finishCallback { (animation, finished) in
                        print("[Animation] finish \(finished)")
                    }
            }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitAnimationBlockTestModel_Previews:  ArgoKitAnimationBlockTestModel {
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
struct ArgoKitAnimationBlockTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ArgoKitAnimationBlockTest(model: ArgoKitAnimationBlockTestModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
