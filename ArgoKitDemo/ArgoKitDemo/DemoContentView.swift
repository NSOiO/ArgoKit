//
//  DemoContentView.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/10/29.
//

import Foundation
import UIKit
import ArgoKit
public struct DemoModel2 {
    var text1:Text?
    var stack1:HStack?
    init() {
    }
}
var model2:DemoModel2 = DemoModel2()
struct DemoContentView: View {
    var items: [String] {
        var temp = [String]()
        for index in 1..<20 {
            temp.append(String(index))
        }
        return temp
    }

    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    
    var body:View{
        
        List(data: items) { item in
            HStack{
                ImageView().image(UIImage(named: "turtlerock")).backgroundColor(.orange).tapAction {
                    model2.text1?.text("hhahahhahahahahahahdsdsdsdcfsdcvdfsacvdf").width()
                }.isUserInteractionEnabled(true)
                Text(item as? String).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.center).width(10).alias(variable: &model2.text1)
            }.height(100%).width(100%)
        }.width(100%).height(100%).backgroundColor(.red)
        .tableHeaderView { () -> View in
            Text("TableHeader").backgroundColor(.yellow).height(100)
        }.tableFooterView { () -> View in
            Text("TableFooter").backgroundColor(.yellow).height(100)
        }.sectionHeader(["SectionHeader"]) { (item) -> View in
            Text(item as? String).backgroundColor(.yellow).width(200).height(44)
        }.sectionFooter(["SectionFooter"]) { (item) -> View in
            Text(item as? String).backgroundColor(.yellow).width(200).height(44)
        }
       
        
    }
}
