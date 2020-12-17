//
//  AppDelegate.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let contentView = ArgoKitViewDemo()
//        let vc = ArgokitDemoController()
        let vc = UIHostingController(rootView: contentView)
        let nav = UINavigationController(rootViewController: vc)
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            vc.view.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
//        }
        return true
    }

}

