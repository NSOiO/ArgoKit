//
//  YYTextTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-15.
//

import ArgoKit

// view model.
class YYTextTestsModel {
    @Property var color:UIColor = .red
}

// view
struct YYTextTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: YYTextTestsModel
    init(model: YYTextTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
//        YYText("YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.YYText 单行文本粗体.")
//            .lineLimit(3)
//            .lineSpacing(10)
//            .textColor(.red)
//            .font(size: 20)
//            .font(style: .bold)
//            .backgroundColor(.yellow)
//            .margin(edge: .top, value: 10)
//            .alignSelf(.stretch)
//
        YYText("Text 单行文本粗体.dcsdcdcdcdcdcdcdcd\"")
            .font(size: 20)
//            .font(style: .bold)
            .backgroundColor(.green)
            .margin(edge: .top, value: 10)
            .alignSelf(.stretch)
            .lineLimit(2)
            .obliqueness(-1)
            .expansion(5)
            .textColor(.gray)
            .baselineOffset(2.0)
//            .textShadowColor(.purple)
//            .textShadowOffset(CGSize(width: 5, height: 5))
//            .textShadowBlurRadius(0.6)
            .strokeColor(.red)
            .setLink("www.baidu.com")
            .kern(5)
            .firstLineHeadIndent(20)
            .attachmentStringWithImage("icybay.jpg", fontSize: 20, location: 20)
            .textHighlightRange(NSRange(location: 10, length: 5), color: .red, backgroundColor: model.color, tapAction: { (view, attribute, range, frame) in
                model.color = UIColor(red: CGFloat.random(in: 0 ..< 255)/255, green: CGFloat.random(in: 0 ..< 255)/255, blue: CGFloat.random(in: 0 ..< 255)/255, alpha: 1)
            }, longPressAction: nil)
            .onTapGesture {
//                model.color = .purple
            }
            
        
        
//        Text("Text 单行文本粗体.dcd")
//            .backgroundColor(.orange)
//            .margin(edge: .top, value: 10)
//            .alignSelf(.stretch)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class YYTextTestsModel_Previews:  YYTextTestsModel {
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
struct YYTextTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                YYTextTests(model: YYTextTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
