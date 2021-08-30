//
//  ArgoKitScrollView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/24.
//

import ArgoKit

// view model.
protocol ArgoKitScrollViewModelProtocol: ViewModelProtocol {
    var imgWidth: CGFloat { get set }
    var horizontalCount: Int { get set }
    var hScrollWidth: CGFloat { get set }
    var vertaicalCount: Int { get set }
}

// view
struct ArgoKitScrollView: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitScrollViewModelProtocol
    init(model: ArgoKitScrollViewModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("Horizontal Direction ScrollView")
        ScrollView {
            HStack {
                ForEach(0..<model.horizontalCount) { index in
                    Image("img_avatar_\(index)")
                        .width(ArgoValue(model.imgWidth))
                        .aspect(ratio: 1)
                }
            }
            .width(ArgoValue(model.hScrollWidth))
        }
        .width(ArgoValue(UIScreen.main.bounds.width))
        .height(ArgoValue(model.imgWidth))
        .contentSize(CGSize(width: model.hScrollWidth, height: model.imgWidth))
        .margin(edge: .top, value: 5)
        .didScroll { scrollView in
            if let view = scrollView {
                print("hDidScrollView_contentOffSetX: " + view.contentOffset.x.description)
            }
        }
        
        Text("Vertical Direction ScrollView")
            .margin(edge: .top, value: 19)
        
        ScrollView {
            ForEach(0..<model.vertaicalCount) { index in
                Image("img_avatar_\(index)")
                    .width(ArgoValue(model.imgWidth))
                    .aspect(ratio: 1)
            }
        }
        .width(100%)
        .height(300)
        .margin(edge: .top, value: 5)
        .alignItems(.center)
        .didScroll { scrollView in
            if let view = scrollView {
                print("vDidScrollView_contentOffSetY: " + view.contentOffset.y.description)
            }
        }
    }
}

extension ArgoKitScrollViewModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitScrollView(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitScrollViewModelPreviews: ArgoKitScrollViewModelProtocol {
    var imgWidth: CGFloat = 200
    var horizontalCount: Int = 10
    var hScrollWidth: CGFloat = 200
    var vertaicalCount: Int = 10
    init() {
        hScrollWidth = CGFloat(horizontalCount) * imgWidth
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
private func argoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitScrollViewPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitScrollViewModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

