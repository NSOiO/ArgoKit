//
//  SpacerTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit

// view model.
protocol ArgoKitSpacerModelProtocol:ViewModelProtocol {

}
extension ArgoKitSpacerModelProtocol{
    func makeView() -> View {
        ArgoKitSpacer(model: self)
    }
}
// view
struct ArgoKitSpacer: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitSpacerModelProtocol
    init(model: ArgoKitSpacerModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text("Text 1")
            Spacer()
                .backgroundColor(.red)
                .height(100)
            
            
            Spacer()
                .backgroundColor(.blue)
                .height(10)
            
            
            
            Text("Text 2")
            Text("Text 3")
            Text("Text 4")
            Text("Text 5")
        }
        .backgroundColor(.lightGray)
        .height(100%)
//        .justifyContent(.between)
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitSpacerModel_Previews:  ArgoKitSpacerModelProtocol {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct SpacerTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoKitRender {
            ArgoKitSpacerModel_Previews().makeView()
        }
    }
}
#endif
