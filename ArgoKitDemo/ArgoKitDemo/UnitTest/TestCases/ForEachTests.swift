//
//  ForEachTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
class ForEachTestsModel {
    var titles: [String] = []
}

// view
struct ForEachTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ForEachTestsModel
    init(model: ForEachTestsModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
//        ScrollView{
            HStack {
                VStack{
                    ForEach(model.titles) { item in
                        Text(item).margin(edge: .top, value: 23)
                    }
                }
                
                VStack{
                    ForEach(0..<100) { item in
                        Text(String(item)).margin(edge: .top, value: 3)
                    }
                }.margin(edge: .left, value: 50)
                
                
                Text("ttttt")
                
                List{
                    ForEach(100..<200) { item in
                        Text(String(item)).margin(edge: .top, value: 3)
                    }
                }
                .height(800)
                .width(300)
                .margin(edge: .left, value: 60)
                .backgroundColor(.red)
                .alignSelf(.start)
                

                
                // Group
                
    //            HStack {
    //                ForEach() {
    //                    Image().margin()
    //                }
    //                .padding()
    //            }
                
               // List数据范型，ForEach,Scrollview，Group
                
            
            }
            .grow(1)
//        }.width(100%)
//        .height(800)
      
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ForEachTestsModel_Previews:  ForEachTestsModel {
    override init() {
        super.init()
        for idx in 0...5 {
            self.titles.append("title \(idx)")
        }
    }
}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitPreview_EmptyView() -> SwiftUI.EmptyView {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    return SwiftUI.EmptyView()
}

@available(iOS 13.0.0, *)
struct ForEachTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitPreview_EmptyView()
        ArgoRender {
            ForEachTests(model: ForEachTestsModel_Previews())
        }
    }
}
#endif
