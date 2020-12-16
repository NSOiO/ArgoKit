//
//  ArgoKitInstance.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/3.
//

import Foundation
public class ArgoKitInstance {
    
    private var pimageLoader:ArgoKitImageLoader?
    private var plistPreviewService: ArgoKitListPreviewService?
    
    static var shared: ArgoKitInstance = {
        let instance = ArgoKitInstance()
        return instance
    }()
    private init() {}
    
    public class func registerImageLoader(imageLoader:ArgoKitImageLoader?){
        ArgoKitInstance.shared.pimageLoader = imageLoader
    }
    
    public class func imageLoader()->ArgoKitImageLoader?{
       return ArgoKitInstance.shared.pimageLoader
    }
    
    public class func registerPreviewService(previewService: ArgoKitListPreviewService) {
        ArgoKitInstance.shared.plistPreviewService = previewService
    }
    
    public class func listPreviewService()->ArgoKitListPreviewService?{
       return ArgoKitInstance.shared.plistPreviewService
    }
}
