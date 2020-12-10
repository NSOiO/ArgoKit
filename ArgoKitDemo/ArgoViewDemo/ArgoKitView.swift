//
//  ArgoKitView.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-08.
//

import ArgoKit

// view model
class ArgoKitViewModel {
    var imageUrl: URL? = nil
    var title: String = ""
}

// view
class ArgoKitView: ArgoKit.View {
    typealias View = ArgoKit.View
    var model = ArgoKitViewModel()
    
    var body: ArgoKit.View {
        VStack {
            Image(url: self.model.imageUrl, placeholder: "turtlerock")
                .width(100)
                .height(100)
            
            Text(self.model.title)
                .onTapGesture {
                }
        }
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
// mock view model
class ArgoKitViewModel_Previews: ArgoKitViewModel {
    override init() {
        super.init()
        self.imageUrl = URL(string: "https://img.momocdn.com/album/95/62/9562CD67-C76A-1437-29D7-58AB7F421B4820181023_S.jpg")
        self.title = "Hello World!.."
    }
}

@available(iOS 13.0.0, *)
struct ArgoKitView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        let view = ArgoKitView()
        view.model = ArgoKitViewModel_Previews()
        return ArgoRender {
            view
        }
    }
}
#endif
