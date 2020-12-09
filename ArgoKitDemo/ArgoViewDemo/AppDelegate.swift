//
//  AppDelegate.swift
//  ArgoViewDemo
//
//  Created by Dai on 2020-12-07.
//

import UIKit
import ArgoKitComponent
import ArgoKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())

        // Override point for customization after application launch.
        let vc = ViewController()
//        let content = MSHeaderView(data: MSHeaderViewModel_Previews())
//        let host = UIHostingController.init(rootView: content)
        
        let nav = UINavigationController.init(rootViewController: vc)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

