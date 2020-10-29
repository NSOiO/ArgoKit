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
    
    let items = ["1","2","3"]
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
           Image("turtlerock")
        }.width(percent: 100).height(point: 30).marginTop(point: 150)
        
        PageControl(currentPage: 1, numberOfPages: 5) { index in
            print("PageControl ", index)
        }.width(percent: 100).height(point: 30).marginTop(point: 10).backgroundColor(.red)
        
        //
        Button("") {
            print("buttom1")
        } builder: {
            Text("sdshha").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red).textAlignment(.center)
        }.alignItemsCenter()

//        ForEach(items){item in
//            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
//                .left(point: 20).textColor(.red).marginRight(point:20)
////        }.row()
//        HStack{
//            Image("turtlerock")
//            Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//                .left(point: 20).textColor(.red)
//        }
        
        DatePicker { date in
            
        }.width(percent: 100).height(point: 100).marginTop(point: 10).backgroundColor(.yellow)
        
        
        HStack{
            Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
                .left(point: 20).textColor(.red)
        }.gesture(gesture: gestur)
//
//            Button("") {
//                print("buttom1")
//            } builder: {
//                Text("sdshha").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//                    .left(point: 20).textColor(.red).textAlignment(.center)
//            }.alignItemsCenter()
////
////
//////            Image().image(UIImage(named: "turtlerock")).width(point: 100).height(point: 100).left(point: 20)
////
//            Toggle(true){ isOn in
//                print("Toggle :",isOn)
//            }
//
//        }
   
    }
}
