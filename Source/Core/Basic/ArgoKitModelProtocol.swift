//
//  ArgoKitModelProtocol.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/10.
//

import Foundation
public protocol ArgoKitModelProtocol {
    var rowid: String { get set }
}
extension ArgoKitModelProtocol{
    var rowid: String {
        "argokitmodel"
    }
}
