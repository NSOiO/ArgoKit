//
//  ArgoKitPreviewConfig.swift
//  ArgoKitPreview
//
//  Created by Dongpeng Dai on 2020/12/29.
//

import Foundation
import ArgoKit

#if DEBUG && canImport(ArgoKitComponent) && canImport(ArgoKitPreview)
import ArgoKitComponent
import ArgoKitPreview
// MARK: clang diagnostic pop

var _argokit__preview_dep_ = ArgoKit.Dep()

//__attribute__((constructor))
func _argokit_preview_config_() {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
}
//var _argokit_constructor_: Void = { _argokit_preview_config_() }()

//class _ArgoKitPreview_Config_: NSObject {
//    @objc override class func load() {
//
//    }
//}


#endif
