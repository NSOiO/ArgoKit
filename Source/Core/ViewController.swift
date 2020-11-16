//
//  ViewController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/16.
//

import Foundation
extension View{
    public func viewController()->UIViewController?{
        if let view = self.node?.view {
            var next = view.next
            repeat{
                if let _ = next?.isKind(of: UIViewController.self) {
                    return next as? UIViewController
                }
                next = view.next
            }while next != nil
        }
        return nil
    }
}

extension View{
    public func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        var alerView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        var action:UIAlertAction = UIAlertAction(title: title, style: style) { (<#UIAlertAction#>) in
            
        }
    }
}
