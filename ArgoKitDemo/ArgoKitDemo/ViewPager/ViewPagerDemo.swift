//
//  ViewPagerDemo.swift
//  ArgoKitDemo
//
//  Created by sun-zt on 2020/12/3.
//

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
        HStack {
            Text(item.text)
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
    @Alias var tab: TabSegment?
    
    init() {
        for index in 1...10{
            let item = ViewPageCellItem(identifier:String(index), reuseIdentifier:"reuseIdentifier")
            $items.append(item)
            if index % 2 == 0 {
                item.bgColor = UIColor.gray
            }else {
                item.bgColor = UIColor.blue
            }
            item.text = "test>>>>>>>>" + String(index) + ""
        }
    }
    
    var body: ArgoKit.View {
    
        TabSegment(["A", "B", "C", "D", "E", "F", "G","H","I","J"]) {
            Text($0 as? String).textAlign(.center).width(100).height(50).backgroundColor(.blue)
        }
        .margin(top: 100, right: 0, bottom: 0, left: 0)
        .backgroundColor(.yellow)
        .clickedCallback { (index) in
                print("click \(index)")
        }
        .alias(variable: $tab)
        
        HStack {
            ViewPage(data: $items) { item in
                ViewPageCell(it: item)
            }
            .grow(1)
            .height(300)
            .backgroundColor(UIColor.orange)
            .reuseEnable(enable: false)
            .scrollToPage(index: 2)
            .link(tabSegment: self.tab)
//            .scrollEnable(enable: false)
//            .pageScrollingListener { (percent, from, to, isScroll) in
//                NSLog("percent: %f == from:%d == to:%d == isscroll: %d", percent, from, to, isScroll)
//            }
//            .onChangeSelected { (item, to, from) in
//                NSLog(">>> %d", to)
//            }
            
        }
        .backgroundColor(UIColor.red)
        .margin(top: 100, right: 0, bottom: 0, left: 0)
    }

}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitComponent
import SwiftUI
import ArgoKitPreview

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ViewPagerDemo_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
//            ViewPagerDemo().body
            ViewPage1().body
        }
    }
}
#endif
