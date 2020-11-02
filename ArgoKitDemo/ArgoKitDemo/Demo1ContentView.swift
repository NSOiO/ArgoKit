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
        }
        
        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
            print("UISlider ", value)
        }).width(point: 200).height(point: 30)
        .marginTop(point: 100).left(point: 10)
        
        
        Toggle(true){ isOn in
            print("Toggle :",isOn)
        }.marginTop(point: 10)
        
        
        Stepper(value: 10, in: 0...100, step: 4) { value in
            print("Stepper :",value)
        }.width(point: 100).height(point: 30).marginLeft(point: 150)
        

        SegmenteControl { index in
            print("items :",index)
        } _: {
           Text("e")
           Text("r")
           Text("t")
           Text("u")
           ImageView("turtlerock")
        }.width(percent: 100).height(point: 30).marginTop(point: 150)
        
        Button(text: "buttom1buttom1buttom1buttom1"){
            print("buttom1")
            model.text1?.text("buttom1buttom1buttom1buttom1").applyLayout()
            
        }.width(point: 50).height(point: 100).backgroundColor(.yellow).marginLeft(point: 10)
        
        HStack{
            ImageView("turtlerock")
            Text("11").backgroundColor(.yellow).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red).alias(variable: &model.text1)
        }.alias(variable: &model.stack1)
   
    }
}

