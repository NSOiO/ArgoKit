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

var _argokit__preview_dep_ = ArgoKit.Dep()

func _argokit_preview_config_() {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
}

#endif
