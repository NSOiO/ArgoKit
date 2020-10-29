//
//  ImageView.swift
//  ArgoKit
//
//  Created by MOMO on 2020/10/26.
//

import Foundation

public struct ImageView : View {
    
    private var imageView : UIImageView
    private var pNode : ArgoKitNode
    
    public var body: View {
        self
    }
    
    public var type: ArgoKitNodeType {
        .single(pNode)
    }
    
    public var node: ArgoKitNode? {
        pNode
    }
    
    public init() {
        self.init(image: nil, highlightedImage: nil)
    }
    
    public init(_ name: String?, bundle: Bundle? = nil) {
        let image: UIImage? = (name != nil) ? UIImage(named: name!, in: bundle, compatibleWith: nil) : nil
        self.init(image: image, highlightedImage: nil)
    }
    
    public init(_ name: String?, bundle: Bundle? = nil, @ArgoKitViewBuilder builder:()->View) {
        let image: UIImage? = (name != nil) ? UIImage(named: name!, in: bundle, compatibleWith: nil) : nil
        self.init(image: image, highlightedImage: nil, builder: builder)
    }
    
    @available(iOS 13.0, *)
    public init(systemName: String) {
        self.init(image: UIImage(systemName: systemName), highlightedImage: nil)
    }
    
    public init(_ cgImage: CGImage, scale: CGFloat, orientation: UIImage.Orientation = .up) {
        self.init(image: UIImage(cgImage: cgImage, scale: scale, orientation: orientation), highlightedImage: nil)
    }
    
    public init(_ cgImage: CGImage, scale: CGFloat, orientation: UIImage.Orientation = .up, @ArgoKitViewBuilder builder:()->View) {
        self.init(image: UIImage(cgImage: cgImage, scale: scale, orientation: orientation), highlightedImage: nil, builder: builder)
    }
    
    public init(image: UIImage?, highlightedImage: UIImage? = nil, @ArgoKitViewBuilder builder:()->View) {
        self.init(image: image, highlightedImage: highlightedImage)
        addSubNodes(builder)
    }
    
    public init(image: UIImage?, highlightedImage: UIImage? = nil) {
        imageView = UIImageView(image: image, highlightedImage: highlightedImage);
        pNode = ArgoKitNode(view: imageView)
        self.node?.width(point: imageView.frame.width)
        self.node?.height(point: imageView.frame.height)
    }
}

extension ImageView {
    
    public func resizable(capInsets: UIEdgeInsets = UIEdgeInsets(), resizingMode: UIImage.ResizingMode = .stretch) -> Self {
        if let image = imageView.image {
            imageView.image = image.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode)
        }
        return self
    }
    
    public func renderingMode(_ renderingMode: UIImage.RenderingMode?) -> Self {
        if let image = imageView.image {
            imageView.image = image.withRenderingMode(renderingMode ?? .automatic)
        }
        return self
    }
}

extension ImageView {
    
    public func image(_ value: UIImage?) -> Self {
        imageView.image = value
        self.node?.width(point: value?.size.width ?? 0)
        self.node?.height(point: value?.size.height ?? 0)
        return self
    }
    
    public func highlightedImage(_ value: UIImage?) -> Self {
        imageView.highlightedImage = value
        return self
    }
    
    @available(iOS 13.0, *)
    public func preferredSymbolConfiguration(_ value: UIImage.SymbolConfiguration?) -> Self {
        imageView.preferredSymbolConfiguration = value
        return self
    }
    
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        imageView.isUserInteractionEnabled = value
        return self
    }
    
    public func isHighlighted(_ value: Bool) -> Self {
        imageView.isHighlighted = value
        return self
    }
    
    public func animationImages(_ value: [UIImage]?) -> Self {
        imageView.animationImages = value
        return self
    }
    
    public func highlightedAnimationImages(_ value: [UIImage]?) -> Self {
        imageView.highlightedAnimationImages = value
        return self
    }
    
    public func animationDuration(_ value: TimeInterval) -> Self {
        imageView.animationDuration = value
        return self
    }
    
    public func animationRepeatCount(_ value: Int) -> Self {
        imageView.animationRepeatCount = value
        return self
    }
    
    public func tintColor(_ value: UIColor!) -> Self {
        imageView.tintColor = value
        return self
    }
    
    public func startAnimating() -> Self {
        imageView.startAnimating()
        return self
    }
    
    public func stopAnimating() -> Self {
        imageView.stopAnimating()
        return self
    }
}
