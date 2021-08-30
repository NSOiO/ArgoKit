//
//  ForEachTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-14.
//

import ArgoKit

// view model.
protocol ArgoKitForEachModelProtocol:ViewModelProtocol{
    var titles: [String] {get set}
}
extension ArgoKitForEachModelProtocol{
    func makeView() -> View {
        ArgoKitForEach(model: self)
    }
}
// view
struct ArgoKitForEach: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitForEachModelProtocol
    init(model: ArgoKitForEachModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
            HStack {
                VStack{
                    ForEach(model.titles) { item in
                        Text(item).margin(edge: .top, value: 23)
                    }
                }
                VStack{
                    ForEach(0..<20) { item in
                        Text(String(item)).margin(edge: .top, value: 3)
                    }
                }.margin(edge: .left, value: 50)
                
                VStack{
                    ForEach(model.titles) { item in
                        Text(item).margin(edge: .left, value: 23).margin(edge: .top, value: 23)
                    }
                }
            }
            .grow(1)
      
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ForEachTestsModel_Previews:  ArgoKitForEachModelProtocol {
    var titles: [String] = []
    init() {
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
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ForEachTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitPreview_EmptyView()
        ArgoKitRender {
            ForEachTestsModel_Previews().makeView()
        }
    }
}
#endif
