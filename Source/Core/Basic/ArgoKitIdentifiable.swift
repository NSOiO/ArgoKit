//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation

public protocol ArgoKitIdentifiable {
    var identifier : String { get set }    // 数据的唯一标识, 可缺省
    var reuseIdentifier: String { get set } // 复用标识，用于同样式的UI复用
}

extension ArgoKitIdentifiable{
    
    var reuseIdentifier: String {
        "ArgoKitDefaultReuseIdentifier"
    }
    
    var identifier: String {
       String("\(self)".hashValue)
    }
}
