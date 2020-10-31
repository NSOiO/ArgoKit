//
//  Text.Bind.swift
//  ArgoKit
//
//  Created by Dai on 2020-10-30.
//

import Foundation

extension Text {
    public init(_ textProperty: Property<String>) {
        self.init(textProperty.wrappedValue)
        _ = textProperty.subscribe { [self] (new) in
            label.text = new
        }
    }
}
