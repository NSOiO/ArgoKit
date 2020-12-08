//
//  Content.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-08.
//

import ArgoKit

// view model
class ContentModel {
    var picture2URL: URL? = nil
    var displayComment2Image: Bool = true
    var displayComment1Image: Bool = true
    var picture1URL: URL? = nil
    var comment1ImageWith: CGFloat {
        get {
            if self.displayComment2Image {
                return 46
            }
            return 50
        }
    }
    var comment1ImageHeight: CGFloat {
        get {
            if self.displayComment2Image {
                return 46
            }
            return 50
        }
    }
    
    var comment1ImageLeft: CGFloat {
        get {
            if self.displayComment2Image {
                return 4
            }
            return 0
        }
    }
    var comment1ImageTop: CGFloat {
        get {
            if self.displayComment2Image {
                return 4
            }
            return 0
        }
    }
    
    var actionIconURL: URL? = nil
    var actionText: String = ""
    var commentTitleBottom: CGFloat = 0
}

// view
class Content: ArgoKit.View {
    typealias View = ArgoKit.View
    private var model: ContentModel
    init(model: ContentModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
         HStack{
            Image(url: self.model.picture2URL,placeholder: nil)
                .width(46.0)
                .height(46.0)
                .cornerRadius(4)
                .positionType(.absolute)
                .display(self.model.displayComment2Image)
            
            Image(url: self.model.picture1URL,placeholder: nil)
                .width(.point(self.model.comment1ImageWith))
                .aspect(ratio: 1)
                .height(self.model.displayComment2Image ? 46 : 0)
                .margin(edge: .left, value: self.model.displayComment2Image ? 4 : 0)
                .margin(edge: .top, value: self.model.displayComment2Image ? 4 : 0)
                .cornerRadius(4)
                .display(self.model.displayComment1Image)
                
//            MDMixText()
//                .textLayout(model.feedContentLayout())
//                .margin(edge: .left, value: 5)
//                .alignSelf(.center)
//                .drawInOriginalCanvas(false)
//                .backgroundColor(.clear)

            
         }.margin(edge: .left, value: 10)
         .margin(edge: .top, value: 10)
        
        Spacer()
            .height(0.5)
            .backgroundColor(red: 235, green: 235, blue: 235)
            .margin(top: 10, right: 10, bottom: 0, left: 10)

        HStack{ //[weak self] in
            Image(url: self.model.actionIconURL,placeholder: nil)
            .width(15.0)
            .height(15.0)
            .cornerRadius(4)
            
            Text(self.model.actionText)
                .textColor(red: 50, green: 51, blue: 51)
                .font(size: 12.0)
                .margin(edge: .left, value:5)
                .alignSelf(.center)
        }
//        .margin(edge: .bottom, value: .point(self.model.commentTitleBottom))
        .margin(edge: .top, value:12)
        .margin(edge: .left, value:10)
        
//        VStack{[weak self] in
//            MDMixText()
//                .textLayout(self?.pmodel.comment1Layout())
//                .display(self?.pmodel.displaycomment1() ?? true)
//                .backgroundColor(.clear)
//                .drawInOriginalCanvas(false)
//                .margin(top:5, right:0, bottom: .point(self?.pmodel.comment2Bottom() ?? 6.0), left: 11)
                
            
//            MDMixText()
//                .textLayout(self?.pmodel.comment2Layout())
//                .display(self?.pmodel.displaycomment2() ?? true)
//                .backgroundColor(.clear)
//                .drawInOriginalCanvas(false)
//                .margin(top:0, right: 0, bottom:13, left:11)
//        }.alignItems(.start)

    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

let url = "https://img.momocdn.com/album/95/62/9562CD67-C76A-1437-29D7-58AB7F421B4820181023_S.jpg"
// mock view model
class ContentModel_Previews:  ContentModel {
    override init() {
        super.init()
        self.picture2URL = URL(string: url)
        self.picture1URL = self.picture2URL
    }
}

@available(iOS 13.0.0, *)
struct Content_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            Content(model: ContentModel_Previews())
        }
    }
}
#endif
