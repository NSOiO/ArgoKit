//
//  ArgoKitViewDemo.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/26.
//

import ArgoKit

extension UIColor{
    public convenience init(_ r:CGFloat,_ g :CGFloat,_ b:CGFloat,_ a:CGFloat = 1){
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: a)
     
    }
}
class MSUserInterractionHeaderView: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
         HStack{
            
            VStack{
                // 头像
                Image("icybay.jpg").width(50.0)
                .height(50.0)
                .margin(edge: .left, value: 15.0)
                .cornerRadius(10)
                .backgroundColor(.red)
                    .borderWidth(1)
                    .borderColor(.cyan)
                
                Image("")
                .height(12.0)
                .width(18.0)
                .margin(top: -5, right: 0, bottom: 0, left: 33)
                .circle()
                .display(true)
                .backgroundColor(.red)
            }

             
             VStack{
                 HStack{
                    HStack{
                     Text("姓名")
                         .textColor(UIColor(50,51,51))
                         .font(size: 16.0)
                        .textShadowOffset(CGSize(width: 2, height: 2))
                        .textShadowColor(.red)
                        .shadow(offset: CGSize(width: 2, height: 2), radius: 20, opacity: 0.5)
                        .width(100)
                        .padding(edge: .left, value: 5)
                        
//                         .shrink(1.0)
                        
                        Button(action: {
                            
                        }){
                            Image("icybay.jpg")
                                .margin(edge: .left, value: 4)
                                .width(15.0)
                                .height(15.0)
                        }
                        .backgroundColor(.red)
                        .alignSelf(.center)
                        .padding(top: 7, right: 7, bottom: 7, left: 7)
     
                    }.flex(1.0)
                    
//                     Spacer()
                     
                     Text("10.0千米")
                         .textAlign(.right)
                         .font(size: 13)
                         .textColor(UIColor(170,170,170))
                        .backgroundColor(.yellow)
                    
                 }.margin(edge: .left, value: 4)
                 .width(100%)
                 
                
                 
                 Text("他在陌陌很有人气")
                     .textAlign(.left)
                     .font(size: 12)
                     .textColor(UIColor(170,170,170))
                     .margin(edge: .top, value: 5)
                     .margin(edge: .right, value: 15)
                     .margin(edge: .left, value: 4)
             }.grow(1)
             .width(0)
         }
    }
}


class MSUserInterractionContentView: ArgoKit.View {
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
         HStack{
             // 头像
             Image("icybay.jpg")
             .width(46.0)
             .height(46.0)
             .cornerRadius(4)
            
            Text("姓名sasd姓名sasd")
                .lineLimit(2)
                .textColor(UIColor(50,51,51))
                .font(size: 16.0)
                .margin(edge: .left, value: 5)
                .alignSelf(.center)
                .textShadowColor(UIColor.red)
                .textShadowOffset(CGSize(width: 0, height: 2))
            
         }.margin(edge: .left, value: 10)
         .margin(edge: .top, value: 10)

        Spacer()
            .height(0.5)
            .backgroundColor(UIColor(235,235,235))
            .margin(top: 10, right: 10, bottom: 0, left: 10)

        HStack{
            Image("icybay.jpg")
            .width(15.0)
            .height(15.0)
            .cornerRadius(topLeft: 4, topRight: 4, bottomLeft: 4, bottomRight: 4)
            Text("点赞了他")
                .textColor(UIColor(50,51,51))
                .font(size: 12.0)
                .margin(edge: .left, value: 5)
                .alignSelf(.center)
        }
        .margin(edge: .top, value: 12)
        .margin(edge: .left, value: 10)
        ForEach(0..<4){ index in
            Text("点赞了他点赞了他ccccxxxxxxss")
                .textColor(UIColor(170,170,170))
                .font(size: 12.0)
                .margin(edge: .top, value: 5)
                .lineLimit(0)
        }.margin(top:  10.5, right: 0, bottom: 13, left: 11)

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
            Image()
            Image("chincoteague.jpg", bundle: Bundle.main)
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
    
