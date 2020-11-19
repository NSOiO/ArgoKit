//
//  ViewController.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit
class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
//        let width:CGFloat  = self.view.bounds.size.width;
//        let height:CGFloat  = self.view.bounds.size.height;
//
//        VStack(self.view){
//            ContentView().body.marginH(point: 100).width(point: 200).height(point: 400).backgroundColor(.yellow)
//        }.backgroundColor(.clear).width(point: width)
//        .height(point: height).done()
//        print("buttom1")
        
        let b1 = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 60))
        self.view.addSubview(b1)
        b1.addTarget(self, action: #selector(buttonAction1(button:)), for: .touchUpInside)
        b1.setTitle("Ani_1", for: .normal)
        
        let b2 = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 60))
        self.view.addSubview(b2)
        b2.addTarget(self, action: #selector(buttonAction2(button:)), for: .touchUpInside)
        b2.setTitle("Ani_2", for: .normal)
        
        
        let a = AniTest()
        a.go()
        
    }
    
    @objc func buttonAction1(button: UIButton) {
        self.testAnimation()
    }
    
    @objc func buttonAction2(button: UIButton) {
        self.doAniamtion(target: self.view)
    }
    
    public struct AniTest {
        public init() {}
        public func go() {
            let popAnimation: [AnimationElement] = [
                .type(.alpha),
                .duration(11),
                .autoReverse(false),
                .from(11),
                .from(.red),
                .from(11, 12),
                .from(11, 22, 33, 44),
                .to(.black)
            ]
            let ani = AKAnimation.build(elements: popAnimation)
            
            ani.start()
            
        }
    }
    
    func testAnimation() -> Void {
//        let root = (rootView?.node?.view)!
        let root = self.view!
        if let target = root.viewWithTag(2020) {
            doAniamtion(target: target)
        } else {
            let view = UIView()
            view.akLayoutFrame = CGRect(x:160, y: 400, width: 100, height: 100)
            view.backgroundColor = UIColor.green
            view.tag = 2020
            root.addSubview(view)
            
            doAniamtion(target: view)
        }
        print("--->> ArgoKit: start animation \(root)")
    }
    
//    @TupleBuilder
//    func build() -> (Int, Int, Int) {
//      1
//      2
//      3
//    }
    
    
    func doAniamtion(target: UIView) {
//        let anim = AKAnimation(type: AKAnimationType.positionX)
//        anim.duration(2).from(60).to(160)
//        anim.attach(target)
//        anim.start()
//        ttt("aa", "bb", "dd")
//        let anim = AKAnimation(type: AKAnimationType.color)
//        anim.duration(2).from(UIColor.green).to(UIColor.red)
//        anim.attach(target)
//        anim.start()
//        let anim = AKAnimation(type: AKAnimationType.color)
//        anim.duration(2).from(UIColor.green).to(0, 255, 255, 1)
//        anim.attach(target)
//        anim.start()
        
        
        
        let anim = AKAnimation(type: AKAnimationType.scale)
        anim.duration(2)
            .from((1, 1)).to((3, 3))
//        anim.attach(target)
        target.addAnimation(anim)
        anim.autoReverse(true)
//        anim.timingFunc(.linear)
        anim.start()
        
//        let anim = AKSpringAnimation(type: AKAnimationType.positionX)
//        anim.springMass(20).springSpeed(100)
//        anim.duration(0.2).from(60).to(160)
//        anim.attach(target)
//        anim.start()
        
    
    }

}

struct TupleV<T> {
    var value: T
    public init(_ value: T) {
        self.value = value
    }
}

//struct ContentView:View {
//    let items = ["1","2","3"]
//    var body:View{
////        ForEach(items){item in
////            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 120)
////                .left(point: 20).textColor(.red)
////
////        }.dirRow()
////
////        ForEach(items){item in
////            Text(item as? String).backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 20)
////                .left(point: 20).textColor(.red)
////        }.dirColumn()
//
//        Text("sds").backgroundColor(.yellow).width(point: 100).height(point: 100).marginTop(point: 50)
//            .left(point: 20).textColor(.red)
//
//        Button(text: "buttom"){
//            print("buttom1")
//
//        }.backgroundColor(.orange).width(point: 100).height(point: 100).tapButton {
//            print("buttom1")
//        }
//
////        HStack().backgroundColor(.gray).width(point: 100).height(point: 100)
//
//
//    }
//}
