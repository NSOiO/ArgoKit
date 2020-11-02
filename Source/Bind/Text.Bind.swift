//
//  Text.Bind.swift
//  ArgoKit
//
//  Created by Dai on 2020-10-30.
//

import Foundation

extension Text {
    public //convenience
    init(_ textProperty: Property<String>) {
        self.init(textProperty.wrappedValue)
        let canel = textProperty.watch({[self] (new) in
            label.text = new
        })
        self.node?.bindProperties.setObject(canel, forKey: "text" as NSString)
    }
    
    public func alias(_ alias: Alias<Text?>) -> Text{
        alias.wrappedValue = self
        return self
    }
}
