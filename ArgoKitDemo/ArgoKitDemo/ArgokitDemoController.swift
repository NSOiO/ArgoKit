//
//  ArgokitDemoController.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/26.
//

import Foundation
import UIKit
class ArgokitDemoController:UIViewController{
    let contentView = ArgoKitViewDemo()
    open override func viewDidLoad() {
        super.viewDidLoad()
        let argoKitControll = UIHostingController(rootView: contentView)
        argoKitControll.view.frame = self.view.bounds
        argoKitControll.didMove(toParent: self)
        self.addChild(argoKitControll)
        self.view.addSubview(argoKitControll.view)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    open override func viewDidLayoutSubviews() {
    }
    
    open override func viewLayoutMarginsDidChange() {
        
    }

    deinit {
        print("deinit")
    }

    
}
