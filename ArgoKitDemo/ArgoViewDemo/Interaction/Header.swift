//
//  Header.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-08.
//

import ArgoKit

// view model
class HeaderModel {
    var avatarURL: URL? = nil
    var themeTagImage: UIImage? = nil
    var displaythemeTag: Bool = true
    var onlineStatusURL: URL? = nil
    var displayOnline: Bool = true
    var displayName: String = ""
    var userIcons: Array<UIImage> = []
    var subDecString: String = ""
    var decString: String = ""
    var headerImage: Image? = nil
}

// view
class Header: ArgoKit.View {
    typealias View = ArgoKit.View
    private var model: HeaderModel
    init(model: HeaderModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        let data = self.model
         return HStack{
            VStack {
                Image(url: data.avatarURL,placeholder: "icon_default_circle")
                .height(55.0)
                .width(55.0)
                .circle()
                .backgroundColor(.clear)
                
                Image(image: data.themeTagImage)
                .height(12.0)
                .width(18.0)
                .margin(edge: .top, value: -6)
                .display(data.displaythemeTag)
                .alignSelf(.center)
                Image(url: data.onlineStatusURL, placeholder: nil)
                .height(10.0)
                .width(10.0)
                .margin(top: -14, right: 1, bottom: 0, left: 0)
                .display(data.displayOnline)
                .alignSelf(.end)
            }
        
             VStack{
                 HStack{
                    HStack{
                        Text(data.displayName)
                             .textColor(red: 50, green: 51, blue: 51)
                             .font(size: 16.0)
                             .shrink(1.0)

                        ForEach(data.userIcons){ item in
                            Image(image:item)
                        }.flexDirection(.row)
                        .margin(edge: .left, value: 4)
                        .margin(edge: .right, value: 4)
                        .alignSelf(.center)
                        
                    }.flex(1)
    
                    Text(data.subDecString)
                         .textAlign(.left)
                         .font(size: 13)
                        .textColor(red: 170, green: 170, blue: 170)
                 }.margin(edge: .top, value: 5)
                
                 
                Text(data.decString)
                     .textAlign(.left)
                     .font(size: 12)
                    .textColor(red: 170, green: 170, blue: 170)
                     .margin(edge: .top, value: 5)
             }.grow(1.0)
             .margin(edge: .left, value: 8)
         }
    }}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock view model
class HeaderModel_Previews:  HeaderModel {
    override init() {
        super.init()
        self.avatarURL = URL(string: "https://img.momocdn.com/album/95/62/9562CD67-C76A-1437-29D7-58AB7F421B4820181023_S.jpg")
        self.themeTagImage = UIImage.init(named: "turtlerock")
        self.displayName = "display name"
        self.onlineStatusURL = self.avatarURL
        self.subDecString = "subDesc"
        self.decString = "desc"
    }
}

@available(iOS 13.0.0, *)
struct Header_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            Header(model: HeaderModel_Previews())
        }
    }
}
#endif
