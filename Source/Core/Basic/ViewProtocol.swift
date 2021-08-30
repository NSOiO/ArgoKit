//
//  View.WithModel.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-18.
//

import Foundation

public protocol ViewProtocol2: View {
    associatedtype ModelType
    init(model: ModelType)
}

public typealias ViewProtocol = ViewProtocol2 & View

