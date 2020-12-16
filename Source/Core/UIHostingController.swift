//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

public class UIHostingView:UIView{
    var rootNode:ArgoKitNode?
    public override func layoutSubviews() {
        let frame = self.frame
        let width:CGFloat = frame.size.width as CGFloat
        let height:CGFloat = frame.size.height as CGFloat
        rootNode?.width(point: width)
        rootNode?.height(point: height)
        rootNode?.frame = frame
        rootNode?.resetOrigin = false
        rootNode?.applyLayout()
        super.layoutSubviews()
    }
}

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

open class UIHostingController:UIViewController{
    var frame:CGRect = CGRect.zero
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
        self.edgesForExtendedLayout = UIRectEdge.init()
        
        rootView = HostView(self.view){
            rootView_!.grow(1)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    open override func viewDidLayoutSubviews() {
        let frame = self.view.frame
        if !frame.equalTo(self.frame) {
            self.frame = frame
            let width:CGFloat = frame.size.width as CGFloat
            let height:CGFloat = frame.size.height as CGFloat
            _ = rootView?.width(ArgoValue(width)).height(ArgoValue(height)).applyLayout()
        }
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        print("deinit")
    }

    
}
