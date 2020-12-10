//
//  TextTests.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-12-07.
//

import ArgoKit

class LayoutTests: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
        VStack {
            Text("text 1")
                .backgroundColor(.blue)
                .textAlign(.center)
                .borderColor(.red)
                .borderWidth(2)
                .cornerRadius(12)
                .margin(edge: .all, value: 20)


            Text("text 1.1")
                .backgroundColor(.blue)
                .textAlign(.center)
                .padding(edge: .left, value: 200)
                .margin(edge: .top, value: 10)
                .margin(edge: .bottom, value: 10)

            Text("text 1.1")
                .backgroundColor(.blue)
                .textAlign(.justified)
                .padding(edge: .left, value: 200)

            Spacer().height(10).backgroundColor(.lightText)

            Text("text 2")
                .backgroundColor(.red)
                .alignSelf(.start)
                .padding(edge: .left, value: 10)
                .padding(edge: .right, value: 10)
                .cornerRadius(10)
            Text("text3").padding(edge: .left, value: 10)
                
        }
        .justifyContent(.start)
        .alignItems(.stretch)
        .padding(edge: .all, value: 20)
        .height(100%)
    }
}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct TextTests_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            LayoutTests()
        }
    }
}
#endif
