//
//  Button.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/16.
//

import Foundation
public struct Button:View{
    public var body: View{
        self
    }
    private var button:UIButton
    private var pNode:ArgoKitNode
    private var pAction:(()->Void)?
    public var type: ArgoKitNodeType{
        .single(pNode)
    }
    public var node: ArgoKitNode?{
        pNode
    }
    private init(){
        button = UIButton(type:.custom);
        pNode = ArgoKitNode(view: button)
    }
    public init(text:String?,action :@escaping ()->Void) {
        self.init()
        pAction = action
        button.setTitle(text, for: .normal)
        button.addTarget(Action.shared, action:#selector(Action.buttonAction), for:.touchUpInside)
    }

    public init(text:String?,action :@escaping ()->Void,@ArgoKitViewBuilder builder:()->View) {
        self.init(text: text, action: action)
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                pNode.addChildNode(node)
            }
        }
    }
}

extension Button{
    public func tapButton(action :@escaping ()->Void)->Self{
        return self;
    }
}

class Action {
    // 单例
    static let shared = Action()
    @objc public func buttonAction(){
        print("buttonAction")
    }
    // 私有化构造方法，不允许外界创建实例
    private init() {
        // 进行初始化工作
    }
}
