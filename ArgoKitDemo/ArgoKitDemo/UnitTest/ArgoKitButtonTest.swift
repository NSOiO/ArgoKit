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
    @Property var text:String = "titlevfdvvdfvdcdcdjkjjjsvfdvdf"
    @Property var hidKeyBoard:Bool = false
    var action:(()->Void)?
    init() {
        action = {[self] in
            self.text = "bainh😸😸😸😸😸uananb"
            self.hidKeyBoard = true
        }
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
        /*
        HStack{
            // 设置按钮title
            Button(text: "按钮titlevfdvvdf😸vdcdcdjkjjjsvfdvdf") {
            }


        }.alignItems(.start)
        
        VStack {
            Text(self.model.text).alias(variable: $text)
            Button(text: "busdc😸😸😸😸😸😸😸sdcddcd",action: self.model.action!)
                .backgroundColor(.orange)
            
            Button(action: self.model.action!, builder: { () -> View in
                HStack{
                    VStack{
                        Text(self.model.text).alias(variable: $text).backgroundColor(.orange)
                            .alignSelf(.start)
                        Text(self.model.text).alias(variable: $text).backgroundColor(.orange)
                            .alignSelf(.start)
                            .onTapGesture{
                                self.model.text = "Text===Text"
                            }
                    }
                    .backgroundColor(.purple)
                }
                .backgroundColor(.brown)
            })
            .alignItems(.center)
            .margin(edge: .top, value: 10)
            
            
            TextField(text: "HAHHAH",placeholder: "12345678")
                .width(300)
                .height(50)
                .backgroundColor(.brown)
                .hidKeyBoard(self.model.hidKeyBoard)
                .rightView { () -> View in
                    Text("RIGHT VIEW")
                        .backgroundColor(.red)
                        .width(100)
                        .onTapGesture {
                            self.model.hidKeyBoard = true
                            print("RIGHT VIEW")
                        }
                }
        }
        .alignItems(.start)
        .backgroundColor(.yellow)
        
        */
        

        
   
//        // 设置按钮title
//        Button(text: "按钮title") {
//            // 点击事件
//            model.btn?.backgroundColor(.yellow)
//        }
//        .font(style: AKFontStyle.default, size: 25)
//        // 指定宽高
//        .width(300)
//        .height(100)
//        // 背景色
//        .backgroundColor(.red)
//        .margin(edge: .top, value: 90)
//        // 居中
//        .alignSelf(.center)
//        // 圆角
//        .cornerRadius(15)
//        // 线条和颜色
//        .borderWidth(1)
//        .borderColor(.gray)

        // 设置按钮title混排
        Button {
            // 点击事件
            model.btn?.backgroundColor(.yellow)
        } builder: {
            ForEach(0..<9){ index in
                Text("按钮title \(index)")
                    .font(size: 25)
                    .backgroundColor(.orange)
                    .width(30%)
                    .aspect(ratio: 1)
            }.padding(edge: .top, value: 10)
        }
        .flexDirection(.column)
        .wrap(.wrap)
        .flexDirection(.row)
        .justifyContent(.around)
        .alignItems(.start)
        .alignContent(.around)
        .font(style: AKFontStyle.default, size: 20)
        .width(400)
        .height(400)
        .backgroundColor(.green)
        .margin(edge: .top, value: 20)
        .alignSelf(.center)

//        .gradientColor(startColor: .red, endColor: .yellow, direction: ArgoKitGradientType.TopToBottom)


//        // 设置按钮文字图片混排
//        Button {
//
//        } builder: {
//
//            Text("按钮文字")
//                .backgroundColor(.cyan)
//
//            Image("chilkoottrail.jpg")
//                .shrink(1)
//                .aspect(ratio: 1)
//                .circle()
//
//        }.width(200)
//        .backgroundColor(.purple)
//        .font(style: AKFontStyle.bold, size: 20)
//
//        .padding(edge: .left, value: 20)
//        .padding(edge: .right, value: 30)
//
//        .margin(edge: .top, value: 20)
//        .alignSelf(.center)
//
//
//        Button(text:"设置背景图片") {
//
//        }
//        .textColor(.red)
//        .font(style: AKFontStyle.bolditalic, size: 25)
//        .backgroundImage(named: "chilkoottrail.jpg", for: UIControl.State.normal)
//        .margin(edge: .top, value: 20)
//        .alignSelf(.start)
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
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitButtonTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitButtonTest(model: ArgoKitButtonTestModel_Previews())
        }
    }
}
#endif
