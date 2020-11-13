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
    var item: ArgoKitItem
    init(item:ArgoKitItem) {
        self.item = item
    }
    var body:View{
        HStack{ [self] in
            ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).backgroundColor(.orange)
            Text(item.text).backgroundColor(.purple).numberOfLines(0).alignSelf(ArgoAlign.center).width(10).alias(variable: &self.item.textCom)
        }.height(100%).width(100%)
    }
    
}
class DemoContentView: View {
    var items:[ArgoKitItem]
    public init(){
        items = [ArgoKitItem]()
        for index in 10..<20 {
            let item:ArgoKitItem = ArgoKitItem()
            item.text = String(index)
            if index == 15 {
                item.reuseIdentifier = "15"
            }else{
                item.reuseIdentifier = "200"
            }
            item.identifier = "\(index)"
            items.append(item)
        }
    }
    
    var body:View{
           ImageView().image(UIImage(named: "turtlerock")).backgroundColor(.orange)
        List(data:items) { item in
            row(item: item).padding(edge: .left, value: 10).backgroundColor(.orange)
        }.width(100%).height(100%).backgroundColor(.red)
        .didSelectRowAtIndexPath {[weak self] indexPath in
            let item:ArgoKitItem? = self?.items[indexPath.row]
            print("\(String(describing: self?.items))")
            item?.textCom?.text("hahahahahahahahahahahahahahhahahahahahahahahaahahah")
        }
    }
}
