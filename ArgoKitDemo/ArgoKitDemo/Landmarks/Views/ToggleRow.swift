//
//  ToggleRow.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-18.
//

import ArgoKit

struct RowLine: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    @Alias var line: EmptyView? = nil
    
    var body: ArgoKit.View {
        EmptyView()
            .backgroundColor(.init(0x6e, 0x6e, 0x6e))
            .alias(variable: $line)
            .height(0.5)
    }
    
    @discardableResult
    func lineHeight(_ h: Float) -> Self {
        self.line?.height(ArgoValue(h))
        return self
    }
    
    /*
     1. 动态设置高度不成功，因为还没有alias
     */
}

// TODO?继承
class ToggleRowModel {
    var isON: Bool = false
    var action: (Bool) -> Void = {_ in }
}

struct ToggleRow: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    var model: ToggleRowModel
    
    var body: ArgoKit.View {
        VStack {
            RowLine()
            
            HStack {
                Text("Show Favorites only")
                Spacer()
                Toggle(model.isON, action: { isON in
                    model.action(isON)
                })
            }
            .justifyContent(.between)
            .padding(edge: .horizontal, value: 10)
            .padding(edge: .vertical, value: 20)
            
            RowLine()
        }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

//// mock data.
class ToggleRowModel_Previews:  ToggleRowModel {
    override init() {
        super.init()
        self.isON = true
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
struct ToggleRow_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ToggleRow(model: ToggleRowModel_Previews())
        }
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
#endif
