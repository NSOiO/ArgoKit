//
//  Demo1ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/2.
//

import Foundation
import UIKit
import ArgoKit
public struct DemoModel1 {
    var text1:Text?
    var stack1:HStack?
    init() {
        text1 = Text()
    }
}
var model:DemoModel1 = DemoModel1()
var text1:Text?
var stack1:HStack?
struct Demo1ContentView:View {
    var pNode = ArgoKitNode(viewClass: UIView.self)
    var node: ArgoKitNode?{
        pNode
    }
    
    let items = ["查查","cscs","122e"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    var hstack = HStack{
           ImageView("turtlerock")
                    Text("11").backgroundColor(.yellow).height(100).margin(edge: .top, value: 50).position(edge: .left, value: 20)
                        .textColor(.red).alias(variable: &model.text1)
                    Text("111111").backgroundColor(.yellow).height(100).margin(edge: .top, value: 50).position(edge: .left, value: 20)
                        .textColor(.red)
    }.isUserInteractionEnabled(true).margin(edge: .top, value: 64)
                .alias(variable: &model.stack1).onLongPressGesture(numberOfTaps: 1, numberOfTouches: 1, minimumPressDuration: 0.5){
                    print("longPressAction")
                }.onTapGesture {
                    model.text1?.text("hjdjhfbdhjbfd").width(1000)
                }.backgroundColor(.orange)
  
    init() {
//        let size:CGSize = hstack.applyLayout()
//        print("size--height:",size.height)
//        node = hstack.node
       

    }
    var body:View{        
//        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
//            print("UISlider ", value)
//        }).width(200).height(30).margin(edge: .top, value: 60)
////
////
//        Toggle(true){ isOn in
//            print("Toggle :",isOn)
//        }.margin(edge: .top, value: 50)
//
////
//        Stepper(value: 10, in: 0...100, step: 4) { value in
//            print("Stepper :",value)
//        }.width(100).height(30).margin(edge: .left, value: 150).value(50).backgroundColor(.cyan)
////
//        PageControl(currentPage: 1, numberOfPages: 10){ index in
//            print("index:",index)
//        }.width(100%).height(50).backgroundColor(.red).margin(edge: .top, value: 100)
//////
//        SegmenteControl { index in
//            print("items :",index)
//        } _: {
//           Text("e")
//           Text("r")
//           Text("t")
//           Text("u")
//           ImageView("turtlerock")
//        }.width(100%).height(30).margin(edge: .top, value: 150)
        
        Button(text: "buttom1buttom1buttom1buttom1"){
            print("buttom1")
            model.text1?.text("buttom1but").numberOfLines(2)
        }.titleColor(nil, for: UIControl.State.normal)
        .width(150).height(100).backgroundColor(.yellow).margin(edge: .top, value: 64)
        ImageView("turtlerock").isUserInteractionEnabled(true)
        hstack
    }
}

