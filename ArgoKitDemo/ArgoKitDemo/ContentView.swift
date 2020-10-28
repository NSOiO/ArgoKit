//
//  ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import Foundation
import UIKit
import ArgoKit
struct ContentView:View {
    let items = ["查查","cscs","122e"]
    var body:View{
//        ForEach(items){item in
//            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
//                .left(point: 20).textColor(.red).marginRight(point:20)
//        }.row()
//        HStack{
//            ImageView("turtlerock") { () -> View in
//                Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//                    .left(point: 20).textColor(.red)
//            }
//        }
//        Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//            .left(point: 20).textColor(.red)
//        HStack{
//            Button(text: "buttom"){
//                print("buttom1")
//
//            }.backgroundColor(.orange).width(point: 100).height(point: 100)
//
//            ImageView().image(UIImage(named: "turtlerock")).width(point: 100).height(point: 100).left(point: 20)
//        }
        List(data: items) { item in
            HStack{
                ImageView().image(UIImage(named: "turtlerock")).width(point: 100).height(point: 100)
                
                Text(item as? String).backgroundColor(.yellow).width(point: 200).height(point: 100)
            }
        }.width(point: 414).height(point: 720)
    }
}
