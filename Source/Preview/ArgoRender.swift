//
//  ArgoRender.swift
//  ArgoVersionDemo
//
//  Created by Dai on 2020-11-11.
//
#if canImport(SwiftUI)
import UIKit
import SwiftUI
import ArgoKit

typealias UIHostingController = ArgoKit.UIHostingController
typealias View = ArgoKit.View
typealias VStack = ArgoKit.VStack
typealias HStack = ArgoKit.HStack
typealias Button = ArgoKit.Button
typealias ImageView = ArgoKit.ImageView

var host: UIHostingController?

@available(iOS 13.0, *)
public struct ArgoRender: UIViewRepresentable {
    let builder:() -> ArgoKit.View
    
    public init (@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) {
        self.builder = builder
    }
    
    public func makeUIView(context: Context) -> UIView {
        let content = self.builder()
        let controller = UIHostingController(rootView: content)
//        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host = controller
        return controller.view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
//        host?.applyLayout()
        print(uiView)
    }
}

#endif

