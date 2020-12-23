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
            
        },began:{gesture,location,velocity in
            print("began:\(location):velocity\(velocity)")
        },moved:{gesture,location,velocity in
            print("moved:\(location):velocity:\(velocity)")
            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + location.x, y: (gesture.view?.center.y)! + location.y)
            gesture.setTranslation(CGPoint.zero, in: gesture.view?.superview)
        
        },ended: { (_, _, _) in
        }) {(view, x, y) in
           
        }
        .onBegan { (gesture,location,velocity) in
            print("moved:\(location):velocity:\(velocity)")
            gesture.view?.center = CGPoint(x: (gesture.view?.center.x)! + location.x, y: (gesture.view?.center.y)! + location.y)
            gesture.setTranslation(CGPoint.zero, in: gesture.view?.superview)
        }
        Image("icybay.jpg")
            .height(100)
            .shrink(1)
            .aspect(ratio: 1)
            .margin(edge: .top, value: 40)
            .circle().gesture(gesture: gesture)

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
struct ArgoKitImageTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitImageTest(model: ArgoKitImageTestModel_Previews())
        }
    }
}
#endif
