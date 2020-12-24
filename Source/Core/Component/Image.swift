//
//  ImageView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/26.
//

import Foundation
class ArgoKitImageNode: ArgoKitNode {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let image = self.image()
        let temp_size:CGSize = image?.size ?? CGSize.zero
        return temp_size
    }
    
    
    public func image(url: URL?, placeholder: String?) {
        if url == nil {
            guard let image = placeholder != nil ? UIImage(named: placeholder!) : nil else {
                return
            }
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:UIImageView.image), image)
            return
        }
        ArgoKitInstance.imageLoader()?.loadImage(url: url, placeHolder: placeholder) { image in
            if let img = image {
                ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:UIImageView.image), img)
            }
        } failure: {
            // 图像加载失败
        }
    }
    
    
    override func prepareForUse() {
        if let imageView = self.view as? UIImageView {
            imageView.image = nil
        }
    }
    
}

/// Wrapper of UIImageView
/// A view that displays a single image or a sequence of animated images in your interface.
public struct Image : View {
    
    private var pNode : ArgoKitImageNode
    
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
    public init(_ name: String) {
        let image: UIImage? =  UIImage(named: name, in: nil, compatibleWith: nil)
        self.init(image: image, highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(url: URL?, placeholder: String?) {
        self.init(image: nil, highlightedImage: nil)
        pNode.image(url: url, placeholder: placeholder)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    public init(urlString: String?, placeholder: String?) {
        self.init(image: nil, highlightedImage: nil)
        var url:URL? = nil
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        pNode.image(url: url, placeholder: placeholder)
    }
    
    /// Initializer
    /// - Parameters:
    ///   - name: The name of the image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app’s main bundle.
    public init(_ name: String, bundle: Bundle) {
        let image: UIImage? =  UIImage(named: name, in: bundle, compatibleWith: nil)
        self.init(image: image, highlightedImage: nil)
    }
    
    /// Initializer
    /// - Parameter name: The name of the system symbol image. Use the SF Symbols app to look up the names of system symbol images. You can download this app from the design resources page at developer.apple.com.
    @available(iOS 13.0, *)
    public init(systemName name: String) {
        self.init(image: UIImage(systemName: name), highlightedImage: nil)
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
    public init(image: UIImage?, highlightedImage: UIImage? = nil) {
        pNode = ArgoKitImageNode(viewClass: UIImageView.self)
        if let img = image {
            addAttribute(#selector(setter:UIImageView.image),img)
        }
        if let hightImg = highlightedImage{
            addAttribute(#selector(setter:UIImageView.highlightedImage),hightImg)
        }
    }
}

extension Image {
    
    /// Resizable image.
    /// - Parameters:
    ///   - capInsets: The values to use for the cap insets.
    ///   - resizingMode: The mode with which the interior of the image is resized.
    /// - Returns: Self
    @discardableResult
    public func resizable(capInsets: UIEdgeInsets = UIEdgeInsets(), resizingMode: UIImage.ResizingMode = .stretch) -> Self {
        if let image = pNode.image() {
            return self.image(image.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode))
        }
        return self
    }
    
    /// Adjust the rendering mode of the image.
    /// - Parameter renderingMode: The rendering mode to use for the new image.
    /// - Returns: Self
    @discardableResult
    public func renderingMode(_ renderingMode: UIImage.RenderingMode = .automatic) -> Self {
        if let image = pNode.image() {
            return self.image(image.withRenderingMode(renderingMode))
        }
        return self
    }
}

extension Image {
    
    /// Sets the displayed image.
    /// - Parameter value: The image displayed in the image view.
    /// - Returns: Self
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.image),value)
        return self
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - value: The image displayed in the image view.
    ///   - placeholder: The placeholder image displayed in the image view if the value invalid
    /// - Returns: Self
    @discardableResult
    public func image(_ value: UIImage?, placeholder: UIImage?) -> Self {
        return self.image(value ?? placeholder)
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - url: The url of a image.
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: Self
    @discardableResult
    public func image(url: URL?, placeholder: String?) -> Self {
        pNode.image(url: url, placeholder: placeholder)
        return self
    }
    
    /// Sets the displayed image.
    /// - Parameters:
    ///   - urlString: The string represent a valid URL For a image
    ///   - placeholder: The name of the placeholder image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG image files, specify the filename without the filename extension. For all other image file formats, include the filename extension in the name.
    /// - Returns: Self
    @discardableResult
    public func image(urlString: String?, placeholder: String?) -> Self {
        var url:URL? = nil
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        pNode.image(url: url, placeholder: placeholder)
        return self
    }
    
    /// Sets the highlighted image displayed in the image view.
    /// - Parameter value: The highlighted image displayed in the image view.
    /// - Returns: Self
    @discardableResult
    public func highlightedImage(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.highlightedImage),value)
        return self
    }
    
    /// Sets the configuration values to use when rendering the image.
    /// - Parameter value: The configuration values to use when rendering the image.
    /// - Returns: Self
    @available(iOS 13.0, *)
    @discardableResult
    public func preferredSymbolConfiguration(_ value: UIImage.SymbolConfiguration?) -> Self {
        addAttribute(#selector(setter:UIImageView.preferredSymbolConfiguration),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Parameter value: A Boolean value that determines whether user events are ignored and removed from the event queue.
    /// - Returns: Self
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isUserInteractionEnabled),value)
        return self
    }
    
    /// Sets a Boolean value that determines whether the image is highlighted.
    /// - Parameter value: A Boolean value that determines whether the image is highlighted.
    /// - Returns: Self
    @discardableResult
    public func isHighlighted(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isHighlighted),value)
        return self
    }
    
    /// Sets an array of UIImage objects to use for an animation.
    /// - Parameter value: An array of UIImage objects to use for an animation.
    /// - Returns: Self
    @discardableResult
    public func animationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.animationImages),value)
        return self
    }
    
    /// Sets an array of UIImage objects to use for an animation when the view is highlighted.
    /// - Parameter value: An array of UIImage objects to use for an animation when the view is highlighted.
    /// - Returns: Self
    @discardableResult
    public func highlightedAnimationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.highlightedAnimationImages),value)
        return self
    }
    
    /// Sets the amount of time it takes to go through one cycle of the images.
    /// - Parameter value: The amount of time it takes to go through one cycle of the images.
    /// - Returns: Self
    @discardableResult
    public func animationDuration(_ value: TimeInterval) -> Self {
        addAttribute(#selector(setter:UIImageView.animationDuration),value)
        return self
    }
    
    
    /// Specifies the number of times to repeat the animation.
    /// - Parameter value: the number of times to repeat the animation.
    /// - Returns: Self
    @discardableResult
    public func animationRepeatCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UIImageView.animationRepeatCount),value)
        return self
    }
    
    /// Sets a color used to tint template images in the view hierarchy.
    /// - Parameter value: A color used to tint template images in the view hierarchy.
    /// - Returns: Self
    @discardableResult
    public func tintColor(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIImageView.tintColor),value)
        return self
    }
    
    /// Starts animating the images in the receiver.
    /// - Returns: Self
    @discardableResult
    public func startAnimating() -> Self {
        addAttribute(#selector(UIImageView.startAnimating))
        return self
    }
    
    /// Stops animating the images in the receiver.
    /// - Returns: Self
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
