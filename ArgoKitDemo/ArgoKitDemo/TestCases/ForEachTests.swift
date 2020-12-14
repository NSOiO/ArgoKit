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
        HStack {
            
            ForEach(model.titles) { item in
                Text(item)
            }
            .flexDirection(.row)
            
            // Group
            
//            HStack {
//                ForEach() {
//                    Image().margin()
//                }
//                .padding()
//            }
            
           // List数据范型，ForEach,Scrollview，Group
            
            
            Text("ttttt")
        }
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
