//
//  ArgoKitView2.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-07.
//

import ArgoKit

var image_name = "tt"

class ArgoKitView2: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: View {
        Image(image_name)
            .width(100)
            .height(100)
            .backgroundColor(.red)
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG

import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct ArgoKitView2_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            ArgoKitView2()
        }
    }
}
#endif
