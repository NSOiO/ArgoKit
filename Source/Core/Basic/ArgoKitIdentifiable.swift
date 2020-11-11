//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation
public protocol ArgoKitIdentifiable {
    var rowid: String { get set }
}
extension ArgoKitIdentifiable{
    var rowid: String {
        "argokitmodel"
    }
}
