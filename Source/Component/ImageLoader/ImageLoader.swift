
import UIKit
import ArgoKit
import SDWebImage

public class ImageLoader:ArgoKitImageLoader {
    public init () {}
    
    public func loadImage(url: URL?, placeHolder: String?, successed: ((UIImage?) -> ())?, failure: (() -> ())?) {
        if let url_ = url {
            let imageManager:SDWebImageManager = SDWebImageManager.shared;
            imageManager.loadImage(with: url_, options: SDWebImageOptions.retryFailed, progress: nil) { (image, data, error, type, result, url) in
                if result {
                    var image_:UIImage? = image
                    guard (image != nil) else {
                        if let placeHolder = placeHolder {
                            image_ = UIImage(named: placeHolder)
                        }
                        return
                    }
                    if let successed = successed {
                        successed(image_)
                    }
                }else{
                    if let failure = failure {
                        failure()
                    }
                }
            }
        }else if let placeHolder = placeHolder{
            let image_ = UIImage(named: placeHolder)
            if let successed = successed {
                successed(image_)
            }
        }
    }
        
}
