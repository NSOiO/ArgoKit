//
//  TextBindTests.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2020/12/28.
//

import ArgoKit

// view model.
class TextBindTestsModel {
    @Property var fontSize: CGFloat = 12
    @Property var fontStyle: AKFontStyle = AKFontStyle.default
    
    @Property var myTitle: String = "text"
    @Property var myTitleA: String = "textA"
    @Alias var titleText: Text?
    
    var count: Int = 0
    
    @Property var icon = "star.fill"
}

// view
struct TextBindTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: TextBindTestsModel
    init(model: TextBindTestsModel) {
        self.model = model
    }
    
    func getTitle() -> String {
        return model.$myTitle.wrappedValue
    }
    
    var body: ArgoKit.View {
        VStack {
            Text(model.myTitle)
                .font(size: model.fontSize)
                .onTapGesture {
//                    model.myTitle = "change"
                }
                .backgroundColor(.lightGray)
                .alias(variable: model.$titleText)

            Image().image(UIImage(named: model.icon))
                .onTapGesture {
                    if model.icon == "star" {
                        model.icon = "star.fill"
                    } else {
                        model.icon = "star"
                    }
                }
                .size(width: 50, height: 50)
            
            Button {
                model.count += 1
                model.myTitle = "text \(model.count)"
                model.myTitleA = "textA \(model.count)"
            } builder: {
                Text("button-11")
            }
            .backgroundColor(.yellow)
            .alignItems(.start)
            
            Button {
                model.titleText?.text(model.myTitleA)
            } builder: {
                Text("change")
            }
            .backgroundColor(.yellow)
            .alignItems(.start)
        }
        .alignItems(.start)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class TextBindTestsModel_Previews:  TextBindTestsModel {
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
struct TextBindTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                TextBindTests(model: TextBindTestsModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
