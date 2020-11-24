//
//  Demo1ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/2.
//

import Foundation
import UIKit
import ArgoKit

public class SessionItem:ArgoKitIdentifiable{
    public var identifier: String
    public var reuseIdentifier: String
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?
    var textCom:Text?
    var hidden:Bool = false
    
    init(identifier:String,reuseIdentifier:String) {
        self.identifier = identifier
        self.reuseIdentifier = reuseIdentifier
    }
    
}
class SessionRow:View{
    var item:SessionItem
    var hidden:Bool = false
    init(item:SessionItem) {
        self.item = item
    }
    var body: View{
        HStack{
            ImageView(self.item.imagePath)
                .clipsToBounds(true)
                .backgroundColor(.clear)
                .width(60.0)
                .height(60.0)
                .alignSelf(.center)
                .margin(edge: .left, value: 10)
                .margin(edge: .top, value: 10)
                .margin(edge: .bottom, value: 10)
                .cornerRadius(topLeft: 5, topRight: 4, bottomLeft: 4, bottomRight:4)
                .onTapGesture {
                    self.hidden = !self.hidden
                    _ = self.item.textCom?.hidden(self.hidden)
                }.isUserInteractionEnabled(true)
                
            VStack{
                Text(self.item.sessionName)
                    .cornerRadius(topLeft: 4, topRight: 4, bottomLeft: 5, bottomRight: 5)
                    .backgroundColor(.gray)
                    .textAlign(.center)
//                    .borderWidth(top: 13, right: 13, bottom: 13, left: 50)
                
                Text(self.item.lastMessage)
                    .backgroundColor(.red)
                    .LineSpacing(10).lineLimit(0)
                    .cornerRadius(topLeft: 4, topRight: 3, bottomLeft: 3, bottomRight:3)
                    .alias(variable: &self.item.textCom)
                    .margin(edge: .top, value: 3).hidden(self.hidden)
            }.margin(top: 10, right: 0, bottom: 10, left: 10)
            .backgroundColor(.clear)
            
            Spacer()
            
            Button(text:"隐藏文本框"){
                self.hidden = !self.hidden
                _ = self.item.textCom?.hidden(self.hidden)
            }
            .backgroundImage(path: self.item.imagePath, for: UIControl.State.normal)
            .width(100)
            .height(50)
            .backgroundColor(.green)
            .alignSelf(.center)
            .cornerRadius(topLeft: 5, topRight: 4, bottomLeft: 4, bottomRight:4)
            .margin(top: 0, right: 5, bottom: 0, left: 5)
            .titleColor(.red, for: UIControl.State.normal)
            
            TextField(nil,placeholder: "隐藏文本框")
                .width(100)
                .height(30)
                .alignSelf(.center)
                .margin(top: 0, right: 2, bottom: 0, left: 2)
                .fontSize(20)
                .placeholderColor(.orange)
                .didChangeSelection { content in
                    print(content)
                }
//            VStack{
//                Text(self.item.timeLabel)
////                    .textAlign(.left)
//                    .margin(edge: .top, value: 10)
////                    .margin(edge: .right, value: 50)
//                    .backgroundColor(.yellow)
////
//                Text(self.item.unreadCount).alignSelf(.center)
//                    .textColor(.red).backgroundColor(.yellow)
//                    .margin(edge: .top, value: 15)
//                    .margin(edge: .right, value: 5).shrink(1)
//            }.backgroundColor(.orange)
//            .margin(top: 10, right: 0, bottom: 10, left: 10)
        }.backgroundColor(.clear)
        
    }
}

class Demo1ContentView:View {
    var items = [SessionItem]()
    init() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["chincoteague","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad.qdaswdwsad"]
        for index in 1..<300{
            var item = SessionItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            item.imagePath = images[index%5]
            item.sessionName = images[index%5] + "+\(String(index))"
            item.lastMessage = messages[index%5] + "+\(String(index))"
            item.timeLabel = getTimeLabel()
            item.unreadCount = String(index)
            items.append(item)
        }
    }
    var hidden:Bool = false
    var alertView1:AlertView?
    var body:View{
        List(data:items){ item in
            SessionRow(item: item).width(100%).height(100%).backgroundColor(.clear)
        }.width(100%).height(100%).didSelectRow {item, indexPath in
//            AlertView(title: item!.imagePath, message: item!.lastMessage, preferredStyle: UIAlertController.Style.alert).default(title: "确认") { text in
//                print(text ?? "")
//            }.cancel(title: "取消") {}
//            .textField()
//            .show()
//            if let hidden = item?.hidden{
//                item?.hidden = !hidden
//                _ = item?.textCom?.hidden(!hidden)
//            }
           
            
        }
        .canEditRow({ item, indexPath -> Bool in
            return true
        })
        .trailingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("trailing 菜鸡")
                complation(true)
            }),
//            ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
//                print("trailing  互啄")
//                complation(true)
//            }),
            ].swipeActionsConfiguration()
        }
        .leadingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("leading 菜鸡")
                complation(true)
            }),
//            ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
//                print("leading 互啄")
//                complation(true)
//            }),
            ].swipeActionsConfiguration()
        }
    }
    
    func getTimeLabel()->String{
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        formatter.dateFormat = "HH:mm:ss"
        let str:String = formatter.string(from: NSDate() as Date)
        return str
    }
   
}

