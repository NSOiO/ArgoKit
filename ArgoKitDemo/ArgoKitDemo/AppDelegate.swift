//
//  AppDelegate.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/10/22.
//

import UIKit
import ArgoKit
import SwiftUI
import FLEX
#if DEBUG
import ArgoKitPreview
#endif
var argokit_dep = ArgoKit.Dep()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var listModel: FeedListModelProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        _argokit_preview_config_()
        ArgoKitPreview_FitFlex();
        FLEXManager.shared.showExplorer()
        #endif
        var nav: UINavigationController?
        //SwiftUI
//        if #available(iOS 13.0.0, *) {
////            let content = LandmarkList_Previews.previews
////            let content = ToggleRow_Previews.previews
//            let content = GestureTests_Previews.previews
//            let vc = SwiftUI.UIHostingController(rootView: content)
//            nav = UINavigationController(rootViewController: vc)
//        }
        
//        let contentView = ArgoKitMoveAnimationTest(model: ArgoKitMoveAnimationTestModel())

//        let contentView = ArgoKitGridTest(model: ArgoKitGridTestModel())
//        let contentView = ListCellTests(model: ListCellTestsModel_Previews())
//        contentView.padding(edge: .top, value: 100)
//        let contentView = YYTextTests(model: YYTextTestsModel())
//        let contentView = ListTestsModel_Previews().makeView().padding(edge: .horizontal, value: 10)
//        let model = FeedListModel_Previews()
//        let contentView = model.makeView().padding(edge: .horizontal, value: 10)
        
        
        
//        let model = FeedListModel_Previews()
//        let contentView = FeedList(model: model).padding(edge: .horizontal, value: 10)
//        self.listModel = model
//        let contentView = ArgoKitTextTest(model: ArgoKitTextTestModel())
//        let contentView = ViewPage1()
//        let contentView = ArgoKitImageTest(model: ArgoKitImageTestModel())
//        let vc = ArgokitDemoController()
//        let contentView = ListDemo()//TextBindTests(model: TextBindTestsModel()).padding(edge: .top, value: 200)
//        let vc = UIHostingController(rootView: contentView,useSafeArea: true)
//        let vc = ViewPagerController()
        let vc = ViewController()
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

