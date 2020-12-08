//
//  ArgoKitViewReaderOperation.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/8.
//

import Foundation
protocol ArgoKitViewReaderOperation:AnyObject{
    var needRemake:Bool{get set}
    var nodeObserver:ArgoKitNodeObserver{get}
    init(viewNode:ArgoKitNode)
    func remakeIfNeed() -> Void
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void
}
extension ArgoKitViewReaderOperation{
    func updateCornersRadius(_ multiRadius:ArgoKitCornerRadius)->Void{}
}
