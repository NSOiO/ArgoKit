
import UIKit
import ArgoKit
import Kingfisher

#if !SDIMAGELOADER
public typealias ImageLoader = KFImageLoader
#endif

public class KFImageLoader:ArgoKitImageLoader {
    public init () {}
    public func loadImage(url: URL?, successed: ((UIImage) -> ())?, failure: ((Error?) -> ())?) {
        if let url = url {
            _ = KF.url(url)
                .onSuccess { result in
                    if let successed = successed {
                        successed(result.image)
                    }
                }
                .onFailure { error in
                    if let failure = failure {
                        failure(error)
                    }
                }
        }
    }
}
