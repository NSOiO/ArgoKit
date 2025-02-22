//
//  ArgoRender.swift
//  ArgoVersionDemo
//
//  Created by Dai on 2020-11-11.
//
#if canImport(SwiftUI) && DEBUG
import UIKit
import SwiftUI
import ArgoKit

var host: ArgoKit.UIHostingController?

@available(iOS 13.0, *)
public struct ArgoRender2: UIViewRepresentable {
    let builder:() -> ArgoKit.View
    
    public init (@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) {
        self.builder = builder
    }
    
    public func makeUIView(context: Context) -> UIView {
        let content = self.builder()
        let controller = UIHostingController(rootView: content)
        host = controller
        
        let view = controller.view!
//      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
//        host?.applyLayout()
        print(uiView)
    }
}


@available(iOS 13.0.0, *)
public struct Preview: SwiftUI.View {
    private var render: ArgoRender
    public var body: ArgoRender { render }
    public init(@ArgoKitViewBuilder _ builder:@escaping () -> ArgoKit.View) {
        self.render = ArgoRender(builder: builder)
    }
}


#endif

