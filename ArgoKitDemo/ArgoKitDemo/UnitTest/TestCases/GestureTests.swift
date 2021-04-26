//
//  GestureTests.swift
//  ArgoKitDemo
//
//  Created by Dongpeng Dai on 2020/12/21.
//

import ArgoKit

// view model.
class GestureTestsModel {
    @Alias var myText: Text? = nil
}

// view
struct GestureTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: GestureTestsModel
    init(model: GestureTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
//        let pan = PanGesture(minimumNumberOfTouches: 1, maximumNumberOfTouches: 2) { pan in
//            print("pan")
//        }
//        
//        let tap = TapGesture(numberOfTaps: 1, numberOfTouches: 1) { tap in
//            print("tap")
//        }
        
        VStack {
            Text("Hello, ArgoKit!")
                .onTapGesture {
                    self.model.myText?.text("on tap")
                    print("on tap Texst")
                }
                .onLongPressGesture {
                    self.model.myText?.text("on long press")
                }
                .alias(variable: model.$myText)
                .borderWidth(1)
                .borderColor(.blue)
//                .gesture(gesture: pan)
//                .gesture(gesture: tap)
            
            Text("Text 2")
        }
        .onTapGesture {
            print("on tap HStack")
        }
        .backgroundColor(.orange)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class GestureTestsModel_Previews:  GestureTestsModel {
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
struct GestureTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                GestureTests(model: GestureTestsModel_Previews())
                    .alignItems(.start)
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
