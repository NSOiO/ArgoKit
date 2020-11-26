//
//  PreviewDemo.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-11-26.
//

import ArgoKit

struct PreviewDemo: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("Hello, World!")
        }
        .width(100%)
        .height(400)
        .justifyContent(.between)
        .backgroundColor(UIColor.init(red: 0.3, green:0.4, blue: 0.6, alpha:0.3))
    }
}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct PreviewDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            PreviewDemo().body
        }
        
    }
}
#endif
