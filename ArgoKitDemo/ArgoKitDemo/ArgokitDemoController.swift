//
//  ArgokitDemoController.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/11/26.
//

import Foundation
import UIKit
import ArgoKit
public class SessionItem:ArgoKitIdentifiable{
    public var identifier: String
    public var reuseIdentifier: String
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    var timeLabel:String?
    var unreadCount:String?

    var textCom:Text?
    var hidden:Bool = false

    init(identifier:String,reuseIdentifier:String) {
        self.identifier = identifier
        self.reuseIdentifier = reuseIdentifier
    }

}
class ArgokitDemoController:UIViewController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostView:UIHostingView = UIHostingView()
        hostView.frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 200)
        hostView.backgroundColor = .red
        self.view.addSubview(hostView)
        
        HStack(hostView){
            ArgoKitOtherViewTest(model: ArgoKitOtherViewTestModel())
           
        }
        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 5) {
            hostView.frame = CGRect(x: 0, y: 200, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 400)
        }
    }
    deinit {
        print("deinit")
    }

}