   var body: ArgoKit.View{
        MSUserInterractionHeaderView().margin(edge: .top, value: 5)
        .onTapGesture {[data = self.item] in
            print(data)
        }
        MSUserInterractionContentView()
            .margin(top: 10.0, right: 15.0, bottom: 15.0, left: 70.0)
            .cornerRadius(5)
            .backgroundColor(UIColor(250,250,250))
            .grow(1)
    }
    
  
}
var headerView:RefreshHeaderView?
var footerView:RefreshFooterView?
class ListDemo:ArgoKit.View{
    typealias View = ArgoKit.View
    var items = [SessionItem]()
    init() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["11","22","33","44","55"]
        for index in 1..<20{
            let item = SessionItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            item.imagePath = images[index%5]
            item.sessionName = images[index%5] + "+\(String(index))"
            item.lastMessage = messages[index%5] + "+\(String(index))"
            item.timeLabel = getTimeLabel()
            item.unreadCount = String(index)
            items.append(item)
        }
    }
    
    var hidden:Bool = false
    
    var body: ArgoKit.View{
        ArgoKit.List<SessionItem,SessionItem,SessionItem>(data:items){ item in
            SessionRow(item: item).width(100%).height(100%).backgroundColor(.clear)
        }
        .didSelectRow {item, indexPath in
            AlertView(title: item!.imagePath, message: item!.lastMessage, preferredStyle: UIAlertController.Style.alert)
            .textField()
            .destructive(title: "确认") { text in
                print(text ?? "")
            }
            .cancel(title: "取消") {}
            .show()
        }
        .refreshHeaderView {
            RefreshHeaderView(startRefreshing: {
                _ = headerView?.endRefreshing()
            })
            {
                Text("headerh").alignSelf(.center).lineLimit(0).font(size: 20)
            }.pullingDown{ point in
                print("pullingDown\(String(describing: point))")
            }
            .height(100.0)
            .backgroundColor(.red)
            .alias(variable: &headerView)
        }
        .refreshFooterView{
            RefreshFooterView(startRefreshing: {
//                footerView?.resetNoMoreData()
                print("footerhead")
            })
            {
                Text("footerhead").alignSelf(.center).lineLimit(0).font(size: 20)
            }
            .height(100.0)
            .autoRefreshOffPage(1)
            .backgroundColor(.red)
            .alias(variable: &footerView)
            
        }
        
//        .canEditRow({ item, indexPath -> Bool in
//            return true
//        })
//        .trailingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
//            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
//                print("trailing 菜鸡")
//                complation(true)
//            }),
//             ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
//                 print("trailing  互啄")
//                 complation(true)
//             }),
//            ].swipeActionsConfiguration()
//        }
//        .leadingSwipeActions { (item, indexPath) -> ListSwipeActionsConfiguration? in
//            [ListContextualAction(style: .normal, title: "菜鸡", handler: { (action, view, complation) in
//                print("leading 菜鸡")
//                complation(true)
//            }),
//             ListContextualAction(style: .destructive, title: "互啄", handler: { (action, view, complation) in
//                 print("leading 互啄")
//                 complation(true)
//             }),
//            ].swipeActionsConfiguration()
//        }
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
    var body: ArgoKit.View{
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
//
//class TabSegmentDemo: ArgoKit.View {
//    var body: ArgoKit.View {
//        TabSegment(["AA", "BB", "CC", "DD", "EE"]) { text in
//            Text(text as? String).textAlign(.center).width(100).height(50).backgroundColor(.blue)
//        }.margin(top: 100, right: 0, bottom: 0, left: 0)
//        .select(index: 1)
//        .backgroundColor(.yellow)
////        .animType(.color)
////        .animFromValue(.color(.blue))
////        .animToValue(.color(.yellow))
//
////        TabSegment(["1", "2", "3", "4", "5", "6", "7", "8"]) {
////            Text($0 as? String).textAlign(.center).width(400).height(500).backgroundColor(.green)
////        }.margin(top: 100, right: 0, bottom: 0, left: 0)
////        .backgroundColor(.yellow)
////        .animType(.color).animToValue(.color(.orange))
//    }
//}

class ArgoKitViewDemo:ArgoKit.View  {
   typealias View = ArgoKit.View
   var body:ArgoKit.View{
    
    MSUserInterractionHeaderView().margin(edge: .top, value: 5)
    
    MSUserInterractionContentView()
        .margin(top: 10.0, right: 15.0, bottom: 15.0, left: 70.0)
        .cornerRadius(5)
        .backgroundColor(UIColor(250,250,250))
    
    ListDemo()
    .grow(1)
//    TabSegmentDemo()
    
    
    
//    HStack{
//
//       HStack{
//
//        Text("姓")
//            .font(size: 16.0)
//            .backgroundColor(.cyan)
//            .textColor(.red)
//            .width(150)
//            .textAlign(.center)
////            .shadow(offset: CGSize(width: 60, height: 10), radius: 3, opacity: 0.5)
//            .shadow(shadowColor: UIColor.red, shadowOffset: CGSize(width: 60, height: 10), shadowRadius: 3, shadowOpacity: 0.5)
////            .shrink(1.0)
////        Button {
////
////        } builder: {
////            Text("姓名姓名姓")
////                .font(size: 16.0)
////                .backgroundColor(.cyan)
////                .textColor(.red)
////                .
////                .shrink(1.0).alignSelf(.center)
////        }.textColor(.orange)
////        .shrink(1.0)
////
////        Button(text: "姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名姓名"){
////
////        }
//            .font(size: 26.0)
//            .backgroundColor(.cyan)
//            .textColor(.red)
//            .shrink(1.0)
//
//        ForEach(0..<1){ item in
//            Image("icybay.jpg")
//                .margin(edge: .left, value: 4)
//                .width(15.0)
//                .height(15.0)
//               .alignSelf(.center)
//        }.flexDirection(.row)
//        .margin(edge: .left, value: 4)
//        .margin(edge: .right, value: 4)
//        .alignSelf(.center)
//       }
//       .flex(1)
//
//
//        Text("10.0千米")
//            .textAlign(.right)
//            .font(size: 13)
//            .textColor(UIColor(170,170,170))
//           .backgroundColor(.yellow)
//
//
//    }
//    .margin(edge: .left, value: 4)
//    .margin(edge: .top, value: 104)
//    .width(100%)
//    .backgroundColor(.purple)
//
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

