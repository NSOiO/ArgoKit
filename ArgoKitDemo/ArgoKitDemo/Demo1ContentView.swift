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
    let items = ["查查","cscs","122e"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    var body:View{
        let gestur = TapGesture(numberOfTaps: 1, numberOfTouches: 1) { gesture in
            print("tapAction111")
        }
        
//        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
//            print("UISlider ", value)
//        }).width(200).height(30).margin(edge: .top, value: 60)
//
//
//        Toggle(true){ isOn in
//            print("Toggle :",isOn)
//        }.margin(edge: .top, value: 10)
//
//
//        Stepper(value: 10, in: 0...100, step: 4) { value in
//            print("Stepper :",value)
//        }.width(100).height(30).margin(edge: .left, value: 150)
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
//        }.width(100%).height(30).margin(edge: .top, value: 150)
        
        Button(text: "buttom1buttom1buttom1buttom1"){
            print("buttom1")
            model.text1?.width(60).text("buttom1buttom1buttom1buttom1").numberOfLines(2)
            
        }.titleColor(.red, for: UIControl.State.normal)
        .width(150).height(100).backgroundColor(.yellow).margin(edge: .top, value: 10)
        ImageView("turtlerock").gesture(gesture: gestur).isUserInteractionEnabled(true)
        HStack{
//            ImageView("turtlerock")
            Text("11").backgroundColor(.yellow).height(100).margin(edge: .top, value: 50).position(edge: .left, value: 20)
                .textColor(.red).alias(variable: &model.text1)
        }.isUserInteractionEnabled(true)
        .alias(variable: &model.stack1).longPressAction(numberOfTaps: 1, numberOfTouches: 1, minimumPressDuration: 0.5){
            print("longPressAction")
        }
   
    }
}

