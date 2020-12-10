//
//  PreviewDemo.swift
//  ArgoKitDemo
//
//  Created by Dai on 2020-11-26.
//

import ArgoKit

class PreviewModel {
    var label:Text?
    @Property var title: String = "is title"
    @Property var name: String = "is name"
    static var count: Int = 1
    
    func getTitle() -> String {
        Self.count += 2
        if Self.count > 10 {
            return self.name
        }
        return self.title + " \(Self.count)"
    }
}

class MyView: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    typealias View = ArgoKit.View
    var body: View {
        VStack {
            Text("MyView").textColor(.red)
        }
    }
}

class PreviewDemo: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var model = PreviewModel()
    
    typealias View = ArgoKit.View
    var body: View {
        VStack {
            MyView()
                .margin(edge: .bottom, value: 20)
                .backgroundColor(.blue)
            
            Text().text(self.self.model.getTitle())
                .lineLimit(0)
                .alias(variable: &self.model.label)
                .margin(edge: .bottom, value: 20)
                .backgroundColor(.red)
                .textAlign(.center)
            
            Button {
                print("click")
                
                let count = Swift.type(of: self.model).count
                if count > 10 {
                    self.model.name = "name \(count)"
                } else {
                    self.self.model.title = self.self.model.title
                }
                
//                if let t = self.self.model.label?.node?.text() {
//                    _ = self.self.model.label?.text(t + "click ")
//                }
//                self.self.model.title = self.self.model.label?.node?.text() ?? "init"
                
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
//        SwiftUI.Text("aaaaa")
    }
}
#endif
