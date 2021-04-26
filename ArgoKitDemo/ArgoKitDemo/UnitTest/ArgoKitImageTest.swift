//
//  ArgoKitImageTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitImageTestModel {

}

// view
struct ArgoKitImageTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitImageTestModel
    init(model: ArgoKitImageTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        let gesture = PanGesture(onPanGesture:{gesture in
            
        })
        .onMoved { gesture,location,velocity in
            print("moved111:\(location):velocity:\(velocity)")
        }
        .onBegan {  gesture,location,velocity,direction in
            switch(direction){
            case .top:
                print("上")
                break
            case .left:
                print("左")
                break
            case .bottom:
                print("下")
                break
            case .right:
                print("右")
                break
            default:
                break
            }
        }
//        .enabelGragView(true)
  
        Image("icybay.jpg")
            .height(100)
            .shrink(1)
            .aspect(ratio: 1)
            .margin(edge: .top, value: 40)
            .circle()
            .gesture(gesture)

        Image("icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.end)
            .margin(edge: .top, value: 10)
            .margin(edge: .right, value: 10)
            .backgroundColor(.yellow)
            .cornerRadius(10)
        
        Image("icybay.jpg")
            .width(150)
            .aspect(ratio: 1)
            .alignSelf(.center)
            .margin(edge: .top, value: 10)
            .backgroundColor(.yellow)
            .cornerRadius(10)
            .borderWidth(2)
            .borderColor(.red)
        
        Image("icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.stretch)
            .margin(edge: .top, value: 10)
            .backgroundColor(.clear)
            .shadow(color: .orange, offset: CGSize(width: 20, height: 20), radius: 13, opacity: 0.7, corners: .allCorners)
        
        // 加载远程图片
        Image(urlString:"https://upload-images.jianshu.io/upload_images/2269924-cb233fc2d56eee8d.png?imageMogr2/auto-orient/strip|imageView2/2/w/599/format/webp", placeholder: "icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.center)
            .margin(edge: .top, value: 10)
            .backgroundColor(.clear)
            .shadow(color: .orange, offset: CGSize(width: 20, height: 20), radius: 13, opacity: 0.7, corners: .allCorners)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitImageTestModel_Previews:  ArgoKitImageTestModel {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitImageTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitImageTest(model: ArgoKitImageTestModel_Previews())
        }
    }
}
#endif
