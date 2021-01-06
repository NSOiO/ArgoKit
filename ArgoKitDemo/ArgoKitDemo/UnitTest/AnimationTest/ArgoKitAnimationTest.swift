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
    @Alias var text: Text?
    var alphaAnimation = Animation(type: .alpha).to(0).autoReverse(true)
    
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitMoveAnimationTestModel
    init(model: ArgoKitMoveAnimationTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        
        HStack {
            Button(text: "透明度") {
                self.text?
                    .addAnimation(animation: alphaAnimation)
                    .startAnimation()
            }.margin(edge: .left, value: 15)
            
            Button(text: "背景颜色") {
                self.text?
                    .addAnimation {
                        Animation(type: .color)
                            .duration(3.0)
                            .from(UIColor.clear)
                            .to(UIColor.red)
                            
                    }
                    .startAnimation()
            }.margin(edge: .left, value: 5)
            
            Button(text: "文字颜色") {
                self.text?
                    .addAnimation {
                        Animation(type: .textColor)
                            .duration(3.0)
                            .from(UIColor.black)
                            .to(UIColor.blue)
                    }
                    .startAnimation()
            }.margin(edge: .left, value: 5)
        }
         
        HStack {
            Button(text: "位移") {
                self.text?
                    .addAnimation {
                        Animation(type: .position)
                            .duration(3.0)
                            .from(15,0)
                            .to(200, 200)
                            .resetOnStop(true)
                    }
                    .startAnimation()
                
            }
            .margin(edge: .left, value: 15)
            
            Button(text: "停止") {
                self.text?.stopAnimation()
            }
            .margin(edge: .left, value: 5)
            .backgroundColor(red: 255, green: 0, blue: 0)
            
            
            Button(text: "旋转") {
                self.text?
                    .addAnimation {
                        Animation(type: .rotation)
                            .duration(3.0)
                            .from(0)
                            .to(360)
                    }
                    .startAnimation()
            }
            .margin(edge: .left, value: 5)
            
            Button(text: "缩放") {
                self.text?
                    .addAnimation {
                        Animation(type: .scale)
                            .duration(3.0)
                            .from(1, 1)
                            .to(1.5, 1.5)
                    }
                    .startAnimation()
            }
            .margin(edge: .left, value: 5)
            
            Button(text: "内容偏移") {
                self.text?
                    .addAnimation {
                        Animation(type: .contentOffset)
                            .duration(3.0)
                            .from(0, 0)
                            .to(120, 120)
                    }
                    .startAnimation()
            }
            .margin(edge: .left, value: 5)
            
            Button(text: "组合") {
                self.text?
                    .addAnimation {
                        Animation(type: .position)
                            .duration(3.0)
                            .from(0,0)
                            .to(200, 200)
                        
                        Animation(type: .rotation)
                            .duration(3.0)
                            .from(0)
                            .to(360)
                        
                        Animation(type: .scale)
                            .duration(3.0)
                            .from(1, 1)
                            .to(1.5, 1.5)
                    }
                    .startAnimation()
            }
            .margin(edge: .left, value: 5)
        }.margin(edge: .top, value: 15)
        
        HStack {
            Text("Hello, ArgoKit!")
                .alias(variable: $text)
                .margin(edge: .left, value: 15)
                .addAnimation {
                    Animation(type: .alpha)
                        .duration(3.0)
                        .from(0.0)
                        .to(1.0)
                        
                }
            Spacer()
        }.margin(edge: .top, value: 15)
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
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
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
