//
//  PreviewDemo.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-11-26.
//

import ArgoKit

class PreviewModel {
    var label:Text?
}

struct MyView: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: View {
        VStack {
            Text("MyView").textColor(.red)
        }
    }
}

struct PreviewDemo: ArgoKit.View {
    var model = PreviewModel()
    
    typealias View = ArgoKit.View
    var body: View {
        VStack {
            MyView()
                .margin(edge: .bottom, value: 20)
                .backgroundColor(.blue)
            
            Text("aabbbbbbbbfldjaflajsflajsflkjasfl;ads")
                .lineLimit(0)
                .alias(variable: &model.label)
                .margin(edge: .bottom, value: 20)
            Button {
                print("click")
                if let t = self.model.label?.node?.text() {
                    _ = self.model.label?.text(t + "click ")
                }
//                self.model.text?.text("\(self.model.text?.text)" + "click  ")
            } builder: { () -> View in
                Text("Click")
                Image(".iamge")
                VStack {
                    Text("")
                }
            }

            Text("Hello, World! Second")
                .lineLimit(0)
//            Spacer()
        }
        .width(100%)
        .height(90%)
//        .justifyContent(.between)
        .backgroundColor(UIColor.init(red: 0.3, green:0.4, blue: 0.6, alpha:0.3))
        .margin(edge: .top, value: 100)
    }
}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct PreviewDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            PreviewDemo()
        }
    }
}
#endif
