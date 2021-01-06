//
//  LandmarkRow.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-17.
//

import ArgoKit

// view
struct LandmarkRow: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: Landmark
    init(model: Landmark) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            model.image
                .size(width: 50, height: 50)
                .margin(edge: .right, value: 5)
                .circle()
            
            Text(model.name)
            Spacer()
            
            Image("star.fill")
                .size(width: 20, height: 20)
                .hidden(!model.isFavorite)
            
            
        }
        .alignItems(.center)
        .padding(edge: .horizontal, value: 5)
        .padding(edge: .vertical, value: 20)
        
        RowLine()
            .height(10)
    }
    
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI


@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        SwiftUI.Group {
            ArgoKitRender {
                LandmarkRow(model: landmarkData[0])
            }
            ArgoKitRender {
                LandmarkRow(model: landmarkData[1])
            }
        }
        .previewLayout(.fixed(width: 300, height: 200))
    }
}
#endif
