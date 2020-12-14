//
//  ListCellTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
class ListCellTestsModel {
    var title: String = ""
    var iconURL: URL? = nil
}

// view
struct ListCellTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ListCellTestsModel
    init(model: ListCellTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            HStack {
                Image(url: model.iconURL, placeholder: "turtlerock")
                    .width(40)
                    .height(40)
            }
//            .backgroundColor(.red)
            
            Text(model.title)
                .lineLimit(0)
                .font(size: 14)
            
            HStack {
                
            }
            .wrap(.wrap)
        }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ListCellTestsModel_Previews:  ListCellTestsModel {
    override init() {
        super.init()
        self.title = "军用枪射击技能培训～～第一次拿枪，教练超吃惊，完全不相信我第一次打枪～～(o^^o)开森，射击技能点有加成～～"
        self.iconURL = URL(string: "http://img.momocdn.com/feedimage/A1/D2/A1D2FE38-F933-4758-924C-CD5AC0E7AD8720201213_400x400.jpg")
        
    }
}

@available(iOS 13.0.0, *)
struct ListCellTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ListCellTests(model: ListCellTestsModel_Previews())
        }
    }
}
#endif
