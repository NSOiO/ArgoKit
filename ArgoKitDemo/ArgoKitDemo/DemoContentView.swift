//
//  DemoContentView.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/10/29.
//

import Foundation
import UIKit
import ArgoKit

struct ArgoKitItem:ArgoKitIdentifiable {
    var identifier: String
    var reuseIdentifier: String
    var text:String
    init() {
        self.reuseIdentifier = "ArgoKitItem"
        self.identifier = "identifier"
        self.text = ""
    }
    init(rowid:String,text:String) {
        self.reuseIdentifier = rowid
        self.identifier = "\(rowid)\(text)"
        self.text = text
    }
}
struct row: View{
    var pNode = ArgoKitNode(viewClass: UIView.self)
    var node: ArgoKitNode?{
        pNode
    }
    var item: ArgoKitItem
    var body:View{
        HStack{
            ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
            Text(item.text).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.center).width(10)
        }.height(100%).width(100%)
    }
    
}
struct DemoContentView: View {
    var items: [ArgoKitItem] {
        var temp = [ArgoKitItem]()
        for index in 10..<20 {
            var item:ArgoKitItem = ArgoKitItem()
            item.text = String(index)
            if index == 15 {
                item.reuseIdentifier = "15"
            }else{
                item.reuseIdentifier = "200"
            }
            item.identifier = "\(index)"
            temp.append(item)
        }
        return temp
    }
    var pNode = ArgoKitNode(viewClass: UIView.self)
    var node: ArgoKitNode?{
        pNode
    }
    
    var body:View{
           ImageView().image(UIImage(named: "turtlerock")).backgroundColor(.orange)
        List(data: items) { item in
            row(item: item).padding(edge: .left, value: 10)
//            if item.reuseIdentifier == "15"{
//               row(item: item)
//            }else{
//                HStack{
//                    Text(item.text).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.start).width(10)
//                    ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
//                }.height(100%).width(100%)
//            }

        }.width(100%).height(100%).backgroundColor(.red)
        .tableHeaderView { () -> View in
            Text("TableHeader").backgroundColor(.yellow).height(100)
        }.tableFooterView { () -> View in
            Text("TableFooter").backgroundColor(.yellow).height(100)
        }.sectionHeader([ArgoKitItem(rowid: "sectionHeader", text: "sectionHeader")]) { (item) -> View in
            Text(item.text).backgroundColor(.yellow).width(100%).height(44)
        }.sectionFooter([ArgoKitItem(rowid: "SectionFooter", text: "sectionHeader")]) { (item) -> View in
            Text(item.text).backgroundColor(.yellow).width(200%).height(44)
        }
//
    }
}
