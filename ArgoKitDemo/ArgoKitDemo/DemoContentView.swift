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
    let items = ["查查","cscs","122e", "122e", "122e", "122e", "122e", "122e", "122e", "122e666", "122e555", "122e444", "122e333", "122e222", "122e111","查查","cscs","122e", "122e", "122e", "122e", "122e", "122e", "122e", "122e666", "122e555", "122e444", "122e333", "122e222", "122e111","查查","cscs","122e", "122e", "122e", "122e", "122e", "122e", "122e", "122e666", "122e555", "122e444", "122e333", "122e222", "122e111"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    
    var body:View{
        
        List(data: items) { item in
            HStack{
//                ImageView().image(UIImage(named: "turtlerock")).width(100).height(100)
                Text(item as? String).backgroundColor(.yellow).width(100).height(100).isEnabled(true)
            }.width(100%).height(100%).backgroundColor(.cyan)
        }.width(100%).height(100%)
//        .tableHeaderView { () -> View in
//            Text("Header").backgroundColor(.yellow).width(200).height(100)
//        }.tableFooterView { () -> View in
//            Text("Footer").backgroundColor(.yellow).width(200).height(100)
//        }.contentInset(UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0))
        
//        PickerView(items) { item -> View in
//            Text(item as? String)
//        }.didSelectRowInComponent { (row, component) in
//            print("seleted row \(row) in component \(component)")
//        }.width(point: 375)
        
    }
}


