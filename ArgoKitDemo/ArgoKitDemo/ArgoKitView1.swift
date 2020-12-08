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
//        Text("scxasxaxsa")
//            .backgroundColor(.red)
//            .width(500)
//            .height(500)
//            .margin(edge: .top, value: 150)
////            .cornerRadius(topLeft: 0, topRight: 0, bottomLeft: 30, bottomRight: 140)
////            .borderWidth(2)
////            .borderColor(.blue)
////            .gradientColor(startColor: UIColor.red, endColor: UIColor.yellow, direction: ArgoKitGradientType.TopToBottom)
//            .addBlurEffect(style: .dark,alpha: 0.5,color:nil)
            
//
        HStack{


            Text("scxdcsdcs")
                .backgroundColor(.clear)
                .width(500)
                .height(500)
                .margin(edge: .left, value: 50)
                .backgroundColor(.yellow)

            BlurEffectView(style: UIBlurEffect.Style.light){

            }.width(200)
            .height(200)
            .positionType(.absolute)
            .position(top: 0, right: 0, bottom: 0, left: 0)
//            .alpha(0.8)
        }.width(400).height(400).margin(edge: .top, value: 100)
        
 
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
