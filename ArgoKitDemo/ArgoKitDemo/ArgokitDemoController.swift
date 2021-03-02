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
    var sectionHeader:String?
    private var reuser:String!
    public var reuseIdentifier: String{
        reuser
    }
    
    var imagePath:String?
    var sessionName:String?
    var lastMessage:String?
    @Observable var  isEnable:Bool = true
    var timeLabel:String?
    var unreadCount:String?
    var freshId = (Int.min...).makeIterator()

    var textCom:Text?
    var hidden:Bool = false

    init(reuseIdentifier:String) {
        self.reuser = reuseIdentifier
    }

}
class ArgokitDemoController:UIViewController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostView:UIHostingView = UIHostingView(content:ViewPage1())
        hostView.frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 200)
        hostView.backgroundColor = .red
        self.view.addSubview(hostView)
    
    
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 5) {
            hostView.frame = CGRect(x: 0, y: 200, width: 300, height: self.view.bounds.size.height - 400)
        }
    }
    deinit {
        print("deinit")
    }

}
