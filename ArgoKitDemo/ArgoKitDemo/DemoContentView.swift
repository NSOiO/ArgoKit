//
//  DemoContentView.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/10/29.
//

import Foundation
import UIKit
import ArgoKit

struct DemoContentView: View {
    var items: [String] {
        var temp = [String]()
        for index in 0..<1000 {
            temp.append(String(index))
        }
        return temp
    }
    
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    
    var body:View{
        
        List(data: items) { item in
//            HStack{
                ImageView().image(UIImage(named: "turtlerock")).width(100).height(100)
//                Text(item as? String).backgroundColor(.yellow).width(200).height(100)
//            }.height(100).width(100%)
        }.width(100%).height(100%)
        .tableHeaderView { () -> View in
            Text("TableHeader").backgroundColor(.yellow).height(100)
        }.tableFooterView { () -> View in
            Text("TableFooter").backgroundColor(.yellow).height(100)
        }
        .backgroundColor(.red)
        
//        PickerView(items) { item -> View in
//            Text(item as? String).width(100).height(44)
//        }.didSelectRowInComponent { (row, component) in
//            print("seleted row \(row) in component \(component)")
//        }
        
    }
}
