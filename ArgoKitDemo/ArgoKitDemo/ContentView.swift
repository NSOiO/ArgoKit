//
//  ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import Foundation
import UIKit
import ArgoKit
public struct ContentView:View {
    let items = ["1","2","3"]
    public var body:View{
        ForEach(items){item in
            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
                .left(point: 20).textColor(.red).marginRight(point:20)
        }.row()
        
        Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
            .left(point: 20).textColor(.red)
        
        Button(text: "buttom"){
            print("buttom1")
            
        }.backgroundColor(.orange).width(point: 100).height(point: 100).tapButton {
            print("buttom1")
        }
        
        
    }
}
