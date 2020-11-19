//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation


struct ArgoKitItem:ArgoKitIdentifiable {
    var identifier: String
    var reuseIdentifier: String
    var text:String
    init() {
        self.reuseIdentifier = "ArgoKitItem"
        self.identifier = "identifier"
        self.text = ""
    }
    init(rowid:String,text:String) {
        self.reuseIdentifier = rowid
        self.identifier = "\(rowid)\(text)"
        self.text = text
    }
}

class HostView:View {
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
        pNode = ArgoKitNode(view:view);
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

    var rootView:HostView?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        rootView = HostView(self.view){
            rootView_!
        }
        
        let _ = rootView?.applyLayout()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    func testAnimation() -> Void {
        let root = (rootView?.node?.view)!
        if let target = root.viewWithTag(2020) {
            doAniamtion(target: target)
        } else {
            let view = UIView()
            view.akLayoutFrame = CGRect(x:60, y: 120, width: 100, height: 100)
            view.backgroundColor = UIColor.green
            view.tag = 2020
            root.addSubview(view)
            
            doAniamtion(target: view)
        }
        print("--->> ArgoKit: start animation \(root)")
    }
    
    func doAniamtion(target: UIView) {
//        let anim = AKAnimation(type: AKAnimationType.positionX)
//        anim.duration(2).from(60).to(160)
//        anim.attach(target)
//        anim.start()
        
//        let anim = AKAnimation(type: AKAnimationType.color)
//        anim.duration(2).from(UIColor.green).to(UIColor.red)
//        anim.attach(target)
//        anim.start()
        
//        let anim = AKAnimation(type: AKAnimationType.color)
//        anim.duration(2).from(UIColor.green).to(0, 255, 255, 1)
//        anim.attach(target)
//        anim.start()
        
//        let anim = AKAnimation(type: AKAnimationType.scale)
//        anim.duration(2).from(1, 1.0).to(1.2, 1.2)
////        anim.attach(target)
//        target.addAnimation(anim)
//        anim.start()
        
        let anim = AKSpringAnimation(type: AKAnimationType.positionX)
        anim.springMass(20).springSpeed(100)
        anim.duration(0.2).from(60).to(160)
        anim.attach(target)
        anim.start()
    }

    
    deinit {
        print("deinit")
    }

    
}
