//
//  DemoContentView.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/10/29.
//

import Foundation
import UIKit
import ArgoKit

struct ArgoKitItem:ArgoKitModelProtocol {
    var rowid: String
    var text:String
    init() {
        self.rowid = "ArgoKitItem"
        self.text = ""
    }
    init(rowid:String,text:String) {
        self.rowid = rowid
        self.text = text
    }
}
struct DemoContentView: View {
    var items: [ArgoKitItem] {
        var temp = [ArgoKitItem]()
        for index in 10..<20 {
            var item:ArgoKitItem = ArgoKitItem()
            item.text = String(index)
            if index == 15 {
                item.rowid = "15"
            }else{
                item.rowid = "200"
            }
            temp.append(item)
        }
        return temp
    }

    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    
    var body:View{
        
        List(data: items) { item in
            if (item as! ArgoKitItem).rowid == "15"{
                HStack{
                    ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
                    Text((item as! ArgoKitItem).text).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.center).width(10)
                }.height(100%).width(100%)
            }else{
                HStack{
                    Text((item as! ArgoKitItem).text).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.start).width(10)
                    ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
                }.height(100%).width(100%)
            }

        }.width(100%).height(100%).backgroundColor(.red)
        .tableHeaderView { () -> View in
            Text("TableHeader").backgroundColor(.yellow).height(100)
        }.tableFooterView { () -> View in
            Text("TableFooter").backgroundColor(.yellow).height(100)
        }.sectionHeader([ArgoKitItem(rowid: "sectionHeader", text: "sectionHeader")]) { (item) -> View in
            Text((item as! ArgoKitItem).text).backgroundColor(.yellow).width(100%).height(44)
        }.sectionFooter([ArgoKitItem(rowid: "SectionFooter", text: "sectionHeader")]) { (item) -> View in
            Text((item as! ArgoKitItem).text).backgroundColor(.yellow).width(200%).height(44)
        }
        
    }
}
