//
//  AlertView.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/16.
//

import Foundation
public class ArgokitAlertViewNode:ArgoKitNode{
    var alertController:UIAlertController
    init(alertController:UIAlertController) {
        super.init(viewClass: UIView.self)
        self.alertController = alertController
    }
}
public class AlertView: View {
    let pviewContraller:ArgokitAlertViewNode
    public var node: ArgoKitNode?{
        pviewContraller
    }
    public init(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        var alerView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        pviewContraller = ArgokitAlertViewNode(alertController: alerView)
//        var action:UIAlertAction = UIAlertAction(title: title, style: UIAlertAction.Style.cancel) { action in
//
//        }
    }
}
