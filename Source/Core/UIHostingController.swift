//
//  UIHostingController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

public struct DemoModel2 {
    var text1:Text?
    var stack1:HStack?
    init() {
        text1 = Text()
    }
}
struct Demo2ContentView:View {
    let items = ["查查","cscs","122e"]
    let images:Array<UIImage> = Array([UIImage(named: "turtlerock")!])
    var body:View{
//        Slider(value: 0.7,in:-1...1,onValueChanged: { value in
//            print("UISlider ", value)
//        }).width(200).height(30).margin(edge: .top, value: 60)
////
////
//        Toggle(true){ isOn in
//            print("Toggle :",isOn)
//        }.margin(edge: .top, value: 50)
//
////
//        Stepper(value: 10, in: 0...100, step: 4) { value in
//            print("Stepper :",value)
//        }.width(100).height(30).margin(edge: .left, value: 150).value(50).backgroundColor(.cyan)
////
//        PageControl(currentPage: 1, numberOfPages: 10){ index in
//            print("index:",index)
//        }.width(100%).height(50).backgroundColor(.red).margin(edge: .top, value: 100)
////
//        SegmenteControl { index in
//            print("items :",index)
//        } _: {
//           Text("e")
//           Text("r")
//           Text("t")
//           Text("u")
//           ImageView("turtlerock")
//        }.width(100%).height(30).margin(edge: .top, value: 150)
        
        Button(text: "buttom1buttom1buttom1buttom1"){
            print("buttom1")
           
            
        }.titleColor(.red, for: UIControl.State.normal)
        .width(150).height(100).backgroundColor(.yellow).margin(edge: .top, value: 100)
//        ImageView("turtlerock").gesture(gesture: gestur).isUserInteractionEnabled(true)
//        HStack{
////            ImageView("turtlerock")
//            Text("11").backgroundColor(.yellow).height(100).margin(edge: .top, value: 50).position(edge: .left, value: 20)
//                .textColor(.red)
//            Text("111111").backgroundColor(.yellow).height(100).margin(edge: .top, value: 50).position(edge: .left, value: 20)
//                .textColor(.red)
//        }.isUserInteractionEnabled(true)
//        .longPressAction(numberOfTaps: 1, numberOfTouches: 1, minimumPressDuration: 0.5){
//            print("longPressAction")
//        }.tapAction {
//            print("tapAction")
//        }
//
    }
}


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
        weak var weakView = view
        pNode = ArgoKitNode(view: weakView ?? view);
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

    var rootView:RooView?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        
        rootView = RooView(self.view){
            rootView_.body
        }.isUserInteractionEnabled(true)
        .tapAction {[weak self] in
            let viewContraller:UIHostingController = UIHostingController(rootView: Demo2ContentView())
            self?.navigationController?.pushViewController(viewContraller, animated: true)
        }
        
        rootView?.applyLayout()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    deinit {
        print("deinit")
    }
    
    @objc func action() {
        let viewContraller:UIHostingController = UIHostingController(rootView: Demo2ContentView())
        self.navigationController?.pushViewController(viewContraller, animated: true)
    }
    
}
