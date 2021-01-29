//
//  ArgoKitViewDemo.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/26.
//

import ArgoKit
import ArgoKitComponent
extension UIColor{
    public convenience init(_ r:CGFloat,_ g :CGFloat,_ b:CGFloat,_ a:CGFloat = 1){
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: a)
     
    }
}
struct MSUserInterractionHeaderView: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    typealias View = ArgoKit.View
    var item:SessionItem
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
                .gone(true)
                .backgroundColor(.red)
            }

             
             VStack{
                 HStack{
                    HStack{
                        Text(item.lastMessage)
                         .textColor(UIColor(50,51,51))
                         .font(size: 16.0)
                         .shrink(1.0)
                        
                        Button(action: {
                            
                        }){
                            Image(item.imagePath as! String)
                                .margin(edge: .left, value: 4)
                                .width(15.0)
                                .height(15.0)
                        }
                        .backgroundColor(.red)
                        .alignSelf(.center)
                        .padding(top: 7, right: 7, bottom: 7, left: 7)
     
                    }.flex(1.0)
                    
                     
                     Text("10.0千米")
                         .textAlign(.right)
                         .font(size: 13)
                         .textColor(UIColor(170,170,170))
                        .backgroundColor(.yellow)
                        .margin(edge: .right, value: 10)
                    
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
    var node: ArgoKitNode? = ArgoKitNode()
    typealias View = ArgoKit.View
    var body: ArgoKit.View {
         HStack{
             // 头像
             Image("icybay.jpg")
             .width(46.0)
             .height(46.0)
             .cornerRadius(4)
            
            Text("姓名"+"\(Int.random(in: 0 ..< 10000))")
                .lineLimit(2)
                .textColor(UIColor(50,51,51))
                .font(size: 26.0)
                .margin(edge: .left, value: 5)
//                .shadow(color: .red, offset: CGSize(width: 4, height: 4), radius: 0.3, opacity: 0.3)
                .textShadowColor(UIColor.red)
                .textShadowOffset(CGSize(width: 2, height: 2))
//                .cornerRadius(3)
                .backgroundColor(.gray)
//                .underline(style: .single, width: 1, color: .red)
                .shrink(1)
            
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
        }

    }
}

class TextFieldView: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode()
    typealias View = ArgoKit.View
   var body: ArgoKit.View {
    
    TextField(placeholder: "请输入文本")
     .width(200)
     .height(30)
     .alignSelf(.center)
     .margin(top: 0, right: 2, bottom: 0, left: 2)
     .placeholderColor(.orange)
     .didBeginEditing({ content in
            
     })
     .backgroundColor(.gray)
     .leftView{
         Button(text:""){
         }
         .width(30)
         .height(30)
         .backgroundColor(.red)
         .contentMode(.center)
     }
     .rightView{
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
   var node: ArgoKitNode? = ArgoKitNode()
   typealias View = ArgoKit.View
   var item:SessionItem
   var hidden:Bool = true
    var models:NSArray = NSArray()
   init(item:SessionItem) {
       self.item = item
   }
 
    
   var body: ArgoKit.View{
        MSUserInterractionHeaderView(item: item)
            .margin(edge: .top, value: 5)
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
class ArgoKitNodeDemo: ArgoKitNode {
    deinit {
        print("ArgoKitNodeDemo")
    }
}
class ListDemoView:UIView{
    deinit {
        print("ListDemoView")
    }
}
var headerView:RefreshHeaderView?
var footerView:RefreshFooterView?
struct ListDemo:ArgoKit.View{
    var node: ArgoKitNode? = ArgoKitNodeDemo(viewClass: ListDemoView.self)
    typealias View = ArgoKit.View
    var dataspource1:NSArray = NSArray()
    
   
    
    @DataSource var items:[SessionItem] = [SessionItem]()
    init() {
       loadMoreData()
    }
    
    func loadMoreData() {
        let images = ["chincoteague.jpg","icybay.jpg","silversalmoncreek.jpg","umbagog.jpg","hiddenlake.jpg"]
        let messages = ["11","22","33","44","55"]
        for index in 0..<50{
            let item = SessionItem( reuseIdentifier:"reuseIdentifier")
            item.imagePath = images[index%5]
            item.sessionName = images[index%5] + "+\(String(index))"
            item.lastMessage = messages[index%5] + "+\(String(index))"
            item.timeLabel = getTimeLabel()
            item.unreadCount = String(index)
            $items.append(item)
        }
        $items.apply()
    }
    
    
    var hidden:Bool = false
    
    var body: ArgoKit.View{
        ArgoKit.List(data:$items){ item in
            SessionRow(item: item)
        }
        .cellSelected {item, indexPath in
//            AlertView(title: item.imagePath, message: item.lastMessage, preferredStyle: UIAlertController.Style.alert)
//            .textField()
//            .destructive(title: "确认") { text in
//                print(text ?? "")
//            }
//            .cancel(title: "取消") {}
//            .show()
            let controller = ViewPagerController()
            self.viewController()?.navigationController?.pushViewController(controller, animated: true)
//            let item = SessionItem( reuseIdentifier:"reuseIdentifier")
//            item.imagePath = "icybay.jpg"
//            item.sessionName = "hahahaha"
//            item.lastMessage = "hahahaha"
//            item.timeLabel = getTimeLabel()
////            $items.replace(data: item, at: indexPath).apply(with: .none)
//            $items.move(at: indexPath, to: IndexPath(row: indexPath.row + 2, section: indexPath.section)).apply(with: .none)
        }
        .cellCanEdit({ (item, indx) -> Bool in
            return true
        })
        .trailingSwipeActions({ (data, indexPath) -> ListSwipeActionsConfiguration? in
            let action = UIContextualAction(style: UIContextualAction.Style.normal, title: "delete") { (action, view, block) in
                print("data\(data)")
               
    
//                $items.delete(at: indexPath).apply(with: UITableView.RowAnimation.top)
//
//                $items.delete().apply().insert().apply(.Fade) // deleteRow
                
//                $items.deleteRow(at: indexPath, with: UITableView.RowAnimation.none)
                let ip = IndexPath(row: 1, section: 0)
                
                
                
                
                //1. guai
                //2. data, IndexPath -
                
                //1. insert /insert / reload
                
                
            }
            return ListSwipeActionsConfiguration(actions: [action])
        })
        
        .refreshHeaderView {
            RefreshHeaderView(startRefreshing: {_ in 
                headerView?.endRefreshing()
            })
            {
                Text("refreshheader")
                    .alignSelf(.center)
                    .lineLimit(0).font(size: 20)
                  
            }.pullingDown{ point in
                print("pullingDown\(String(describing: point))")
            }
            .height(100.0)
        }
        .refreshFooterView{
            RefreshFooterView(startRefreshing: {refresh in
                self.loadMoreData()
                refresh?.endRefreshing()
                refresh?.resetNoMoreData()
                print("footerhead")
            })
            {
                Text("refreshfooter").alignSelf(.center).lineLimit(0).font(size: 20)
            }
            .height(100.0)
            .autoRefreshOffPage(1)
            .backgroundColor(.red)
            
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

class ArgoKitViewDemo:ArgoKit.View  {
   var node: ArgoKitNode? = ArgoKitNode()
   typealias View = ArgoKit.View
   var body:ArgoKit.View{
    ListDemo()
    .grow(1)
        .backgroundColor(.red)
   }
}


#if canImport(SwiftUI) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitViewDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitViewDemo().grow(1)
        }
    }
}
#endif


