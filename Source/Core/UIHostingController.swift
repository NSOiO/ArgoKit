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
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// The type of the node.
    public var type: ArgoKitNodeType {
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
        pNode = ArgoKitNode(view: view);
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
///
/// Example:
///
///```
///         let hostView: UIHostingView = UIHostingView(content: Content(), frame:self.view.bounds)
///         self.view.addSubview(hostView)
///```
///
public class UIHostingView: UIView {
    private var rootView: HostView?
    private var safeArea: Bool? = false
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
                
                if self.safeArea == true {
                    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    if #available(iOS 11.0, *){
                        insets = self.safeAreaInsets
                        node.paddingLeft(point: insets.left)
                        node.paddingRight(point: insets.right)
                        node.paddingTop(point: insets.top)
                        node.paddingBottom(point: insets.bottom)
                    }
                }
                node.applyLayout()
            }
        }
        super.layoutSubviews()
    }
    
    /// Initializer
    /// - Parameters:
    ///   - content: The root view of the ArgoKit view hierarchy that you want to manage using this hosting controller.
    ///   - frame: The frame rectangle for the new view object.
    ///   - safeArea: true if you want to add the insets that you use to determine the safe area for this view.
    public init(content: View, frame: CGRect = CGRect.zero, safeArea: Bool = false){
        super.init(frame: frame)
        self.safeArea = safeArea
        rootView = HostView(self) {
            content.grow(1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// A UIKit view controller that manages a ArgoKit view hierarchy.
///
/// Example:
///
///```
///     class AppDelegate: UIResponder, UIApplicationDelegate {
///
///         var window: UIWindow?
///
///         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///             // Override point for customization after application launch.
///
///             let rootVC = UIHostingController(rootView: RootView())
///             let window = UIWindow.init(frame: UIScreen.main.bounds)
///             window.rootViewController = rootVC
///             self.window = window
///             window.makeKeyAndVisible()
///
///             return true
///         }
///     }
///```
///
open class UIHostingController: UIViewController {
    var frame:CGRect = CGRect.zero
    private var hostView: UIHostingView
    
    /// Initializer
    /// - Parameters:
    ///   - rootView: The root view of the ArgoKit view hierarchy that you want to manage using the hosting view controller.
    ///   - safeArea: ture if you want to add the insets that you use to determine the safe area for this view.
    public init(rootView: View, safeArea: Bool = false) {
        hostView = UIHostingView(content:rootView,safeArea: safeArea)
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - aDecoder: An unarchiver object.
    ///   - rootView: The root view of the ArgoKit view hierarchy that you want to manage using the hosting view controller.
    ///   - safeArea: ture if you want to add the insets that you use to determine the safe area for this view.
    public init?(coder aDecoder: NSCoder, rootView: View, safeArea: Bool = false) {
        hostView = UIHostingView(content:rootView,safeArea: safeArea)
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
