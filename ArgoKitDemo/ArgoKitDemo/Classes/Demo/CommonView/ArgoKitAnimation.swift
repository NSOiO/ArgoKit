//
//  ArgoKitAnimation.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/18.
//

import ArgoKit

// view model.
protocol ArgoKitAnimationModelProtocol: ViewModelProtocol {
    var textView: Text? {get set}
    var scrollView: ScrollView? {get set}
    var resetOnStop: Bool {get set}
    var autoReverse: Bool {get set}
    var repeatCount: Int {get set}
    var repeatTimes: Bool {get set}
    var repeatForever: Bool {get set}
    var delayTime: Float {get set}
    var isDelay: Bool {get set}
}

// view
struct ArgoKitAnimation: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitAnimationModelProtocol
    init(model: ArgoKitAnimationModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        VStack {
            HStack {
                initButton(text: "alpha") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .alpha)
                                .to(0.5)
                                .duration(1)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
                initButton(text: "backgroundColor") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .color)
                                .duration(2.0)
                                .from(UIColor.clear)
                                .to(UIColor.orange)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
                initButton(text: "textColor") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .textColor)
                                .duration(2.0)
                                .to(UIColor.white)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
            }
            .justifyContent(.around)
            
            HStack {
                initButton(text: "position") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .position)
                                .duration(2.0)
                                .from(50, 100)
                                .to(Float(model.textView?.nodeView()?.superview?.frame.size.width ?? 0) - Float(model.textView?.nodeView()?.frame.size.width ?? 0), Float(model.textView?.nodeView()?.superview?.frame.size.height ?? 0) - Float(model.textView?.nodeView()?.frame.size.height ?? 0))
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
                
                initButton(text: "rotation") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .rotation)
                                .duration(2.0)
                                .to(180)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
                
                initButton(text: "scale") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .scale)
                                .duration(1.5)
                                .from(1, 1)
                                .to(1.5, 1.5)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
            }
            .justifyContent(.around)
            .margin(edge: .top, value: 15)
            
            HStack {
                initButton(text: "spring scale") {
                    model.textView?
                        .addAnimation {
                            SpringAnimation(type: .scale)
                                .springSpeed(0)
                                .springBounciness(20)
                                .duration(1.5)
                                .from(1, 1)
                                .to(1.5, 1.5)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
                
                initButton(text: "contentOffset") {
                    model.scrollView?
                        .addAnimation {
                            Animation(type: .contentOffset)
                                .duration(1.5)
                                .from(0, 0)
                                .to(0, -50)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                        }
                        .startAnimation()
                }
            }
            .justifyContent(.around)
            .margin(edge: .top, value: 15)
            
            HStack {
                initButton(text: "combine group") {
                    model.textView?
                        .addAnimation {
                            Animation(type: .position)
                                .duration(1.5)
                                .to(200, 50)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                                .timingFunc(.easeIn)
                            
                            Animation(type: .rotation)
                                .duration(1.5)
                                .from(0)
                                .to(360)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                                .timingFunc(.easeIn)

                            Animation(type: .scale)
                                .duration(1.5)
                                .to(1.5, 1.5)
                                .resetOnStop(model.resetOnStop)
                                .autoReverse(model.autoReverse)
                                .repeatCount(model.repeatCount)
                                .repeatForever(model.repeatForever)
                                .delay(model.delayTime)
                                .timingFunc(.easeIn)
                        }
                        .startAnimation(serial: false)
                }
                
                initButton(text: "serial group") {
                    model.textView?.addAnimationGroup(AnimationGroup({
                        Animation(type: .position)
                            .duration(1.5)
                            .to(200, 50)
                        
                        Animation(type: .rotation)
                            .duration(1.5)
                            .from(0)
                            .to(360)
                        
                        Animation(type: .scale)
                            .duration(1.5)
                            .to(1.5, 1.5)
                    })
                    .resetOnStop(model.resetOnStop)
                    .autoReverse(model.autoReverse)
                    .repeatCount(model.repeatCount)
                    .repeatForever(model.repeatForever)
                    .delay(model.delayTime)
                    .serial(true))
                    .startAnimation(serial: true)
                }
            }
            .justifyContent(.around)
            .margin(edge: .top, value: 15)
            
            HStack {
                initToggle(text: "resetOnStop", toggle: Toggle(model.resetOnStop) { isOn in
                    model.resetOnStop.toggle()
                })
                
                initToggle(text: "autoReverse", toggle: Toggle(model.autoReverse) { isOn in
                    model.autoReverse.toggle()
                })
                
                initToggle(text: "repeat 3", toggle: Toggle(model.repeatTimes) {
                    isOn in
                    model.repeatTimes.toggle()
                })
                
                initToggle(text: "repeatForever", toggle: Toggle(model.repeatForever) {
                    isOn in
                    model.repeatForever.toggle()
                })
                
                initToggle(text: "delay 2 sec", toggle: Toggle(model.isDelay) {
                    isOn in
                    model.isDelay.toggle()
                })
            }
            .wrap(.wrap)
            .justifyContent(.start)

            HStack {
                initButton(text: "pause") {
                    model.textView?.pauseAnimation()
                }
                .backgroundColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
                .margin(edge: .top, value: 15)
                .grow(2)
                
                Spacer()
                
                initButton(text: "resume") {
                    model.textView?.resumeAnimation()
                }
                .backgroundColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
                .margin(edge: .top, value: 15)
                .grow(2)
            }
            .justifyContent(.between)
            
            
            initButton(text: "stop") {
                model.textView?.stopAnimation()
            }
            .width(50%)
            .backgroundColor(.red)
            .margin(edge: .top, value: 15)
            .alignSelf(.center)
            
            ScrollView {
                Text("ScrollView")
                    .font(size: 12)
                Text("repeat count: " + "\(model.repeatCount)")
                    .font(size: 14)
                Text("delay time: " + "\(model.delayTime)")
                    .font(size: 14)
                
                Text("Animation Text")
                    .alias(variable: &model.textView)
                    .textAlign(.center)
                    .alignSelf(.center)
                    .borderWidth(2)
                    .borderColor(.white)
                    .cornerRadius(5)
                    .margin(edge: .top, value: 15)
                    .padding(top: 5, right: 10, bottom: 5, left: 10)
            }
            .margin(edge: .top, value: 30)
            .backgroundColor(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
            .width(100%)
            .height(200)
            .alias(variable: &model.scrollView)
            .grow(1)
        }
        .margin(edge: .horizontal, value: 20)
        .margin(edge: .top, value: 15)
    }
}

