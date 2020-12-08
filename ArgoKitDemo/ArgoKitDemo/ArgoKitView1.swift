//
//  ArgoKitView1.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/7.
//

import ArgoKit

struct ArgoKitView1: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: View {
        Image("scx")
            .backgroundColor(.red)
            .width(300)
            .height(200)
            .margin(edge: .left, value: 50)
            .margin(edge: .top, value: 50)
            .circle()
//            .cornerRadius(100)
            .borderWidth(5)
            .borderColor(.blue)
 
    }
}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct ArgoKitView1_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            ArgoKitView1().body
        }
    }
}
#endif
