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
    func setImageForView(_ view: UIImageView, url: URL?, placeholder: UIImage?, successed: ((UIImage?) -> ())?, failure: ((Error?) -> ())?){
        view.sd_setImage(with: url, placeholderImage: placeholder, options: [.retryFailed]) { (image, error, type, url) in
            if let image = image {
                if let successed = successed {
                    successed(image)
                }
            } else {
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    func loadImage(url: URL?, successed: ((UIImage) -> ())?, failure: ((Error?) -> ())?) {
        guard let _url = url else {
            return
        }
        
        let imageManager:SDWebImageManager = SDWebImageManager.shared;
        imageManager.loadImage(with: _url, options: SDWebImageOptions.retryFailed, progress: nil) { (image, data, error, type, result, url) in
            
            if result, let image = image{
                if let _successed = successed {
                    _successed(image)
                }
                return
            }
            
            if let _failure = failure {
                _failure(error)
            }
        }
    }
}
