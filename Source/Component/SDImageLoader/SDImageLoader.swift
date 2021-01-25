
import UIKit
import ArgoKit
import SDWebImage

#if !KFIMAGELOADER
public typealias ImageLoader = SDImageLoader
#endif

public class SDImageLoader:ArgoKitImageLoader {
    public init () {}
    
    public func loadImage(url: URL?, successed: ((UIImage) -> ())?, failure: ((Error?) -> ())?) {
        if let url_ = url {
            let imageManager:SDWebImageManager = SDWebImageManager.shared;
            imageManager.loadImage(with: url_, options: SDWebImageOptions.retryFailed, progress: nil) { (image, data, error, type, result, url) in
                if result, let image = image {
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
    }
}
