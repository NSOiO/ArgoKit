//
//  Text.Bind.swift
//  ArgoKit
//
//  Created by Dai on 2020-10-30.
//

import Foundation

extension Text {
    public //convenience
    convenience init(_ textProperty: Property<String>?) {
        self.init()
        if let pro = textProperty {
            _ = self.text(pro)
        }
    }
    
    public func text(_ property: Property<String>?)->Self{
        return self.watch(property: property, function: self.text, key: #function)
    }
}
