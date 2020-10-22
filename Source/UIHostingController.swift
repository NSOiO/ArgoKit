//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation
struct RooView:View {
    var body: View{
        self
    }
    private var pNode:ArgoKitNode
    var node: ArgoKitNode?{
        pNode
    }
    var type: ArgoKitNodeType{
        .single(pNode)
    }
    
    private var pView:UIView
    init(){
        pView = UIView();
        pNode = ArgoKitNode(view: pView);
    }
    
    init(_ view:UIView = UIView(),@ArgoKitViewBuilder _ builder:()->View) {
        pView = view
        pNode = ArgoKitNode(view: pView);
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                pNode.addChildNode(node)
            }
        }
    }
}

open class UIHostingController:UIViewController{
    private var rootView_:View!
    /// Creates a hosting controller object that wraps the specified SwiftUI
    /// view.
    ///
    /// - Parameter rootView: The root view of the SwiftUI view hierarchy that
    ///   you want to manage using the hosting view controller.
    ///
    /// - Returns: A `UIHostingController` object initialized with the
    ///   specified SwiftUI view.
    public init(rootView: View){
        super.init(nibName: nil, bundle: nil)
        rootView_ = rootView
    }

    /// Creates a hosting controller object from an archive and the specified
    /// SwiftUI view.
    /// - Parameters:
    ///   - coder: The decoder to use during initialization.
    ///   - rootView: The root view of the SwiftUI view hierarchy that you want
    ///     to manage using this view controller.
    ///
    /// - Returns: A `UIViewController` object that you can present from your
    ///   interface.
    public init?(coder aDecoder: NSCoder, rootView: View){
        super.init(coder: aDecoder)
        rootView_ = rootView
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        RooView(self.view){
            rootView_.body
        }.done()
    }
    
}
