//
//  RealAuthIconView.swift
//  ArgoKitComponent-LikeView-Refresh-SDImageLoader
//
//  Created by Bruce on 2021/2/5.
//

import Foundation
import ArgoKit
import MDRealAuthIconView
class MDRealAuthIconNode: ArgoKitNode {
    var clickBlock:(()->())?
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let view = MDRealAuthIconView(frame: frame)
        view.clickBlock = {[weak self] in
            if let `self` = self,let clickBlock = self.clickBlock{
                clickBlock()
            }
        }
        return view
    }
    override func reusedAttributes(from node: ArgoKitNode) {
        if let pnode = node as? MDRealAuthIconNode,let view = self.view as?  MDRealAuthIconView{
            view.clickBlock = {[weak self] in
                if let `self` = self,let clickBlock = self.clickBlock{
                    clickBlock()
                }
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let image = self.image()
        let temp_size:CGSize = image?.size ?? CGSize.zero
        return temp_size
    }
    
    public func image(url: URL?, placeholder: String?) {
        let image = placeholder != nil ? UIImage(named: placeholder!) : nil
        ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDRealAuthIconView.image), image)
        ArgoKitInstance.imageLoader()?.loadImage(url: url) { image in
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDRealAuthIconView.image), image)
        } failure: { _ in
            // 图像加载失败
        }
    }
    
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        clickBlock = nil
    }
}
public struct RealAuthIconView:View{
    private var pNode:MDRealAuthIconNode
    public var node: ArgoKitNode?{
        pNode
    }
    public init() {
        pNode = MDRealAuthIconNode(viewClass: MDRealAuthIconView.self)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(urlString: @escaping @autoclosure () -> String?, placeholder: @escaping @autoclosure () -> String?) {
        self.init()
        var url:URL? = nil
        self.bindCallback({ [self] in
            if let urlString = urlString() {
                url = URL(string: urlString)
            }
            pNode.image(url: url, placeholder: placeholder())
        }, forKey: #function)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - image: The initial image to display in the image view. You may specify an image object that contains an animated sequence of images.
    ///   - highlightedImage: The image to display when the image view is highlighted. You may specify an image object that contains an animated sequence of images.
    public init(image: @escaping @autoclosure () -> UIImage?, highlightedImage: @escaping @autoclosure () -> UIImage? = nil) {
        self.init()
        self.bindCallback({ [self] in
            if let img = image() {
                addAttribute(#selector(setter:MDRealAuthIconView.image),img)
            }
            if let hightImg = highlightedImage() {
                addAttribute(#selector(setter:MDRealAuthIconView.highlightedImage),hightImg)
            }
        }, forKey: #function)
    }
    
    
}
extension RealAuthIconView{
    /// Sets the displayed image.
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: self
    @discardableResult
    public func image(url: @escaping @autoclosure () -> URL?, placeholder: @escaping @autoclosure () -> String?) -> Self {
        return self.bindCallback({ [self] in
            pNode.image(url: url(), placeholder: placeholder())
        }, forKey: #function)
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: self
    @discardableResult
    public func image(urlString: @escaping @autoclosure () -> String?, placeholder: @escaping @autoclosure () -> String?) -> Self {
        return self.bindCallback({
            var url:URL? = nil
            if let urlString = urlString() {
                url = URL(string: urlString)
            }
            pNode.image(url: url, placeholder: placeholder())
        }, forKey: #function)
    }
    /// Sets the displayed image.
    /// - Parameters:
    ///   - value: The image displayed in the image view.
    ///   - placeholder: The placeholder image displayed in the image view if the value invalid
    /// - Returns: self
    @discardableResult
    public func image(_ value: @escaping @autoclosure () -> UIImage?, placeholder: @escaping @autoclosure () -> UIImage?) -> Self {
        return self.bindCallback({ [self] in
            self.image(value() ?? placeholder())
        }, forKey: #function)
    }
    
    /// Sets the displayed image.
    /// - Parameter value: The image displayed in the image view.
    /// - Returns: self
    @discardableResult
    public func image(_ value: @escaping @autoclosure () -> UIImage?) -> Self {
        return self.bindCallback({ [self] in
            addAttribute(#selector(setter:MDRealAuthIconView.image),value())
        }, forKey: #function)
    }
    
    
    @discardableResult
    public func gotoStr(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(setter:MDRealAuthIconView.gotoStr), value())
        }, forKey: #function)
    }
    @discardableResult
    public func source(_ value:@escaping @autoclosure () -> MDRealAuthIconViewSource) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(setter:MDRealAuthIconView.source), value().rawValue)
        }, forKey: #function)
    }
    @discardableResult
    public func stopAnimation(_ value:@escaping @autoclosure () -> Bool) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(setter:MDRealAuthIconView.stopAnimation), value())
        }, forKey: #function)
    }
    @discardableResult
    public func enlargeTapLength(_ value:@escaping @autoclosure () -> CGFloat) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(setter:MDRealAuthIconView.enlargeTapLength), value())
        }, forKey: #function)
    }
    @discardableResult
    public func actionWithGoto(gotoStr:@escaping @autoclosure () -> String?,source:@escaping @autoclosure () -> MDRealAuthIconViewSource) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(MDRealAuthIconView.action(withGoto:source:)), gotoStr(),source().rawValue)
        }, forKey: #function)
    }
    @discardableResult
    public func setSoure(_ source:@escaping @autoclosure () -> MDRealAuthIconViewSource,gotoStr:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(MDRealAuthIconView.setSoure(_:gotoStr:)),source().rawValue,gotoStr())
        }, forKey: #function)
    }
    @discardableResult
    public func tapAction(_ value:@escaping @autoclosure () -> Bool) -> Self{
        self.bindCallback({ [self] in
            let tap = value()
            if tap{
                addAttribute(#selector(MDRealAuthIconView.tapAction))
            }
        }, forKey: #function)
    }
    
    @discardableResult
    public func iconSelect(_ value:@escaping()->()) -> Self{
        pNode.clickBlock = value
        return self
    }
    
    
}
