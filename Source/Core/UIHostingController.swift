//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

/// A ArgoKit view that manages a ArgoKit view hierarchy.
public struct HostView: View {
    private var pNode: ArgoKitNode
    private var pView: UIView
    
    /// The content and behavior of the view.
    public var body: View {
        ViewEmpty()
    }
    
    /// The node behind the HostView.
    public var node: ArgoKitNode?{
        pNode
    }
    
    /// The type of the node.
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    
    init() {
        pView = UIView();
        pNode = ArgoKitNode(view: pView);
        pNode.column()
        pNode.flexGrow(1.0)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - view: A UIKit view that hosts a ArgoKit view hierarchy.
    ///   - builder: A view builder that creates the content of this HostView.
    public init(_ view: UIView = UIView(), @ArgoKitViewBuilder _ builder: () -> View) {
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

/// A UIKit view that hosts a ArgoKit view hierarchy.
public class UIHostingView: UIView {
    private var rootView: HostView?
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
    
    /// Initializer
    /// - Parameters:
    ///   - content: The root view of the ArgoKit view hierarchy that you want to manage using this hosting controller.
    ///   - frame: The frame rectangle for the new view object.
    required public init(content: View, frame: CGRect = CGRect.zero){
        super.init(frame: frame)
        rootView = HostView(self) {
            content.grow(1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// A UIKit view controller that manages a ArgoKit view hierarchy.
open class UIHostingController: UIViewController {
    var frame:CGRect = CGRect.zero
    private var hostView: UIHostingView
    
    /// Initializer
    /// - Parameter rootView: The root view of the ArgoKit view hierarchy that you want to manage using the hosting view controller.
    required public init(rootView: View) {
        hostView = UIHostingView(content: rootView)
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - aDecoder: An unarchiver object.
    ///   - rootView: The root view of the ArgoKit view hierarchy that you want to manage using the hosting view controller.
    required public init?(coder aDecoder: NSCoder, rootView: View) {
        hostView = UIHostingView(content: rootView)
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
//        let frame = self.view.frame
//        if !frame.equalTo(self.frame) {
//            self.frame = frame
//            hostView.frame = self.view.bounds
//        }
        hostView.frame = self.view.bounds
        super.viewDidLayoutSubviews()
    }
}
