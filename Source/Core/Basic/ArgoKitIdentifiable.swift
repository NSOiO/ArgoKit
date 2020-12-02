//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation

public protocol ArgoKitIdentifiable {
    var reuseIdentifier: String {get} // 复用标识，用于同样式的UI复用
}

extension ArgoKitIdentifiable{
    
    var reuseIdentifier: String {
        "ArgoKitDefaultReuseIdentifier"
    }
}
