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
        ArgoKitCellTest(model: ArgoKitListCellModel())
        List{
            Text("dsds11")
            Text("dsds22")
            Text("dsds333")
        }
        .backgroundColor(.red)
////
//        List(data:models){ data in
//            Text(data.sessionName)
//                .height(50)
//        }
//        .width(100%)
//        .height(400)
//        .backgroundColor(.red)
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
        return ArgoRender {
            ArgoKitListTest(model: ArgoKitListTestModel_Previews())
        }
    }
}
#endif
