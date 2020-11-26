//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

private class HostView:View {
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
        pNode.column()
    }
    
    init(_ view:UIView = UIView(),@ArgoKitViewBuilder _ builder:()->View) {
        pView = view
        pNode = ArgoKitNode(view:view);
        pNode.width(point: view.frame.size.width)
        pNode.height(point: view.frame.size.height)
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
    public init(rootView: View){
        super.init(nibName: nil, bundle: nil)
        rootView_ = rootView
    }

    public init?(coder aDecoder: NSCoder, rootView: View){
        super.init(coder: aDecoder)
        rootView_ = rootView
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var rootView:HostView?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        rootView = HostView(self.view){
            rootView_!.width(100%).height(100%)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    open override func viewDidLayoutSubviews() {
        let frame = self.view.frame
        let width:CGFloat = frame.size.width as CGFloat
        let height:CGFloat = frame.size.height as CGFloat
        _ = rootView?.width(ArgoValue(width)).height(ArgoValue(height)).applyLayout()
        super.viewDidLayoutSubviews()
    }
    
    open override func viewLayoutMarginsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewLayoutMarginsDidChange()
        } else {
        }
    }
    deinit {
        print("deinit")
    }

    
}
