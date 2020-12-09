//
//  ArgoKitView1.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/7.
//

import ArgoKit


struct ArgoKitView2: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    typealias View = ArgoKit.View
    var body: View {
        Text("scxasxaxsa")
            .backgroundColor(.red)
            .margin(edge: .top, value: 150)
            .cornerRadius(topLeft: 0, topRight: 0, bottomLeft: 30, bottomRight: 140)
            .borderWidth(2)
            .borderColor(.blue)
            .gradientColor(startColor: UIColor.red, endColor: UIColor.yellow, direction: ArgoKitGradientType.TopToBottom)
        
        TextView(text:"da")
            .alignSelf(.start)
//            .width(100).height(40)
            .backgroundColor(.yellow)
            .cornerRadius(3)
            .margin(edge: .left, value: 50)
//            .textAlign(.center)
        
        TextField("haha",placeholder: "").width(100).backgroundColor(.red).height(20)
            .padding(edge: .left, value: 10)
            .padding(edge: .bottom, value: 5)

    }
}

struct ArgoKitView1: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var body: View {
//          ArgoKitView2().margin(edge: .left, value: 100)
        Image("icybay.jpg")
            .margin(edge: .top, value: 100)
            .margin(edge: .left, value: 50)
            
            .padding(edge: .left, value: 150)
            
            .width(100)
            .height(100)
        

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
