//
//  ListTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-11.
//

import ArgoKit


protocol ListTestsModelProtocol: ViewModelProtocol {
    var name: String { get }
    var dataSource: DataSource<[ListCellTestsModelProtocol]> { get }
}

// view
struct  ListTests: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ListTestsModelProtocol
    init(model: ListTestsModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        List(data: model.dataSource) { cellModel in
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
//        self.dataSource = datas
        self.dataSource.append(contentsOf: datas)
    }
}

extension ListTestsModelProtocol {
    func makeView() -> View {
        ListTests(model: self)
    }
}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ListTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ListTests(model: ListTestsModel_Previews())
        }
    }
}
#endif
