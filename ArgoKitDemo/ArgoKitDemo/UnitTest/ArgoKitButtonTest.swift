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
    var action:()->Void = {
        print("hahahh")
    }
}

// view
struct ArgoKitButtonTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitButtonTestModel
    @Alias var text:Text?
    init(model: ArgoKitButtonTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack{
            // 设置按钮title
            Button(text: "按钮titlevfdvvdfvdcdcdjkjjjsvfdvdf") {
            }


        }.alignItems(.start)
        VStack {
            Text("wweweddcddcc").alias(variable: $text)
            Button(text: "busdcsdcddcd",action: self.model.action)
        }
        .alignItems(.start)
        .backgroundColor(.yellow)
        
        
        

        
        
//        // 设置按钮title
        Button(text: "按钮title") {
            // 点击事件
            model.btn?.backgroundColor(.yellow)
        }
        .font(style: AKFontStyle.default, size: 25)
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
        .borderWidth(1)
        .borderColor(.gray)

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
            Text("按钮title 2")
                .backgroundColor(.cyan)
            Text("按钮title 3")
                .font(size: 25)
                .backgroundColor(.orange)

            Text("按钮title 4")
                .backgroundColor(.cyan)
                .font(size: 16)
            Text("按钮title 5")
                .backgroundColor(.cyan)

        }
        .wrap(.wrap)
        .flexDirection(.row)
        .justifyContent(.start)
        .alignItems(.start)
        .alignContent(.around)
        .font(style: AKFontStyle.default, size: 20)
        .width(300)
        .height(150)
        .backgroundColor(.green)
        .margin(edge: .top, value: 20)

        .alignSelf(.center)

//        .gradientColor(startColor: .red, endColor: .yellow, direction: ArgoKitGradientType.TopToBottom)


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
        .alignSelf(.center)


        Button(text:"设置背景图片") {

        }
        .textColor(.red)
        .font(style: AKFontStyle.bolditalic, size: 25)
        .backgroundImage(named: "chilkoottrail.jpg", for: UIControl.State.normal)
        .margin(edge: .top, value: 20)
        .alignSelf(.start)
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
