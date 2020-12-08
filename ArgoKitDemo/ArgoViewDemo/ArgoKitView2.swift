//
//  ArgoKitView2.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-07.
//

import ArgoKit

class ArgoKitView2: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: View {
        return VStack {
            Image("turtlerock")
                .width(100)
                .height(100)
                .backgroundColor(.red)
            
            Image(url: URL(string: "https://img.momocdn.com/album/95/62/9562CD67-C76A-1437-29D7-58AB7F421B4820181023_S.jpg"), placeholder: "turtlerock")
                .width(100)
                .height(100)
            
            Image("turtlerock")
                .width(100)
                .height(100)
                .backgroundColor(.red)
        }
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG

import ArgoKitPreview
import SwiftUI
import ArgoKitComponent

@available(iOS 13.0.0, *)
struct ArgoKitView2_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())

        return ArgoRender {
            ArgoKitView2()
        }
    }
}
#endif
