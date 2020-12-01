//
//  ArgoKitViewDemo.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/26.
//

import ArgoKit

class itemView: ArgoKit.View {
    

    
    
   typealias View = ArgoKit.View
   var body: ArgoKit.View {

    
       Image("chincoteague.jpg")
           .clipsToBounds(true)
           .backgroundColor(.clear)
           .width(60.0)
           .height(60.0)
           .alignSelf(.center)
           .margin(edge: .left, value: 10)
           .margin(edge: .top, value: 10)
           .margin(edge: .bottom, value: 10)
           .circle()
           .onTapGesture {
           }.isUserInteractionEnabled(true)
       
       Text("aaaa33dd")
   }
}


class TextFieldView: ArgoKit.View {
    typealias View = ArgoKit.View
   var body: ArgoKit.View {
    TextField(nil,placeholder: "请输入文本")
     .width(200)
     .height(30)
     .alignSelf(.center)
     .margin(top: 0, right: 2, bottom: 0, left: 2)
     .placeholderColor(.orange)
     .didChangeSelection { content in
     }
     .backgroundColor(.gray)
     .leftView(UITextField.ViewMode.always) {
         Button(text:""){
         }
         .width(30)
         .height(30)
         .backgroundColor(.red)
         .contentMode(.center)
     }
     .rightView(UITextField.ViewMode.always) {
         Button{
         }builder: {
             Image("chincoteague.jpg")
         }
         .width(30)
         .height(30)
         .backgroundColor(.red)
         .contentMode(.center)
     }
   }
}
class SessionRow:ArgoKit.View {
   typealias View = ArgoKit.View
   var item:SessionItem
   var hidden:Bool = true
   init(item:SessionItem) {
       self.item = item
   }
    init() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["chincoteague","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad.qdaswdwsad"]
        var item = SessionItem(identifier:String(1), reuseIdentifier:"reuseIdentifier")
        item.imagePath = images[1]
        item.sessionName = images[1] + "+\(String(1))"
        item.lastMessage = messages[1] + "+\(String(1))"
        self.item = item
    }
    
   var body: ArgoKit.View {
       HStack{
           
           itemView()
           
           VStack{
               Text(self.item.sessionName)
                   .cornerRadius(topLeft: 4, topRight: 4, bottomLeft: 5, bottomRight: 5)
                   .backgroundColor(.gray)
                   .textAlign(.center)
               
               Text(self.item.lastMessage)
                   .backgroundColor(.red)
                   .lineSpacing(10).lineLimit(0)
                   .cornerRadius(topLeft: 4, topRight: 3, bottomLeft: 3, bottomRight:3)
                   .alias(variable: &self.item.textCom)
                   .margin(edge: .top, value: 3)
                .hidden(self.hidden)
           }.margin(top: 10, right: 0, bottom: 10, left: 10)
           .backgroundColor(.clear)
           
           Spacer()
           
            Button(text:"隐藏文本框"){
                self.hidden = !self.hidden
//                let s = "click + \( self.item.textCom?.node?.text())"
                _ = self.item.textCom?.hidden(self.hidden)
            }
            .backgroundImage(path: self.item.imagePath, for: UIControl.State.normal)
            .width(100)
            .height(50)
            .alignSelf(.center)
//            .cornerRadius(topLeft: 5, topRight: 4, bottomLeft: 4, bottomRight:4)
            .margin(top: 0, right: 5, bottom: 0, left: 5)
            .textColor(.red)
           

       }.backgroundColor(.clear)
       
   }
}

class ListDemo:ArgoKit.View{
    typealias View = ArgoKit.View
    var items = [SessionItem]()
    init() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["chincoteague","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad","chincoteagueadasdadchincoteagueadasdadchincoteagueadasdad.qdaswdwsad"]
        for index in 1..<200{
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
    var body: View{
        List(data:items){ item in
            SessionRow(item: item).width(100%).height(100%).backgroundColor(.clear)
        }.grow(1)
        .didSelectRow {item, indexPath in
            AlertView(title: item!.imagePath, message: item!.lastMessage, preferredStyle: UIAlertController.Style.alert).default(title: "确认") { text in
                print(text ?? "")
            }.cancel(title: "取消") {}
            .textField()
            .show()
        }
        .canEditRow({ item, indexPath -> Bool in
            return true
        })
        .trailingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("trailing 菜鸡")
                complation(true)
            }),
             ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
                 print("trailing  互啄")
                 complation(true)
             }),
            ].swipeActionsConfiguration()
        }
        .leadingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
                print("leading 菜鸡")
                complation(true)
            }),
             ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
                 print("leading 互啄")
                 complation(true)
             }),
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

class customView: ArgoKit.View  {
    typealias View = ArgoKit.View
    var hidden:Bool = true
    var alertView1:AlertView?
     var aText:ArgoKit.Text?
    var body: View{
        VStack {
           Text("hello aaa")
           Button() {
            self.hidden = !self.hidden
            _ = self.aText?.hidden(self.hidden)
               print("click1")
           } builder: {
               Text("buttonscxdscsdcsd").font(size:20)
               Text("buttonscxdscsdcsd")
                  
           }
           .flexDirection(.column)
           .textColor(.purple)
           .backgroundColor(.clear)
           .font(size:30)
           .font(style: .bold)
           .shadow(shadowColor: .yellow, shadowOffset: CGSize(width: 1, height: 1), shadowRadius: 3.0, shadowOpacity: 13.0)

           Button(text: "12345678eeee") {
               let s = "click + \( String(describing: self.aText?.node?.text()!))"
               _ = self.aText?.text(s)
               print("click2")
           }

           ArgoKit.Toggle(true) { value in
               print("value is ",value)
           }

          Text("hello bbbxassxas ")
          Text("hello ccc").lineLimit(0)
               .alias(variable: &self.aText)
            .backgroundColor(.red)
            .hidden(self.hidden)
      }.margin(edge: .top, value: 96)
        .backgroundColor(.cyan)
    }
}

class ArgoKitViewDemo:ArgoKit.View  {
   typealias View = ArgoKit.View
   var body:ArgoKit.View{
//    customView().margin(edge: .left, value: 0)
     ListDemo()
//    SessionRow().margin(edge: .top, value: 96)
   }

}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import SwiftUI
@available(iOS 13.0.0, *)
struct ArgoKitViewDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
            ArgoKitViewDemo().body
        }
    }
}
#endif
