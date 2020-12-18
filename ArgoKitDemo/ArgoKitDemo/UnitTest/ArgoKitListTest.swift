//
//  ArgoKitListTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitListTestModel :ArgoKitIdentifiable{
    public var reuseIdentifier: String = "ArgoKitListTestModel"
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?

    var textCom:Text?
    var hidden:Bool = false
}

// view model.
class ArgoKitListCellModel :ArgoKitIdentifiable{
    public var reuseIdentifier: String = "ArgoKitListTestModel"
    var imagePath:String?
    var sessionName:String? = "sessionName"
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?

    var textCom:Text?
    var hidden:Bool = false
}
// view
struct ArgoKitCellTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitListCellModel
    init(model: ArgoKitListCellModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text(self.model.sessionName)
    }
}

// view
struct ArgoKitListTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitListTestModel
    private var models: [ArgoKitListTestModel] = [ArgoKitListTestModel]()
    init(model: ArgoKitListTestModel) {
        self.model = model
        for index in 1..<1000{
            let item = ArgoKitListTestModel()
            item.sessionName = String(index)
            item.unreadCount = String(index)
            models.append(item)
        }
    }
    
    var body: ArgoKit.View {
        
        List(data:models){ data in
            
            Text(data.sessionName)
                .lineLimit(2)
                .width(150)
                .alias(variable: &data.textCom)
            
            
            Image("icybay.jpg")
                .aspect(ratio: 1)
                .onTapGesture {
                    data.textCom?.text("asdacbdskbcvhjkdsbvcdfjbvhjkdfbvdkfjbvfdkjbvdfkjb")
                }
        }.grow(1.0)
        .didSelectRow { (mode, index) in
            print("\(mode)")
        }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitListTestModel_Previews:  ArgoKitListTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitListTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
        return ArgoRender {
            ArgoKitListTest(model: ArgoKitListTestModel_Previews()).grow(1)
        }
    }
}
#endif
