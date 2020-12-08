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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .backgroundColor(.red)
            .textAlign(.center)
            .width(400)
            .padding(edge: .left, value: 50)
            .gradientColor(startColor: .red, endColor: .yellow, direction: .RightToLeft)
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
