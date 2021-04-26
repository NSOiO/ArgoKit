//
//  ImageBindTests.swift
//  ArgoKitDemo
//
//  Created by xindong on 2021/1/4.
//

import ArgoKit

class ImageBindTestModel {
    @Observable var image_image = "https://pic1.zhimg.com/v2-4bba972a094eb1bdc8cbbc55e2bd4ddf_1440w.jpg"
    @Observable var image_bgColor = UIColor.orange
    @Observable var image_top = 20
    @Observable var image_left = 20
    @Observable var image_width: Float = 150
    @Observable var image_height: Float = 100
    
    @Observable var tf_text = ""
    @Observable var tf_placeholder = "浪人闲话"
    @Observable var tf_textColor = UIColor.yellow
    @Observable var tf_top: Float = 20
    @Observable var tf_width: Float = 100
    @Observable var tf_height: Float = 50
    @Observable var tf_bgColor = (255, 0, 0)
    @Observable var tf_textAlign = NSTextAlignment.left
    @Observable var tf_leftView: Text = {
        Text("leftView:").textAlign(.center).backgroundColor(.blue)
    }()
}

struct ImageBindTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ImageBindTestModel
    
    init(model: ImageBindTestModel) {
        self.model = model
    }

    var body: ArgoKit.View {
        Image(urlString: model.image_image, placeholder: nil)
            .backgroundColor(model.image_bgColor)
            .margin(edge: .top, value: ArgoValue(integerLiteral: model.image_top))
            .margin(edge: .left, value: ArgoValue(integerLiteral: model.image_left))
            .width(ArgoValue(floatLiteral: model.image_width))
            .height(ArgoValue(floatLiteral: model.image_height))
            .onTapGesture {
                model.image_image = "https://img.iplaysoft.com/wp-content/uploads/2019/free-images/free_stock_photo.jpg"
                model.image_bgColor = .green
                model.image_top = 100
                model.image_left = 50
                model.image_width = 300
                model.image_height = 200
            }
        
        
        TextField(text: model.tf_text, placeholder: model.tf_placeholder)
            .margin(edge: ArgoEdge.top, value: ArgoValue(model.tf_top))
            .backgroundColor(red: model.tf_bgColor.0, green: model.tf_bgColor.1, blue: model.tf_bgColor.2)
            .textAlign(model.tf_textAlign)
            .textColor(model.tf_textColor)
            .width(ArgoValue(model.tf_width))
            .height(ArgoValue(model.tf_height))
//            .leftView{model.tf_leftView}
            .onTapGesture {
                model.tf_text = "彼岸花开🌹"
                model.tf_top = 40
                model.tf_textAlign = .center
                model.tf_width = 200
                model.tf_height = 80
                model.tf_bgColor = (0, 255, 0)
                model.tf_textColor = .red
                model.tf_leftView = Text("我是LeftView:").backgroundColor(.purple).textAlign(.center)
            }
    }
    
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import SwiftUI
import ArgoKitPreview
import ArgoKitComponent

// mock data.
class ImageBindTestsPreviewsModel: ImageBindTestModel {
    override init() {
        super.init()
    }
}
@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ImageBindTestsPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ImageBindTests(model: ImageBindTestsPreviewsModel())
        }
        .previewDisplayName("iPhone18")
    }
}
#endif
