//
//  ListTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit

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

class ListTestsModel:  ArgoKitIdentifiable {
    var reuseIdentifier = "idd"
    var name = "name..ss"
    @DataSource var dataSource:DataList<ListCellTestsModel> = []

}

// view
struct  ListTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ListTestsModel
    init(model: ListTestsModel) {
        self.model = model
    }
        
    var body: ArgoKit.View {
        List(data: model.$dataSource) { cellModel in
            ListCellTests(model: cellModel)
                .padding(edge: .bottom, value: 10)
        }
        .height(100%)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ListTestsModel_Previews:  ListTestsModel {
    override init() {
        super.init()
        var datas = [ListCellTestsModel_Previews]()
        for _ in 0..<10 {
            datas.append(ListCellTestsModel_Previews())
        }
        self.dataSource = datas
    }
}

@available(iOS 13.0.0, *)
struct ListTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
        return ArgoRender {
            ListTests(model: ListTestsModel_Previews())
        }
    }
}
#endif
