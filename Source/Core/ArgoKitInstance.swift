//
//  ArgoKitInstance.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/3.
//

import Foundation
public class ArgoKitInstance {
    private var pimageLoader:ArgoKitImageLoader?
    static var shared: ArgoKitInstance = {
        let instance = ArgoKitInstance()
        return instance
    }()
    private init() {}
    
    public class func registerImageLoader(imageLoader:ArgoKitImageLoader?){
        ArgoKitInstance.shared.pimageLoader = imageLoader
    }
    
    class func imageLoader()->ArgoKitImageLoader?{
       return ArgoKitInstance.shared.pimageLoader
    }
    
}
