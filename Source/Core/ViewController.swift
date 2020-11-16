//
//  ViewController.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/16.
//

import Foundation
extension View{
    public func viewController()->UIViewController?{
        if let tempview = self.node?.view {
            for view in sequence(first: tempview.superview, next: {$0?.superview}){
                        if let responder = view?.next{
                            if responder.isKind(of: UIViewController.self){
                                return responder as? UIViewController
                            }
                        }
                    }
            return nil
        }
        return nil
    }
}
