//
//  YYTextTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-15.
//

import ArgoKit
import ArgoKitComponent
// view model.
class YYTextTestsModel {
    @Observable var color:UIColor = .red
    var arribut:NSMutableAttributedString
    init() {
        arribut = NSMutableAttributedString(string: "单行文本粗体单行.单行文本粗体单行.单行文")
//        arribut.yy_obliqueness = -2.0
//        arribut.yy_color = .gray
//        arribut.yy_setTextStrikethrough(YYTextDecoration(style: .single,width: 1,color: .red), range: NSRange(location: 0, length: arribut.length))
    }
    
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
        Text()
        YYText()
            .attributedText(model.arribut)
            .lineLimit(3)
            .lineSpacing(10)
//            .textColor(.red)
            .font(size: 20)
            .font(style: .bold)
            .backgroundColor(.yellow)
            .margin(edge: .top, value: 10)
            .alignSelf(.stretch)

        YYText("Text单行文本粗体.单行文本粗体单行.单行文本粗体单行.单行文本粗体单行")
            .font(size: 15)
            .font(style: .bold)
            .backgroundColor(.green)
            .margin(edge: .top, value: 10)
            .alignSelf(.stretch)
            .lineLimit(1)
            .textBorder(style: .single, width: 2, color: .yellow,cornerRadius: 5,range: NSRange(location: 5, length: 4))
//            .baseWritingDirection(.rightToLeft)
//            .textColor(.gray,range:model.range1)
//            .textColor(.gray,range:)
            .baselineOffset(2.0)
            .underline(style:[.single],width: 1.0, color: .red)
            .strikethrough(style:[.single],width: 1.0, color: .red)
//            .textShadowColor(.purple)
//            .textShadowOffset(CGSize(width: 5, height: 5))
//            .textShadowBlurRadius(0.6)
            .setLink(range: NSRange(location: 5, length: 5), color: .blue, backgroundColor: .yellow, tapAction: { link in
                print("setLink:\(link)")
            })
//            .kern(5)
            .firstLineHeadIndent(20)
            .attachmentStringWithImage("icybay.jpg", fontSize: 15, location: 15)
            .textHighlightRange(NSRange(location: 10, length: 5), color: .red, backgroundColor: model.color, tapAction: { (attribute, range) in
                print("textHighlightRange:\(attribute),range:\(attribute.attributedSubstring(from: range))")
            }, longPressAction: nil)
            .onTapGesture {
                print("onTapGesture")
            }
            .truncationToken("----")
            .tabStops({ () -> [NSTextTab] in
                let tab1:NSTextTab = NSTextTab(textAlignment: .natural, location: 10)
                let tab2:NSTextTab = NSTextTab(textAlignment: .right, location: 20)
                return [tab1,tab2]
            })
            .defaultTabInterval(3)
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
