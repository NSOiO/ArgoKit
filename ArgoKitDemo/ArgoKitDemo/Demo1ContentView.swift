//
//  Demo1ContentView.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/2.
//

import Foundation
import UIKit
import ArgoKit

public struct SessionItem:ArgoKitIdentifiable{
    public var identifier: String
    public var reuseIdentifier: String
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?
    
}
class SessionRow:View{
    var item:SessionItem
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
                .margin(top: 10, right: 0, bottom: 10, left: 10)
                .cornerRadius(topLeft: 5, topRight: 4, bottomLeft: 4, bottomRight:4)
                
            VStack{
                Text(self.item.sessionName).maxWidth(100)
                    .cornerRadius(topLeft: 4, topRight: 4, bottomLeft: 5, bottomRight: 5).backgroundColor(.blue)
                
                Text(self.item.lastMessage)
                    .backgroundColor(.red)
                    .maxWidth(200)
                    .margin(edge: .top, value: 15).LineSpacing(10).lineLimit(2)
                    .cornerRadius(topLeft: 4, topRight: 3, bottomLeft: 3, bottomRight:3)
                
                VStack{
                    Text("cdcsc")
                }
//                .backgroundColor(.red)
                .width(100).height(60).margin(edge: .top, value: 3)
//                .cornerRadius(topLeft: 4, topRight: 5, bottomLeft: 4, bottomRight: 4)
                .shadow(shadowColor: .red, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 5, shadowOpacity: 5, corners: .allCorners)
            }
            .margin(top: 10, right: 40, bottom: 10, left: 10)
            Spacer()
            VStack{
                Text(self.item.timeLabel).lineLimit(0).textAlign(.right).margin(edge: .top, value: 10).margin(edge: .right, value: 5)
                Text(self.item.unreadCount).alignSelf(.center).textColor(.red).backgroundColor(.yellow).margin(edge: .top, value: 15).margin(edge: .right, value: 5)
            }.width(100)
        }
        
    }
}

class Demo1ContentView:View {
    var items = [SessionItem]()
    init() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["chincoteague","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad.qdaswdwsad"]
        for index in 1..<100{
            var item = SessionItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            item.imagePath = images[index%5]
            item.sessionName = images[index%5]
            item.lastMessage = messages[index%5]
            item.timeLabel = getTimeLabel()
            item.unreadCount = String(index)
            items.append(item)
        }
    }
    var alertView1:AlertView?
    var body:View{
        List(data:items){ item in
            SessionRow(item: item).width(100%).height(100%)
        }.width(100%).height(100%).didSelectRowAtIndexPath {[weak self] item, indexPath in
            _ = self?.alertView1?.titile(item!.imagePath).message(item!.lastMessage).show()
        }.alert {
            AlertView(title: "", message: "", preferredStyle: UIAlertController.Style.alert).default(title: "确认") { text in
                print(text ?? "")
            }.cancel(title: "取消") {}
            .textField()
            .alias(variable: &alertView1)
        }
        .canEditRowAtIndexPath({ item, indexPath -> Bool in
            return true
        })
        .trailingSwipeActionsConfigurationForRowAtIndexPath { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("trailing 菜鸡")
                complation(true)
            }),
            ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
                print("trailing  互啄")
                complation(true)
            }),].swipeActionsConfiguration()
        }
        .leadingSwipeActionsConfigurationForRowAtIndexPath { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("leading 菜鸡")
                complation(true)
            }),
            ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
                print("leading 互啄")
                complation(true)
            }),].swipeActionsConfiguration()
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

