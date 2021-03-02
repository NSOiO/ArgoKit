//
//  ArgoKitImageLoader.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/3.
//

import Foundation
import UIKit
public protocol ArgoKitImageLoader {
    func loadImage(url: URL?, successed: ((UIImage)->())?, failure: ((Error?)->())?)
    
    func setImageForView(view:UIImageView,url: URL?,
                         placeholder: UIImage?,
                         successed: ((UIImage?) -> ())?,
                         failure: ((Error?) -> ())?)
}
extension ArgoKitImageLoader{
    
    func loadImage(url: URL?, successed: ((UIImage)->())?, failure: ((Error?)->())?){
        
    }
    
    func setImageForView(view:UIImageView,url: URL?,
                         placeholder: UIImage?,
                         successed: ((UIImage?) -> ())?,
                         failure: ((Error?) -> ())?){
        
    }
}
