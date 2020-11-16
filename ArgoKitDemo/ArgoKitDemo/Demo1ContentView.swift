//
//  Demo1ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/2.
//

import Foundation
import UIKit
import ArgoKit
public class DemoModel1 {
    var text1:Text?
    var stack1:HStack?
    var alert1:AlertView?
    var showAlert:Bool = false
    init() {
    }
}
var model:DemoModel1 = DemoModel1()
class Demo1ContentView:View {
    let items = ["查查","cscs","122e"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
  
    init() {


    }
    var body:View{
        Button(text: "buttom1buttom1buttom1buttom1"){
            print("buttom1")
            model.text1?.text("buttom1but").numberOfLines(2)
            model.alert1?.show()
        }.titleColor(nil, for: UIControl.State.normal)
        .width(150).height(100).backgroundColor(.green).margin(edge: .top, value: 64)
        .alert(isPresented: &model.showAlert) {
            AlertView(title: "main title", message: "sub message", preferredStyle: UIAlertController.Style.alert).default(title: "text") { text in
                
            }.backgroundColor(.clear).alias(variable: &model.alert1)
        }
        
        ImageView("turtlerock").isUserInteractionEnabled(true)
        HStack{
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
    }
}