extension ArgoKitAnimation {
    
    func initButton(text: String,
                    _ action: @escaping () -> Void) -> Button {
        Button(action: action) {
            Text(text)
                .textColor(.white)
                .font(.boldSystemFont(ofSize: 16))
                .textAlign(.center)
        }
        .backgroundColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        .cornerRadius(5)
        .padding(top: 10, right: 10, bottom: 10, left: 10)
        .justifyContent(.center)
    }
    
    func initToggle(text: String, toggle: Toggle) -> View {
        HStack {
            Text(text)
                .shrink(1)
                .font(size: 15)
            toggle
                .margin(edge: .right, value: 15)
        }
        .justifyContent(.between)
        .alignItems(.center)
        .width(50%)
        .margin(edge: .top, value: 15)
    }
}

extension ArgoKitAnimationModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitAnimation(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitAnimationModelPreviews: ArgoKitAnimationModelProtocol {
    var textView: Text? = nil
    var scrollView: ScrollView? = nil
    @Observable var resetOnStop: Bool = false
    @Observable var autoReverse: Bool = false
    @Observable var repeatCount: Int = 0
    @Observable var repeatTimes: Bool = false {
        didSet {
            repeatCount = repeatTimes ? 2 : 0
        }
    }
    @Observable var repeatForever: Bool = false
    @Observable var delayTime: Float = 0
    @Observable var isDelay: Bool = false {
        didSet {
            delayTime = isDelay ? 2 : 0
        }
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
private func argoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitAnimationPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitAnimationModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif

