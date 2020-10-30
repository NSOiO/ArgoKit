//
//  ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import Foundation
import UIKit
import ArgoKit
struct model{
    var iden:Any?
}
struct ContentView:View {
    let items = ["查查","cscs","122e"]
    var body:View{
        let gestur = TapGesture(numberOfTaps: 1, numberOfTouches: 1) { gesture in
        }
        
        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
            print("UISlider ", value)
        }).width(point: 200).height(point: 30)
        .marginTop(point: 100).left(point: 10)
        .tap
        .longPress
        .swip
        
        
        Toggle(true){ isOn in
            print("Toggle :",isOn)
        }.marginTop(point: 10).id(model.en)
        
        
        Stepper(value: 10, in: 0...100, step: 4) { value in
            print("Stepper :",value)
        }.width(point: 100).height(point: 30).marginLeft(point: 150)
        
        SegmenteControl { index in
            print("items :",index)
        } _: {
           Text("e")
           ImageView("turtlerock")
        }.width(percent: 100).height(point: 30).marginTop(point: 150)
        
        
        //
        Button("") {
            print("buttom1")
        } builder: {
            Text("sdshha").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red).textAlignment(.center)
        }.alignItemsCenter()
        

        ForEach(0..<3){index in
            Text(items[index]).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
                .left(point: 20).textColor(.red).marginRight(point:20)
        }.row()
        HStack{
            ImageView("turtlerock")
            Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red)
            Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red)
        }
          
    List(data: items) { item in
        HStack{
            ImageView().image(UIImage(named: "turtlerock")).width(point: 100).height(point: 100)
            
            Text(item as? String).backgroundColor(.yellow).width(point: 200).height(point: 100)
        }
    }.width(point: 414).height(point: 720)

   
    }
}
