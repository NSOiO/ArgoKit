//
//  DemoContentView.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/10/29.
//

import Foundation
import UIKit
import ArgoKit

class ArgoKitItem:ArgoKitIdentifiable {
    var identifier: String
    var reuseIdentifier: String
    var text:String
    var index:Int = 0
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
    var textCom:Text?
}
class row: View{
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var item: ArgoKitItem
    init(item:ArgoKitItem) {
        self.item = item
    }
    var body:View{
        HStack{ [self] in
            Image().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
            Spacer()
            Text(item.text).backgroundColor(.purple).lineLimit(0).alignSelf(ArgoAlign.center).width(10)
//                .alias(variable: &self.item.textCom)
            Spacer()
            Text(item.text).backgroundColor(.purple).lineLimit(0).alignSelf(ArgoAlign.center).width(10)
//                .alias(variable: &self.item.textCom)
        }.width(100%)
    }
    
}
class DemoContentView: View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    @DataSource var items:[ArgoKitItem] = [ArgoKitItem]()
    public init(){
        for index in 1..<100 {
            let item:ArgoKitItem = ArgoKitItem()
            item.text = String(index * index)
            item.index = index
            if index == 15 {
                item.reuseIdentifier = "15"
            }else{
                item.reuseIdentifier = "200"
            }
            item.identifier = "\(index)"
            $items.append(item)
        }
    }
    
    var body:View{
        List(data:$items) { item in
            if item.index % 2 == 0{
                row(item: item).padding(edge: .left, value: 10).backgroundColor(.orange)
            }else{
                row(item: item).padding(edge: .left, value: 10).backgroundColor(.cyan)
            }
           
        }.width(100%).height(100%).backgroundColor(.white)
        .cellSelected { item, indexPath in
            item.textCom?.text("haha11"+item.text)
        }
    }
}
