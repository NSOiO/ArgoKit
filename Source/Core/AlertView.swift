//
//  AlertView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/16.
//

import Foundation
@objcMembers class ArgokitAlertViewNode:ArgoKitNode{
    public dynamic var isPresented: Bool = false
    private var alertController:UIAlertController
    var observer: NSKeyValueObservation!
    public init(alertController:UIAlertController) {
        self.alertController = alertController
        super.init(viewClass: UIView.self)
        
        observer = self.observe(\.isPresented, options: [.new, .initial]) { (object, change) in
           print(change)
        }
    }
}
public class AlertView: View {
    let pNode:ArgokitAlertViewNode
    let alerView:UIAlertController
    public var node: ArgoKitNode?{
        pNode
    }
    public init(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        alerView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        pNode = ArgokitAlertViewNode(alertController: alerView)
    }
}
extension AlertView{
    public func `default`(title:String?,handler:((String?)->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.default) { action in
            if let block = handler{
                block(action.title)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    public func cancel(title:String?,handler:((String?)->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.cancel) { action in
            if let block = handler{
                block(action.title)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    public func destructive(title:String?,handler:((String?)->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.destructive) { action in
            if let block = handler{
                block(action.title)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    
    public func show()->Self{
        if let viewController = self.viewController(){
            viewController.present(alerView, animated: true, completion: nil)
        }
        return self
    }
}

extension View{
   /* public func alert(isPresented:inout Bool,@ArgoKitViewBuilder _ builder:@escaping ()->View) -> Self{
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                if let _node_ = node as? ArgokitAlertViewNode {
                    isPresented = _node_.isPresented
                }
                self.node!.addChildNode(node)
            }
        }
        return self
    }*/
    
    public func alert(_ content:()->AlertView) -> Self{
        let alertView = content()
        if let node = alertView.node {
            self.node!.addChildNode(node)
        }
        return self
    }
}
