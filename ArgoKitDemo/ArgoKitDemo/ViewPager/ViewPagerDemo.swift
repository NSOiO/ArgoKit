//
//  ViewPagerDemo.swift
//  ArgoKitDemo
//
//  Created by sun-zt on 2020/12/3.
//

import SwiftUI
import ArgoKitPreview
import ArgoKit

//struct ViewPagerDemo: ArgoKit.View {
//    @State private var testName = "abcdee"
//    var body: some ArgoKit.View {
//        Text(testName + "bbb")
//            .onTapGesture {
//                testFunc()
//            }
//
//    }
//
//    func testFunc() -> Void {
//        self.testName += "JJJJG330"
//        print("action")
//    }
//}

public class ViewPageCellItem:ArgoKitIdentifiable{
    public var identifier: String
    public var reuseIdentifier: String
    
    var text:String?
    var bgColor:UIColor?
    

    init(identifier:String,reuseIdentifier:String) {
        self.identifier = identifier
        self.reuseIdentifier = reuseIdentifier
    }

}

struct ViewPageCell: ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var item:ViewPageCellItem
    init(it: ViewPageCellItem) {
        item = it
    }
    var body: ArgoKit.View {
        ArgoKit.HStack {
            ArgoKit.Text(item.text)
                .font(size: 20)
        }
        .height(100)
        .margin(edge: ArgoEdge.top, value: 50)
        .backgroundColor(item.bgColor ?? UIColor.red)
    }
}

struct ViewPage1 : ArgoKit.View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    @DataSource var items:[ViewPageCellItem] = [ViewPageCellItem]()
    init() {
        for index in 1...10{
            let item = ViewPageCellItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            $items.append(data:item)
            if index % 2 == 0 {
                item.bgColor = UIColor.gray
            }else {
                item.bgColor = UIColor.blue
            }
            
            item.text = "test>>>>>>>>" + String(index) + ""
        }
    }
    
    let tab = TabSegment(["A", "B", "C", "D", "E", "F", "G","H","I","J"]) {
        Text($0 as? String).textAlign(.center).width(100).height(50).backgroundColor(.blue)
    }
    
    var body: ArgoKit.View {
        
        tab
            .margin(top: 100, right: 0, bottom: 0, left: 0)
            .backgroundColor(.yellow)
            .clickedCallback { (index, anim) in
                
            }
        
        ArgoKit.HStack {
            ArgoKit.ViewPage(data: $items) { item in
                ViewPageCell(it: item)
            }
            .grow(1)
            .height(300)
            .backgroundColor(UIColor.orange)
            .reuseEnable(enable: false)
            .scrollToPage(index: 2)
//            .scrollEnable(enable: false)
            .setTabScrollingListener { (percent, from, to) in
                let value = Float(percent) - Float(from)
//                if Float(percent) >= Float(from) {
//                    value = 1
//                }
                NSLog("percent: %f == from:%d == to:%d", value, from, to)
                self.tab.scroll(toIndex: to, progress: Float(value))
            }
            .onChangeSelected { (item, to) in
                NSLog(">>> %d", to)
            }
        }
        .backgroundColor(UIColor.red)
        .margin(top: 100, right: 0, bottom: 0, left: 0)
    }

}

@available(iOS 13.0.0, *)
struct ViewPagerDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoRender {
//            ViewPagerDemo().body
            ViewPage1().body
        }
    }
}
