//
//  ViewPagerController.swift
//  ArgoKitDemo
//
//  Created by sun-zt on 2020/12/5.
//

import Foundation
import UIKit
import ArgoKit
class ViewPagerController: UIViewController {
    
//    let contentView = ArgoKitGridTest(model: ArgoKitGridTestModel())
//    let contentView = ArgoKitTextTest(model: ArgoKitTextTestModel())
    let contentView = ListDemo()
    override func viewDidLoad() {
        let argoKitControll = UIHostingView(content: contentView, frame: self.view.frame)
        argoKitControll.useSafeAreaTop = true
        argoKitControll.backgroundColor = .white
        self.view.addSubview(argoKitControll)
    }
}
