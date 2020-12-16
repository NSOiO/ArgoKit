//
//  ArgoKitTextTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitTextTestModel {

}

// view
struct ArgoKitTextTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitTextTestModel
    init(model: ArgoKitTextTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("单行文本")
            .font(size: 25)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 100)
        
        Text("单行文本粗体")
            .font(size: 25)
            .font(style: .bold)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
        
        Text("单行文本斜体单行文本斜体单行文本斜体单行文本斜体单行文本斜体")
            .font(size: 25)
            .font(style: .default)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
            .shrink(0)
        
        
        Text("单行文本粗体斜体")
            .font(size: 25)
            .font(style: .bolditalic)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
        
        Text("多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 ")
            .font(size: 25)
            .lineLimit(0)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
        
        Text("多行文本行间距 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 ")
            .font(size: 25)
            .lineLimit(0)
            .lineSpacing(10)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
        
        Text("多行文本行间距 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 ")
            .font(size: 25)
            .textColor(.white)
            .lineLimit(0)
            .lineSpacing(10)
            .backgroundColor(.orange)
            .margin(edge: .top, value: 10)
            .alignSelf(.center)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitTextTestModel_Previews:  ArgoKitTextTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitTextTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitTextTest(model: ArgoKitTextTestModel_Previews())
        }
    }
}
#endif
