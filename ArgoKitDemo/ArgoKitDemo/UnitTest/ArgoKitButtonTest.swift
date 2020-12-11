//
//  ArgoKitButtonTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitButtonTestModel {
    var btn:Button?

}

// view
struct ArgoKitButtonTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitButtonTestModel
    init(model: ArgoKitButtonTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        
        // 设置按钮title
        Button(text: "按钮title") {
            // 点击事件
            model.btn?.backgroundColor(.yellow)
        }
        .font(style: AKFontStyle.default, size: 19)
        // 指定宽高
        .width(300)
        .height(100)
        // 背景色
        .backgroundColor(.red)
        .margin(edge: .top, value: 90)
        // 居中
        .alignSelf(.center)
        // 圆角
        .cornerRadius(15)
        // 线条和颜色
        .borderWidth(3)
        .borderColor(.gray)
        .alias(variable: &model.btn)
        
        // 设置按钮title混排
        Button {
            // 点击事件
            model.btn?.backgroundColor(.yellow)
        } builder: {
            Text("按钮title 1")
                .font(size: 25)
                .backgroundColor(.orange)
            
            Text("按钮title 2")
                .backgroundColor(.cyan)
                .font(size: 16)
            
        }
        .font(style: AKFontStyle.default, size: 20)
        .width(300)
        .height(100)
        .backgroundColor(.green)
        
        .margin(edge: .top, value: 20)
        .alignSelf(.start)
        
        .gradientColor(startColor: .red, endColor: .yellow, direction: ArgoKitGradientType.TopToBottom)
        
        
        // 设置按钮文字图片混排
        Button {
            
        } builder: {
            
            Text("按钮文字")
                .backgroundColor(.cyan)
            
            Image("chilkoottrail.jpg")
                .shrink(1)
                .aspect(ratio: 1)
                .circle()
            
        }.width(200)
        .backgroundColor(.purple)
        .font(style: AKFontStyle.bold, size: 20)
        
        .padding(edge: .left, value: 20)
        .padding(edge: .right, value: 30)
        .margin(edge: .top, value: 20)
        .alignSelf(.end)
        
        
        
        
        Button(text:"设置背景图片") {
            
        }.width(200)
        .height(100)
        .textColor(.red)
        .font(style: AKFontStyle.bolditalic, size: 25)
        .backgroundImage(path: "chilkoottrail.jpg", for: UIControl.State.normal)
        .padding(edge: .left, value: 20)
        .padding(edge: .right, value: 30)
        .margin(edge: .top, value: 20)
        .alignSelf(.center)
        
        
        

       
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitButtonTestModel_Previews:  ArgoKitButtonTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitButtonTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitButtonTest(model: ArgoKitButtonTestModel_Previews())
        }
    }
}
#endif
