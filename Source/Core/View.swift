//
//  NodeView.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation

public enum ArgoKitNodeType {
    case empty
    case multiple([ArgoKitNode])
    case single(ArgoKitNode)
    
    public func viewNode() -> ArgoKitNode? {
        switch self {
        case .empty:
            return nil
        case .single(let node):
            return node
        case .multiple(let nodes):
            let container = ArgoKitNode(view: UIView())
            for node in nodes {
                container.addChildNode(node)
            }
            return container
        }
    }
    
    public func viewNodes() -> [ArgoKitNode]? {
        switch self {
        case .empty:
            return nil
        case .multiple(let nodes):
            return nodes
        case .single(let node):
            return [node]
        }
    }
}

public protocol View {
    // 初始视图层次
    var type: ArgoKitNodeType{get}
    // 布局节点对象
    var node:ArgoKitNode?{get}
    
    @ArgoKitViewBuilder var body: View { get }
    
}

private struct AssociatedNodeKey {
       static var nodeKey:Void?
}
public extension View{
    @ArgoKitViewBuilder var body: View {
        ViewEmpty()
    }
    var type: ArgoKitNodeType{
        if let _node:ArgoKitNode = node {
            return .single(_node)
        }else{
            return .empty
        }
    }
    
    var node:ArgoKitNode?{
        get{
            var obj = objc_getAssociatedObject(self, &AssociatedNodeKey.nodeKey) as? ArgoKitNode
            if (obj == nil) {
                obj = ArgoKitNode(viewClass: UIView.self)
                objc_setAssociatedObject(self, &AssociatedNodeKey.nodeKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return obj
        }
    }
}

extension View{
    public func alias<T>(variable ptr:inout T?) -> Self where T: View{
        ptr = self as? T
        return self
    }
}

extension View{
    public func addSubNodes(@ArgoKitViewBuilder builder:@escaping ()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}


// UIGestureRecognizer
extension View{
    public func gesture(gesture:Gesture)->Self{
        gesture.gesture.isEnabled = true
        addAttribute(#selector(UIView.addGestureRecognizer(_:)),gesture.gesture)
        self.node?.addTarget(gesture.gesture, for: UIControl.Event.valueChanged) { (obj, paramter) in
            if let gestureRecognizer = obj as? UIGestureRecognizer {
                gesture.action(gestureRecognizer)
            }
            return nil
        }
        return self
    }
    public func removeGesture(gesture:Gesture)->Self{
        self.node?.view?.removeGestureRecognizer(gesture.gesture)
        return self
    }
}

extension View{
    public func onTapGesture(numberOfTaps: Int = 1, numberOfTouches: Int = 1,action:@escaping ()->Void)->Self{
        let gesture = TapGesture(numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
    public func onLongPressGesture(numberOfTaps:Int, numberOfTouches:Int,minimumPressDuration:TimeInterval = 0.5,allowableMovement:CGFloat = 10,action:@escaping ()->Void)->Self{
        let gesture = LongPressGesture(numberOfTaps:numberOfTaps,numberOfTouches:numberOfTouches,minimumPressDuration:minimumPressDuration,allowableMovement:allowableMovement) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
}

extension View {
    
    public func endEditing(_ force: Bool) -> Self {
        self.node?.view?.endEditing(force)
        return self
    }
}

extension View {
    
    public func addAnimation(_ animation: AKAnimation) -> Self {
        if let view = self.node?.view {
            animation.attach(view)
        }
        return self
    }
}
