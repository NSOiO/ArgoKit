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
        for index in 10..<10000 {
            temp.append(String(index))
        }
        return temp
    }

    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    
    var body:View{
        
        List(data: items) { item in
            HStack{
                ImageView().image(UIImage(named: "turtlerock")).width(50).height(50).backgroundColor(.orange)
                Text(item as? String).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.start).width(10)
            }.height(100%).width(100%)
        }.width(100%).height(100%).backgroundColor(.red)
        .tableHeaderView { () -> View in
            Text("TableHeader").backgroundColor(.yellow).height(100)
        }.tableFooterView { () -> View in
            Text("TableFooter").backgroundColor(.yellow).height(100)
        }.sectionHeader(["SectionHeader"]) { (item) -> View in
            Text(item as! String).backgroundColor(.yellow).width(100%).height(44)
        }.sectionFooter(["SectionFooter"]) { (item) -> View in
            Text(item as! String).backgroundColor(.yellow).width(200%).height(44)
        }
        
    }
}
