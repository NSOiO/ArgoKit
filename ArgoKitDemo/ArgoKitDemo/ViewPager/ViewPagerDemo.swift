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
    var item:ViewPageCellItem
    init(it: ViewPageCellItem) {
        item = it
    }
    var body: ArgoKit.View {
        ArgoKit.Text(item.text)
            .font(size: 20)
    }
}

struct ViewPage1 : ArgoKit.View {
    var items = [ViewPageCellItem]()
    init() {
        for index in 1...5{
            let item = ViewPageCellItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            items.append(item)
            if index % 2 == 0 {
                item.bgColor = UIColor.gray
            }else {
                item.bgColor = UIColor.blue
            }
            
            item.text = "test>>>>>>>>" + String(index) + ""

        }
    }
    
    var body: View {
        ArgoKit.ViewPage(data: items) { item in
            ViewPageCell(it: item)
        }
        .grow(1)
        .height(300)
//        .reuseEnable(enable: false)
        .scrollToPage(index: 2)
//        .scrollEnable(enable: false)
        .setTabScrollingListener { (percent, from, to) in
            NSLog("%f - %d - %d", percent, from, to)
        }
        .onChangeSelected { (item, to) in
            NSLog(">>> %d", to)
        }

    }

}

//struct ViewPagerDemo_Previews: PreviewProvider {
//    static var previews: some SwiftUI.View {
//        ArgoRender {
////            ViewPagerDemo().body
//            ViewPage1().body
//        }
//    }
//}
