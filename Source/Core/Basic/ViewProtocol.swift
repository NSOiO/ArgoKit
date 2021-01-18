//
//  View.WithModel.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-18.
//

import Foundation

public protocol ViewProtocol: View {
    associatedtype ModelType
    init(model: ModelType)
}

