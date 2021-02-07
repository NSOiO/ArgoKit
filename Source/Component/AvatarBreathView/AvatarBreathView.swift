
import UIKit
import ArgoKit
import MDAvatarBreathAnimationView
class AvatarBreathNode: ArgoKitNode {
    public func image(url: URL?, placeholder: String?) {
        let image = placeholder != nil ? UIImage(named: placeholder!) : nil
//        ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDAvatarBreathAnimationView.headerImage), image)
        ArgoKitInstance.imageLoader()?.loadImage(url: url) { image in
//            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDAvatarBreathAnimationView.headerImage), image)
        } failure: { _ in
            // 图像加载失败
        }
    }
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        return MDAvatarBreathAnimationView(frame: frame)
    }
}
public struct AvatarBreathView:View {
    private var pNode:AvatarBreathNode
    public var node: ArgoKitNode?{
        pNode
    }
    init() {
        pNode = AvatarBreathNode(viewClass: MDAvatarBreathAnimationView.self)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(url: @escaping @autoclosure () -> URL?, placeholder: @escaping @autoclosure () -> String?){
        self.init()
        self.bindCallback({ [self] in
            pNode.image(url: url(), placeholder: placeholder())
        }, forKey: #function)
    }
}

extension AvatarBreathView{
//    public func image(_ value:@escaping @autoclosure () -> UIImage?) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.headerImage),value())
//        }, forKey: #function)
//    }
//    public func imageCornerRadius(_ value:@escaping @autoclosure () -> CGFloat) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.imageCornerRadius), value())
//        }, forKey: #function)
//    }
//    public func imageCircle(_ value:@escaping @autoclosure () -> Bool) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.imageCircle), value())
//        }, forKey: #function)
//    }
//    
//    public func headerMargin(_ value:@escaping @autoclosure () -> CGFloat) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.headerMargin), value())
//        }, forKey: #function)
//    }
//    
//    public func strokeColor(_ value:@escaping @autoclosure () -> NSString?) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.fillColor), value())
//        }, forKey: #function)
//    }
//    
//    public func fillColor(_ value:@escaping @autoclosure () -> NSString?) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.contentColor), value())
//        }, forKey: #function)
//    }
//    
//    public func tagText(_ value:@escaping @autoclosure () -> String?) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(setter:MDAvatarBreathAnimationView.tagText), value())
//        }, forKey: #function)
//    }
//    
//    public func startAnimation(_ value:@escaping @autoclosure () -> Bool?) -> Self{
//        self.bindCallback({ [self] in
//            addAttribute(#selector(MDAvatarBreathAnimationView.startAnimation(_:)), value())
//        }, forKey: #function)
//    }
}
