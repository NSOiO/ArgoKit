
import UIKit
import ArgoKit
import Kingfisher

public typealias ImageLoader = KFImageLoader
public class KFImageLoader:ArgoKitImageLoader {
    public init () {}
    public func loadImage(url: URL?, successed: ((UIImage) -> ())?, failure: ((Error?) -> ())?) {
        if let url = url {
            KingfisherManager.shared.retrieveImage(with: url) { r in
                switch r {
                case .success(let value):
                    if let successed = successed  {
                        successed(value.image)
                    }
                    break
                case .failure(let error):
                    if let failure = failure {
                        failure(error)
                    }
                    break
                }
            }
        }
    }
    
    public func setImageForView(_ view: UIImageView, url: URL?, placeholder: UIImage?, successed: ((UIImage?) -> ())?, failure: ((Error?) -> ())?) {
        view.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { result in
            switch(result){
            case .success(let value):
                if let successed = successed  {
                    successed(value.image)
                }
                break
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                }
                break
            }
        }
    }
    

}
