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
    
    public func image(url: String, placeholder: String?, loader: Image.Loader) {
        
        loader(url, placeholder) {[weak self ] (result, retImage) in
            if result, let img = retImage {
                ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:UIImageView.image), img)
            }
        }
    }
    
    override func prepareForUse() {
        if let imageView = self.view as? UIImageView {
            imageView.image = nil
        }
    }
    
}

extension Image {
    
    public typealias Loader = (_ url:String, _ placeholder:String?, _ completion: @escaping (Bool, UIImage?) -> Void) -> Void
}

open class Image : View {
    
    private var pNode : ArgoKitImageNode
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public convenience init() {
        self.init(image: nil, highlightedImage: nil)
    }
    
    public convenience init(_ name: String) {
        let image: UIImage? =  UIImage(named: name, in: nil, compatibleWith: nil)
        self.init(image: image, highlightedImage: nil)
    }
    
    public convenience init(_ name: String, bundle: Bundle) {
        let image: UIImage? =  UIImage(named: name, in: bundle, compatibleWith: nil)
        self.init(image: image, highlightedImage: nil)
    }
    
    @available(iOS 13.0, *)
    public convenience init(systemName: String) {
        self.init(image: UIImage(systemName: systemName), highlightedImage: nil)
    }
    
    public convenience init(_ cgImage: CGImage, scale: CGFloat, orientation: UIImage.Orientation = .up) {
        self.init(image: UIImage(cgImage: cgImage, scale: scale, orientation: orientation), highlightedImage: nil)
    }
    
    public convenience init(url: String, placeholder: String?, loader: @escaping Image.Loader) {
        var image: UIImage?
        if placeholder != nil {
            image = UIImage(named: placeholder!, in: nil, compatibleWith: nil)
        }
        self.init(image: image, highlightedImage: nil)
        pNode.image(url: url, placeholder: placeholder, loader: loader)
    }
    
    required public init(image: UIImage?, highlightedImage: UIImage? = nil) {
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
    
    public func resizable(capInsets: UIEdgeInsets = UIEdgeInsets(), resizingMode: UIImage.ResizingMode = .stretch) -> Self {
        if let image = pNode.image() {
            return self.image(image.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode))
        }
        return self
    }
    
    public func renderingMode(_ renderingMode: UIImage.RenderingMode = .automatic) -> Self {
        if let image = pNode.image() {
            return self.image(image.withRenderingMode(renderingMode))
        }
        return self
    }
}

extension Image {
    
    public func image(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.image),value)
        return self
    }
    
    public func image(_ value: UIImage?, placeholder: UIImage?) -> Self {
        return self.image(value ?? placeholder)
    }
    
    public func image(name: String?, placeholder: String?) -> Self {
        let imageName: String? = name ?? placeholder
        let image: UIImage? = (imageName != nil) ? UIImage(named: imageName!, in: nil, compatibleWith: nil) : nil
        return self.image(image)
    }
    
    public func image(url: String, placeholder: String?, loader: @escaping Image.Loader) -> Self {
        if placeholder != nil, let image = UIImage(named: placeholder!, in: nil, compatibleWith: nil) {
            addAttribute(#selector(setter:UIImageView.image), image)
        }
        pNode.image(url: url, placeholder: placeholder, loader: loader)
        return self
    }
    
    public func highlightedImage(_ value: UIImage?) -> Self {
        addAttribute(#selector(setter:UIImageView.image),value)
        return self
    }
    
    @available(iOS 13.0, *)
    public func preferredSymbolConfiguration(_ value: UIImage.SymbolConfiguration?) -> Self {
        addAttribute(#selector(setter:UIImageView.preferredSymbolConfiguration),value)
        return self
    }
    
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isUserInteractionEnabled),value)
        return self
    }
    
    public func isHighlighted(_ value: Bool) -> Self {
        addAttribute(#selector(setter:UIImageView.isHighlighted),value)
        return self
    }
    
    public func animationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.animationImages),value)
        return self
    }
    
    public func highlightedAnimationImages(_ value: [UIImage]?) -> Self {
        addAttribute(#selector(setter:UIImageView.highlightedAnimationImages),value)
        return self
    }
    
    public func animationDuration(_ value: TimeInterval) -> Self {
        addAttribute(#selector(setter:UIImageView.animationDuration),value)
        return self
    }
    
    public func animationRepeatCount(_ value: Int) -> Self {
        addAttribute(#selector(setter:UIImageView.animationRepeatCount),value)
        return self
    }
    
    public func tintColor(_ value: UIColor!) -> Self {
        addAttribute(#selector(setter:UIImageView.tintColor),value)
        return self
    }
    
    public func startAnimating() -> Self {
        addAttribute(#selector(UIImageView.startAnimating))
        return self
    }
    
    public func stopAnimating() -> Self {
        addAttribute(#selector(UIImageView.stopAnimating))
        return self
    }
}

extension Image {
    public func imageSize() -> CGSize {
        return pNode.image()?.size ?? .zero
    }
}
