//
//  ArgoKitImageLoader.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/3.
//

import Foundation
public protocol ArgoKitImageLoader {
    func loadImage(url: URL?, successed: ((UIImage)->())?, failure: ((Error?)->())?)
}
