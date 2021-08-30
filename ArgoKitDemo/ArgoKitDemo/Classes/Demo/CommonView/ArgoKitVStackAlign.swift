//
//  VStackAlignTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
protocol ArgoKitVStackAlignModelProtocol : ViewModelProtocol {

}
extension ArgoKitVStackAlignModelProtocol{
    func makeView() -> View {
        ArgoKitVStackAlign(model: self)
    }
}

// view
struct ArgoKitVStackAlign: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitVStackAlignModelProtocol
    init(model: ArgoKitVStackAlignModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            Text("Hello, World! 1")
            Text("Hello, World! 2")
            Text("Hello, World! 3")
            Text("Hello, World! 4")
                .backgroundColor(.orange)
            Text("Hello, World! 5")
                .backgroundColor(.blue)
        }
        .backgroundColor(.red)
        .alignItems(.center)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class VStackAlignTestsModel_Previews:  ArgoKitVStackAlignModelProtocol {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct VStackAlignTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoKitRender {
            VStackAlignTestsModel_Previews().makeView()
        }
    }
}
#endif
