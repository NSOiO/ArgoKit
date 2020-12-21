//
//  AppDelegate.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        
        var nav: UINavigationController?
        
        //SwiftUI
//        if #available(iOS 13.0.0, *) {
////            let content = LandmarkList_Previews.previews
////            let content = ToggleRow_Previews.previews
//            let content = GestureTests_Previews.previews
//            let vc = SwiftUI.UIHostingController(rootView: content)
//            nav = UINavigationController(rootViewController: vc)
//        }
        
        let contentView = ArgoKitGridTest(model: ArgoKitGridTestModel())

//        let contentView = ArgoKitTextViewTest(model: ArgoKitTextViewTestModel())
//        let contentView = ArgoKitMoveAnimationTest(model: ArgoKitMoveAnimationTestModel())
//        let contentView = GestureTests(model: GestureTestsModel())
//        let vc = ArgokitDemoController()
        let vc = UIHostingController(rootView: contentView)
//        let vc = ViewController()
        nav = UINavigationController(rootViewController: vc)
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
//            vc.view.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//        }
        return true
    }

}

