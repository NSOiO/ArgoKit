//
//  ADCell.swift
//  ArgoKitDemo
//
//  Created by Dai on 2021-01-26.
//

import ArgoKit

// view model.
protocol ADCellModelProtocol: ViewModelProtocol {
    var title: String { get }
    var icon: String { get }
    var isFavorite: Bool { get }
}

// view
struct ADCell: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ADCellModelProtocol
    init(model: ADCellModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        HStack {
            Image(model.icon).size(width: 50, height: 50).circle()
                .margin(edge: .right, value: 5)
            Text(model.title)
            Spacer()
            Image("star.fill").size(width: 20, height: 20)
                .hidden(!model.isFavorite)
        }
        .alignItems(.center)
        .padding(edge: .vertical, value: 20)
    }
}

extension ADCellModelProtocol {
    func makeView() -> ArgoKit.View {
        ADCell(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ADCellModel_Previews:  ADCellModel {
    override init() {
        super.init()
        self.title = "这是个ADCell"
        self.icon = "turtlerock"
    }
}

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
struct ADCell_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            ArgoKitRender {
                ADCell(model: ADCellModel_Previews())
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif
