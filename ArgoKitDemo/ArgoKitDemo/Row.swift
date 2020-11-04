//
//  Row.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/4.
//

import Foundation
import ArgoKit
struct RowsModel {
    var imageView:ImageView?
    init() {
        imageView = ImageView()
    }
    public func change(_ image:UIImage?){
        imageView?.image(image)
    }
}

var model1:RowsModel = RowsModel()
struct Row: View {
    var body:View{
        ImageView().image(UIImage(named: "turtlerock")).width(100).height(100).alias(variable: &(model1.imageView))
        Text("").backgroundColor(.yellow).width(200).height(100)
    }
}
