//
//  ListTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit

// view model.
class ListTestsModel {

}

struct LandRow: View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var landmark: Landmark
    init(landmark: Landmark) {
        self.landmark = landmark
    }
    
    var body: ArgoKit.View {
        Text("我是样式0").size(width: 100%, height: 44).alignContent(.center)
        HStack {
            self.landmark.image
                .resizable()
                .size(width: 50, height: 50).cornerRadius(10).clipsToBounds(true)
            Spacer()
            HStack{
                Text(self.landmark.name).alignSelf(.center)
            }.backgroundColor(.yellow)
            Spacer()
            Text(self.landmark.name)
        }
    }
}

class ListCellModel: ArgoKitIdentifiable {
    var reuseIdentifier = "idd"
    var name = "name.."
}


// view
class ListTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ListTestsModel
    init(model: ListTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        
//        let data = [landmarkDatopa[0]]
        
        VStack {
            Text("aa")
            
//            List(data: [ListCellModel()]) { landmark in
//                Text(landmark.name)
//            }
//            .backgroundColor(.red)
            
            List {
                Text("t1")
                    .height(100)
                    .backgroundColor(.lightText)
                    .margin(edge: .bottom, value:10)
                Text("t2")
                    .backgroundColor(.lightText)

            }
            .backgroundColor(.lightText)
            
        }
        .height(100%)
        .backgroundColor(.lightGray)
        
//        ArgoKit.List(data:landmarkData) { landmark in
////            switch landmark.reuseIdentifier {
////            case "LandmarkRow1":
////                LandmarkRow1(landmark: landmark)
////            case "LandmarkRow2":
////                LandmarkRow2(landmark: landmark)
////            default:
////                LandmarkRow(landmark: landmark)
////            }
//            LandmarkRow2(landmark: landmark)
//        }
//        .size(width: 100%, height: 100%)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ListTestsModel_Previews:  ListTestsModel {

}

@available(iOS 13.0.0, *)
struct ListTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
        return ArgoRenderList {
            ListTests(model: ListTestsModel_Previews())
        }
    }
}
#endif
