//
//  ViewPagerController.swift
//  ArgoKitDemo
//
//  Created by sun-zt on 2020/12/5.
//

import Foundation
import UIKit

class ViewPagerController: UIViewController {
    
    let contentView = ViewPage1()
    
    
    override func viewDidLoad() {

        let argoKitControll = UIHostingController(rootView: contentView)
        argoKitControll.view.frame = self.view.bounds
        argoKitControll.didMove(toParent: self)
        self.addChild(argoKitControll)
        self.view.addSubview(argoKitControll.view)
        
    }
}
