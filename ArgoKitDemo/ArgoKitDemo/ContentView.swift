//
//  ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import Foundation
import UIKit
import ArgoKit

struct TestModel {
    @Property var title: String
}

class ContentView:View {
    var pNode = ArgoKitNode(viewClass: UIView.self)
    var node: ArgoKitNode?{
        pNode
    }
    let items = ["查查","cscs","122e"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    var model: TestModel
    @Property var title: String = "dsdsd"
    init() {
        model = TestModel(title: "hahah")
    }
    var body:View{
        Text("")
            .text(title)
            .textAlign(.center)
            .margin(edge: .top, value: 100).onTapGesture {
                self.title = "dasada"
            }
//        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
//            print("UISlider ", value)
//        }).width(200).height(30)
//        .margin(edge: .top, value: 30)
//
//
//        Toggle(true){ isOn in
//            print("Toggle :",isOn)
//        }.margin(edge: .top, value: 10)
//
//
//        Stepper(value: 10, in: 0...100, step: 4) { value in
//            print("Stepper :",value)
//    }.width(100).height(30).margin(edge: .left, value: 30)
//
//
//        SegmenteControl { index in
//            print("items :",index)
//        } _: {
//           Text("e")
//           Text("r")
//           Text("t")
//           Text("u")
//           ImageView("turtlerock")
//        }.width(100%).height(30).margin(edge: .top, value: 50)
//
//
//        //
//        Button("") {
//            print("buttom1")
//            model.title = "turtlerock111"
//        } builder: {
//
//        }.alignItems(.center).backgroundColor(.cyan).width(100%)
//
//
////        ForEach(items){item in
////            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
////                .left(point: 20).textColor(.red).marginRight(point:20)
//////        }.row()
//        HStack{
//            ImageView("turtlerock")
//            Text("sds").backgroundColor(.yellow).width(100).height(100).margin(edge: .top, value: 50)
//                .position(edge: .left, value: 30)
//                .textColor(.red)
//            Text("sds").backgroundColor(.yellow).width(100).height(100).margin(edge: .top, value: 50)
//                .position(edge: .left, value: 20).textColor(.red)
//        }.onTapGesture {
//            print("tapAction")
//        }
        
//        DatePicker { date in
//
//        }.width(percent: 100).height(point: 100).marginTop(point: 10).backgroundColor(.yellow)
//
//
//        HStack{
//            Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//                .left(point: 20).textColor(.red)
//            BlurEffectView(style:.dark) {
//                Text("sds").backgroundColor(.yellow).width(percent: 50).height(percent: 50).marginTop(point: 5)
//                    .left(point: 20).textColor(.red)
//            }.width(point: 100).height(point: 100).marginTop(point: 50)
//            .left(point: 20)
//        }.gesture(gesture: gestur)
//
//            Button("") {
//                print("buttom1")
//            } builder: {
//                Text("sdshha").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//                    .left(point: 20).textColor(.red).textAlignment(.center)
//            }.alignItemsCenter()
//
//            Toggle(true){ isOn in
//                print("Toggle :",isOn)
//            }
//
//        }
   
    }
}
