//
//  ArgoKitView3.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-08.
//

import ArgoKit

class ArgoKitView3: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
        VStack {
            Image(url: URL(string: "https://img.momocdn.com/album/95/62/9562CD67-C76A-1437-29D7-58AB7F421B4820181023_S.jpg"), placeholder: "turtlerock")
                .width(100)
                .height(100)
        }
        Text("Hello, World!")
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
struct ArgoKitView3_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitView3()
        }
    }
}
#endif
