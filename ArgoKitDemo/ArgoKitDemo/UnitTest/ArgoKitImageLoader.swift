//
//  ArgoKitImageLoader.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import Foundation
import ArgoKit
import SDWebImage
class ImageLoader: ArgoKit.ArgoKitImageLoader {
    func loadImage(url: URL?, placeHolder: String?, successed: ((UIImage?) -> ())?, failure: (() -> ())?) {
        
        guard let _url = url else {
            if let _placeHolder = placeHolder,
               let _image = UIImage(named: _placeHolder),
               let _successed = successed {
                _successed(_image)
            }
            return
        }
        
        let imageManager:SDWebImageManager = SDWebImageManager.shared;
        imageManager.loadImage(with: _url, options: SDWebImageOptions.retryFailed, progress: nil) { (image, data, error, type, result, url) in
            
            if result {
                var _image: UIImage? = image
                if _image == nil, let _placeHolder = placeHolder {
                    _image = UIImage(named: _placeHolder)
                }
                if let _successed = successed {
                    _successed(_image)
                }
                return
            }
            
            if let _failure = failure {
                _failure()
            }
        }
    }
}
