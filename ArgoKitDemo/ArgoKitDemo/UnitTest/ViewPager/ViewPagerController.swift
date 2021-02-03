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
    let contentView = ArgoKitTextTest(model: ArgoKitTextTestModel())
//      let contentView = YYTextTests(model: YYTextTestsModel())
//    let contentView = ListDemo()
//    let contentView = FeedListModel_Previews().makeView().padding(edge: .horizontal, value: 10)
    override func viewDidLoad() {
        let argoKitControll = UIHostingView(content: contentView, origin: CGPoint(x: 0, y: 84))
//        argoKitControll.useSafeAreaTop = true
        argoKitControll.backgroundColor = .cyan
        self.view.addSubview(argoKitControll)
        self.view.backgroundColor = .white
    }
}
