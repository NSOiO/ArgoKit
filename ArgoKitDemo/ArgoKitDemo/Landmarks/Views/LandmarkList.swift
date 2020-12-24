//
//  LandmarkList.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-17.
//

import ArgoKit

class HeaderModel: ArgoKitIdentifiable {
    var reuseIdentifier: String { "idd" }
}

// view
struct LandmarkList: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    var toggleModel: ToggleRowModel
    @Alias var list: List<Landmark>? = nil
    var datas: [Landmark]
    
    private var model: UserData
    init(model: UserData) {
        self.model = model
        self.datas = model.landmarks
        
        self.toggleModel = ToggleRowModel()
        self.toggleModel.action = { [self] isOn in
            self.toggleModel.isON = isOn
            let datas = model.landmarks.filter { landmark -> Bool in
                landmark.isFavorite || !isOn
            }
            
//            self.list?.reloadData(datas, sectionHeaderData: HeaderModel(), sectionFooterData: nil)
            
            let count = model.landmarks.count
            var indexPaths = [IndexPath]()
            for idx in 0..<count {
                indexPaths.append(IndexPath.init(row: idx, section: 0))
            }
            self.list?.reloadRows(datas, at: indexPaths, with: .bottom)
        }
    }
    
    var body: ArgoKit.View {
        VStack {
            List(.grouped ,data: model.landmarks) { landmark in
                LandmarkRow(model: landmark)
            }
            .height(100%)
            .sectionHeader([HeaderModel()]) { _ in
                ToggleRow(model: self.toggleModel)
            }
            .alias(variable: $list)
            
        }
        
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
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct LandmarkList_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            LandmarkList(model: UserData())
        }
    }
}
#endif
