//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

public struct HostView:View {
    public var body: View{
        ViewEmpty()
    }
    private var pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    
    private var pView:UIView
    init(){
        pView = UIView();
        pNode = ArgoKitNode(view: pView);
        pNode.column()
        pNode.flexGrow(1.0)
    }
    
    public init(_ view:UIView = UIView(),@ArgoKitViewBuilder _ builder:()->View) {
        pView = view
        pNode = ArgoKitNode(view:view);
        pNode.width(point: view.frame.size.width)
        pNode.height(point: view.frame.size.height)
        pNode.column()
        pNode.flexGrow(1.0)
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                pNode.addChildNode(node)
            }
        }
    }
}



public class UIHostingView:UIView{
    private var rootView:HostView?
    private var oldFrame = CGRect.zero
    public override func layoutSubviews() {
        if !oldFrame.equalTo(self.frame) {
            oldFrame = self.frame
            if let node = rootView?.node {
                let width:CGFloat = oldFrame.size.width as CGFloat
                let height:CGFloat = oldFrame.size.height as CGFloat
                node.width(point: width)
                node.height(point: height)
                node.frame = frame
                node.resetOrigin = false
                node.applyLayout()
            }
        }
        
        super.layoutSubviews()
    }
    
    public init(content:View){
        super.init(frame: CGRect.zero)
        rootView = HostView(self){
            content.grow(1.0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


open class UIHostingController:UIViewController{
    var frame:CGRect = CGRect.zero
    private var hostView:UIHostingView
    public init(rootView: View){
        hostView = UIHostingView(content:rootView)
        super.init(nibName: nil, bundle: nil)
        
    }

    public init?(coder aDecoder: NSCoder, rootView: View){
        hostView = UIHostingView(content:rootView)
        super.init(coder: aDecoder)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.edgesForExtendedLayout = UIRectEdge.init()
        self.view.addSubview(hostView)
        hostView.frame = self.view.bounds
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    open override func viewDidLayoutSubviews() {
        let frame = self.view.frame
        if !frame.equalTo(self.frame) {
            self.frame = frame
            hostView.frame = self.view.bounds
        }
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        print("deinit")
    }

    
}
