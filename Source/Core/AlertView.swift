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
    }
}
public class AlertView: View {
    let pNode:ArgokitAlertViewNode
    let alerView:UIAlertController
    var pTextField:UITextField?
    public var node: ArgoKitNode?{
        pNode
    }
    public init(title: String? = "", message: String? = "", preferredStyle: UIAlertController.Style){
        alerView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        pNode = ArgokitAlertViewNode(alertController: alerView)
    }
}
extension AlertView{
    public func `default`(title:String?,handler:((String?)->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.default) {[weak self] action in
            if let block = handler{
                block(self?.pTextField?.text)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    public func cancel(title:String?,handler:(()->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.cancel) { action in
            if let block = handler{
                block()
            }
        }
        alerView.addAction(alertAction)
        
        return self
    }
    public func destructive(title:String?,handler:((String?)->Void)?)->Self{
        let alertAction:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.destructive) { [weak self] action in
            if let block = handler{
                block(self?.pTextField?.text)
            }
        }
        alerView.addAction(alertAction)
        return self
    }
    
    public func textField()->Self{
        alerView.addTextField { [weak self] textFiled in
            self?.pTextField = textFiled
        }
        return self
    }
    
    public func show(){
        if let viewController = self.rootViewController(){
            viewController.present(alerView, animated: true, completion: nil)
        }
    }
}
/*
@available(iOS 9.0, *)
open var preferredAction: UIAlertAction?


open func addTextField(configurationHandler: ((UITextField) -> Void)? = nil)
 */
extension AlertView{
    public func titile(_ value: String?)->Self{
        alerView.title = value
        return self
    }
    public func message(_ value: String?)->Self{
        alerView.message = value
        return self
    }
}

extension View{
    public func alert(_ content:()->AlertView) -> Self{
        let alertView = content()
        if let node = alertView.node {
            self.node!.addChildNode(node)
        }
        return self
    }
}
