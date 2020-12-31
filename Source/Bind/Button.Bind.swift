//
//  Button.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/30.
//

import Foundation

extension Button {
    
    /// Sets the color of the text.
    /// - Parameters:
    ///   - r: The red value of the color object. 0~255
    ///   - g: The green value of the color object. 0~255
    ///   - b: The blue value of the color object. 0~255
    ///   - a: The opacity value of the color object. 0.0~1.0
    /// - Returns: self
    @discardableResult
    public func textColor(red r: Int,green g: Int,blue b: Int,alpha a: CGFloat = 1) -> Self {
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        return self.textColor(value)
    }
    
    /// Sets the color of the text.
    /// - Parameters:
    ///   - hex: The hex value of the color object
    ///   - a: The opacity value of the color object. 0.0~1.0
    /// - Returns: self
    @discardableResult
    public func textColor(hex: Int, alpha a: Float = 1) -> Self {
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        return self.textColor(value)
    }
    
    /// Sets the background image to use for the specified button state.
    /// - Parameters:
    ///   - image: The background image to use for the specified state.
    ///   - state: The state that uses the specified image. The values are described in UIControl.State.
    /// - Returns: self
    @discardableResult
    public func backgroundImage(image: UIImage?, for state: UIControl.State) -> Self {
        addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
        return self
    }
    
    
    /// Sets the background image to use for the specified button state.
    /// - Parameters:
    ///   - name: The name of the image asset or file. For images in asset catalogs, specify the name of the image asset. For PNG images, you may omit the filename extension. For all other file formats, always include the filename extension.
    ///   - state: The state that uses the specified image. The values are described in UIControl.State.
    /// - Returns: self
    @discardableResult
    public func backgroundImage(named name: String?, for state: UIControl.State) -> Self {
        if let p =  name {
            if let image =  UIImage(named:p) {
                addAttribute(#selector(UIButton.setBackgroundImage(_:for:)),image,state.rawValue)
            }
        }
        return self
    }
}
