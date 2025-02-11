//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

class HostViewNode: ArgoKitNode {
    weak var weakView:UIView?
    override var view: UIView?{
        weakView
    }
    init(weakView view: UIView) {
        self.weakView = view
        super.init(viewClass: type(of: view))
        self.size = view.frame.size
    }
}
/// A ArgoKit view that manages a ArgoKit view hierarchy.
public struct HostView: View {
    private var pNode: HostViewNode
    
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
        pNode = HostViewNode(weakView: UIView())
        pNode.column()
    }
    /// Initializer
    /// - Parameters:
    ///   - view: A UIKit view that hosts a ArgoKit view hierarchy.
    ///   - builder: A view builder that creates the content of this HostView.
    public init(_ view: UIView = UIView(), @ArgoKitViewBuilder _ builder: () -> View) {
        pNode = HostViewNode(weakView: view);
        pNode.column()
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
    private var contentView: View?
    private var resetFrame: Bool = false
    private var useSafeArea: Bool? = false
    private var oldFrame = CGRect.zero
    public var useSafeAreaTop = false
    public var useSafeAreaLeft = false
    public var useSafeAreaBottom = false
    public var useSafeAreaRight = false
    public override func layoutSubviews() {
       
//        if !oldFrame.equalTo(self.frame) && !resetFrame{
//            oldFrame = self.frame
//            if let node = rootView?.node {
//
//                let width:CGFloat = oldFrame.size.width as CGFloat
//                let height:CGFloat = oldFrame.size.height as CGFloat
//                node.width(point: width)
//                node.height(point: height)
//                node.frame = frame
//                node.resetOrigin = false
//                if #available(iOS 11.0, *){
//                    let insets = self.safeAreaInsets
//                    if self.useSafeAreaTop{
//                        node.paddingTop(point: insets.top)
//                    }
//                    if self.useSafeAreaLeft{
//                        node.paddingLeft(point: insets.left)
//                    }
//                    if self.useSafeAreaBottom{
//                        node.paddingBottom(point: insets.bottom)
//                    }
//                    if self.useSafeAreaRight{
//                        node.paddingRight(point: insets.right)
//                    }
//                }
//                node.applyLayout()
//            }
//        }
        layout(frame: self.frame)
        super.layoutSubviews()
    }
    
    private func layout(frame:CGRect,initLayout:Bool = false){
        if !oldFrame.equalTo(frame) && !resetFrame{
            if !initLayout {
                oldFrame = frame
            }
            if let node = rootView?.node {
                let width:CGFloat = frame.size.width as CGFloat
                let height:CGFloat = frame.size.height as CGFloat
                node.width(point: width)
                node.height(point: height)
                node.frame = frame
                node.resetOrigin = false
                if #available(iOS 11.0, *){
                    let insets = self.safeAreaInsets
                    if self.useSafeAreaTop{
                        node.paddingTop(point: insets.top)
                    }
                    if self.useSafeAreaLeft{
                        node.paddingLeft(point: insets.left)
                    }
                    if self.useSafeAreaBottom{
                        node.paddingBottom(point: insets.bottom)
                    }
                    if self.useSafeAreaRight{
                        node.paddingRight(point: insets.right)
                    }
                }
                node.applyLayout()
            }
        }
    }
    
    /// Initializer
    /// - Parameters:
    ///   - content: The root view of the ArgoKit view hierarchy that you want to manage using this hosting controller.
    ///   - frame: The frame rectangle for the new view object.
    ///   - safeArea: true if you want to add the insets that you use to determine the safe area for this view.
    public init(content: View, frame: CGRect = CGRect.zero, useSafeArea: Bool = false){
        super.init(frame: frame)
        self.useSafeArea = useSafeArea
        if useSafeArea {
            useSafeAreaTop = true
            useSafeAreaLeft = true
            useSafeAreaBottom = true
            useSafeAreaRight = true
            
        }
        contentView = content
        rootView = HostView(self) {
            content.grow(1.0)
        }
        layout(frame: frame,initLayout: true)
    }
    
    /// Initializer
    /// size of the host view automatically matches the size of the child view
    /// - Parameters:
    ///   - content: The root view of the ArgoKit view hierarchy that you want to manage using this hosting controller.
    ///   - origin: The position for the new view object.
    ///   - width: the specified width of the host view，default is UIScreen.main.bounds.width.
    ///   - height:the specified height of the host view，default is CGFloat.nan.
    ///   - CGFloat.nan represent the value of width(height) from the calculation results of the layout system
    public init(content: View, origin: CGPoint,width:CGFloat = CGFloat.nan,height:CGFloat = CGFloat.nan){
        super.init(frame: CGRect.zero)
        contentView = content
        rootView = HostView(self) {
            content.grow(1.0)
        }
        let size = rootView?.applyLayout(size: CGSize(width: width, height: height))
        resetFrame = true
        self.frame.origin = origin
        self.frame.size = size ?? CGSize.zero
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = rootView?.calculateLayout(size:size)
        return size ?? CGSize.zero
    }
    public override var frame: CGRect{
        didSet{
            resetFrame = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
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
    public init(rootView: View, useSafeArea: Bool = false) {
        hostView = UIHostingView(content:rootView,useSafeArea: useSafeArea)
        super.init(nibName: nil, bundle: nil)
    }
     
    /// Initializer
    /// - Parameters:
    ///   - aDecoder: An unarchiver object.
    ///   - rootView: The root view of the ArgoKit view hierarchy that you want to manage using the hosting view controller.
    ///   - safeArea: ture if you want to add the insets that you use to determine the safe area for this view.
    public init?(coder aDecoder: NSCoder, rootView: View, useSafeArea: Bool = false) {
        hostView = UIHostingView(content:rootView,useSafeArea: useSafeArea)
        super.init(coder: aDecoder)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var useSafeAreaTop:Bool?{
        didSet{
            hostView.useSafeAreaTop = useSafeAreaTop ?? false
        }
    }
    public var useSafeAreaLeft :Bool?{
        didSet{
            hostView.useSafeAreaLeft = useSafeAreaLeft ?? false
        }
    }
    public var useSafeAreaBottom :Bool?{
        didSet{
            hostView.useSafeAreaBottom = useSafeAreaBottom ?? false
        }
    }
    public var useSafeAreaRight :Bool?{
        didSet{
            hostView.useSafeAreaRight = useSafeAreaRight ?? false
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(hostView)
        hostView.frame = self.view.bounds
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    open override func viewDidLayoutSubviews() {
        hostView.frame = self.view.bounds
        super.viewDidLayoutSubviews()
    }
}
