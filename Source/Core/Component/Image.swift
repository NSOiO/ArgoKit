//
//  ImageView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/26.
//

import Foundation
class ArgoKitImageNode: ArgoKitNode {
    override func prepareForUse() {
        if let imageView = self.view as? UIImageView{
            imageView.image = nil
            imageView.highlightedImage = nil
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let image = self.image()
        let temp_size:CGSize = image?.size ?? CGSize.zero
        return temp_size
    }
    
    public func image(url: URL?, placeholder: String?) {
        let image = placeholder != nil ? UIImage(named: placeholder!) : nil
        ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:UIImageView.image), image)
        ArgoKitInstance.imageLoader()?.loadImage(url: url) { image in
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:UIImageView.image), image)
        } failure: { _ in
            // 图像加载失败
        }
    }
    
}

/// Wrapper of UIImageView
/// A view that displays a single image or a sequence of animated images in your interface.
///
///```
///         Image("name")
///         Image("./doc/name.jpg")
///         Image("https://www.example.com")
///```
///
public struct Image : View {
    
    var pNode : ArgoKitImageNode
    
    /// The node behind the Image.
    public var node: ArgoKitNode? {
        pNode
    }
    
    /// Initializer
    public init() {
        self.init(image: nil, highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameter name: The name of the image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(_ name: @escaping @autoclosure () -> String) {
        let image: () -> UIImage? = { UIImage(named: name(), in: nil, compatibleWith: nil) }
        self.init(image: image(), highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(url: @escaping @autoclosure () -> URL?, placeholder: @escaping @autoclosure () -> String?) {
        self.init(image: nil, highlightedImage: nil)
        self.bindCallback({ [self] in
            pNode.image(url: url(), placeholder: placeholder())
        }, forKey: #function)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(urlString: @escaping @autoclosure () -> String?, placeholder: @escaping @autoclosure () -> String?) {
        self.init(image: nil, highlightedImage: nil)
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
    ///   - name: The name of the image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app’s main bundle.
    public init(_ name: @escaping @autoclosure () -> String, bundle: @escaping @autoclosure () -> Bundle) {
        let image: () -> UIImage? = { UIImage(named: name(), in: bundle(), compatibleWith: nil) }
        self.init(image: image(), highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameter name: The name of the system symbol image. Use the SF Symbols app to look up the names of system symbol images. You can download this app from the design resources page at developer.apple.com.
    @available(iOS 13.0, *)
    public init(systemName name: @escaping @autoclosure () -> String) {
        self.init(image: UIImage(systemName: name()), highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - cgImage: The Quartz image object.
    ///   - scale: The scale factor to assume when interpreting the image data. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the size property.
    ///   - orientation: The orientation of the image data. You can use this parameter to specify any rotation factors applied to the image.
    public init(cgImage: CGImage, scale: CGFloat, orientation: UIImage.Orientation = .up) {
        self.init(image: UIImage(cgImage: cgImage, scale: scale, orientation: orientation), highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - image: The initial image to display in the image view. You may specify an image object that contains an animated sequence of images.
    ///   - highlightedImage: The image to display when the image view is highlighted. You may specify an image object that contains an animated sequence of images.
    public init(image: @escaping @autoclosure () -> UIImage?, highlightedImage: @escaping @autoclosure () -> UIImage? = nil) {
        pNode = ArgoKitImageNode(viewClass: UIImageView.self)
        self.bindCallback({ [self] in
            if let img = image() {
                addAttribute(#selector(setter:UIImageView.image),img)
            }
            if let hightImg = highlightedImage() {
                addAttribute(#selector(setter:UIImageView.highlightedImage),hightImg)
            }
        }, forKey: #function)
    }
}

extension Image {
    
    /// Resizable image.
    /// - Parameters:
    ///   - capInsets: The values to use for the cap insets.
    ///   - resizingMode: The mode with which the interior of the image is resized.
    /// - Returns: self
    @discardableResult
    public func resizable(capInsets: UIEdgeInsets = UIEdgeInsets(), resizingMode: UIImage.ResizingMode = .stretch) -> Self {
        if let image = pNode.image() {
            return self.image(image.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode))
        }
        return self
    }
    
    /// Adjust the rendering mode of the image.
    /// - Parameter renderingMode: The rendering mode to use for the new image.
    /// - Returns: self
    @discardableResult
    public func renderingMode(_ renderingMode: UIImage.RenderingMode = .automatic) -> Self {
        if let image = pNode.image() {
            return self.image(image.withRenderingMode(renderingMode))
        }
        return self
    }
}

extension Image {
        
    /// Starts animating the images in the receiver.
    /// - Returns: self
    @discardableResult
    public func startAnimating() -> Self {
        addAttribute(#selector(UIImageView.startAnimating))
        return self
    }
    
    /// Stops animating the images in the receiver.
    /// - Returns: self
    @discardableResult
    public func stopAnimating() -> Self {
        addAttribute(#selector(UIImageView.stopAnimating))
        return self
    }
}

extension Image {
    
    /// Get the size of  the image displayed in the image view.
    /// - Returns: The size of  the image displayed in the image view.
    public func imageSize() -> CGSize {
        return pNode.image()?.size ?? .zero
    }
}

extension Image{
   @available(*, deprecated, message: "Image does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
   @available(*, deprecated, message: "Image does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
