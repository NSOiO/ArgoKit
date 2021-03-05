//
//  ArgoKitTextTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit
import ArgoKitComponent
// view model.
class ArgoKitTextTestModel {
//   @Observable var age:Int = 1
//   @Observable var fontSize:CGFloat = 30
   @Observable var name:String = "张三张三张三张三张三张三张三张三张三张三张三张三张三张三张"
    let lable:UIView = UIView()
    
    init() {
        lable.backgroundColor = .orange
        lable.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    }
//   @Observable var color:UIColor = .red
//   @Alias var text:Text?
}

// view
struct ArgoKitTextTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitTextTestModel
    @DataSource var dataSource:[[Int]] = [[1, 2, 3,4],[4, 5, 6],[7, 8, 9]]
   
    init(model: ArgoKitTextTestModel) {
        self.model = model
        self.grow(1.0)
    }
    
    var body: ArgoKit.View {
//        HStack{
//            Text("单行文本sxssasasdassasa")
//                .font(size: 25)
//                .backgroundColor(.orange)
//                .margin(edge: .top, value: 0)
//                .height(100)
//                .onTapGesture {
//                    model.lable.frame.size = CGSize(width: 50, height: 50)
//                }
//            CustomView(view: model.lable)
////                .size(width: 100, height: 20)
//                .backgroundColor(.yellow)
//                .margin(edge: .top, value: 100)
//        }
//            .alignSelf(.center)
//        .backgroundColor(.cyan)
//
//        Text("单行文本粗体cdxasxas····")
////            .margin(edge: .bottom, value: .auto)
//        .backgroundColor(.yellow)
//
//
//        Text("单行文本粗体cdxasxas····").font(size:30).backgroundColor(.yellow)
//            .margin(edge: .top, value: .auto)
//            .alignSelf(.center)
//
        VStack{
            Text("单行文本粗体asdasdsassdscscsddcsdcsdcsd").backgroundColor(.yellow)
                .basis(.auto)
            Text("单行文本粗体asdasdsassdscscsddcsdcsdcsd").backgroundColor(.yellow)
                .basis(.auto)
        }.margin(edge: .top, value: 30)
//        .alignItems(.center)
//        .width(50%)
//        .height(50%)
        .backgroundColor(.cyan)
        
        
        
        HStack{
            Text("单行文本粗体asdasdsassdscscsddcsdcsdcsd").backgroundColor(.yellow)
                .margin(edge: .right, value: 30)
            Text("单行文本粗体").backgroundColor(.yellow)
                .margin(edge: .left, value: .auto)
        }
        .width(400)
        .margin(edge: .top, value: .auto)
        .backgroundColor(.black)
        
        
        
        
        
//        Text("单行文本粗体cdxasxas····").backgroundColor(.yellow)
//            .margin(edge: .top, value: .auto)
////            .font(size: 25)
//            .font(style: .bold)
//            .backgroundColor(.orange)
//            .margin(edge: .top, value: 10)
//            .alignSelf(.stretch)
//            .textAlign(.right)
//            .margin(edge: .bottom, value: 100)
//        Button(text: model.name) {
//            
//        }
//        .font(size:40)
//        .backgroundColor(.red)
//        .margin(edge: .bottom, value: 10)
//        .alignSelf(.center)
        
//        Button {
//            
//        } builder: { () -> View in
//            Text( model.name).backgroundColor(.purple)
////                .firstLineHeadIndent(10)
//                .lineLimit(0)
//                .headIndent(10).kern(10)
//        }
//        .font(size:20)
//        .textColor(.yellow)
//        
//        AvatarBreathView(url: nil, placeholder: "chincoteague.jpg")
//            .startAnimation(true)
//            .width(150)
//            .height(150)
//            .headerMargin(0)
//            .strokeColor("255,201,100")
//            .margin(edge: .top, value: 10)
//            .tagText("哈哈哈")
//            .backgroundColor(.orange)
//            .imageCircle(true)
//            .fillColor("100,255,201")
//            .circle()
        
//        LikeView(likeSvga: "", normalUrl: "http://img.momocdn.com/feedimage/A1/24/A124B7A3-AF51-43B2-9DB0-D56E32D1809520201211_400x400.webp", highlightUrl: "http://img.momocdn.com/feedimage/82/8B/828BA59B-6A93-F96B-D467-FC22243F5BD120201211_L.webp") { (result) -> Bool in
//            print("result:\(result)")
//            return true
//        } onClicked: { (result1, result2) in
//            print("result1:\(result1) == result2:\(result2)")
//        }
//        .width(30)
//        .height(30)
//        .margin(edge: .top, value: 10)
//        .margin(edge: .left, value: 100)

        

        

//        Text("单行文本粗体cd")
//            .font(size: 25)
//            .font(style: .bold)
//            .backgroundColor(.orange)
//            .margin(edge: .top, value: 50)
//            .alignSelf(.stretch)
//
//        Text(model.name)
//            .font(size: 50)
//            .font(style: .default)
////            .backgroundColor(model.color)
//            .margin(edge: .top, value: 10)
//            .alignSelf(.start)
//            .onTapGesture {
//                let controller = ViewPagerController()
//                viewController()?.navigationController?.pushViewController(controller, animated: true)
////                model.name = "李四" + "\(Int.random(in: 0 ..< 1000))"
//            }
//        
//        
//        Text("多行文本行间距 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 ")
//            .font(size: 25)
//            .lineLimit(0)
//            .lineSpacing(10)
//            .backgroundColor(.orange)
//            .margin(edge: .top, value: 10)
//            .textShadow(color: .red, offset: CGSize(width: 2, height: 2), blurRadius: 0.5,range: NSRange(location: 1, length: 2))
//
//        YYText("多行文本行间距 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本 多行文本多行文本 多行文本 多行文本")
//            .font(size: 20)
//            .font(style: .bolditalic)
//            .textColor(.white)
//            .textColor(.yellow,range: NSRange(location: 10, length: 6))
//            .lineLimit(3)
//            .lineSpacing(10)
//            .underline(style: .single, width: 1, color: .red)
//            .backgroundColor(.gray)
//            .margin(edge: .top, value: 10)
//            .textShadow(color: .red, offset: CGSize(width: 2, height: 2), blurRadius: 0.5,range: NSRange(location: 3, length: 2))
            
        
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitTextTestModel_Previews:  ArgoKitTextTestModel {

}

@available(iOS 13.0.0, *)
fileprivate func ArgoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitTextTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitRender {
            ArgoKitTextTest(model: ArgoKitTextTestModel_Previews())
        }
    }
}
#endif
