//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
class ArgoKitTextNode: ArgoKitArttibuteNode {
    
    var lineSpacing:CGFloat = 0
    
    func lineSpacing(_ value:CGFloat){
        self.lineSpacing = value
        self.handleLineSpacing()
    }
    
    func handleLineSpacing() {
        if self.lineSpacing == 0 {
            return
        }
        let lableText:String = self.text() ?? ""
        if lableText.count == 0 {
            return
        }
        
        let range:NSRange = NSRange(location: 0, length: lableText.count)
        let attributedString = NSMutableAttributedString(string: lableText)
        if let font:UIFont = self.font(){
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        if let textColor:UIColor = self.textColor() {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        }
        attributedText(attri: attributedString)
    }
    
    func attributedText(attri:NSAttributedString?) {
        if let attriText = attri {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            if self.lineSpacing == 0 {
                paragraphStyle.lineSpacing = 2
            }else{
                paragraphStyle.lineSpacing = self.lineSpacing
            }
            paragraphStyle.lineBreakMode = self.lineBreakMode()
            paragraphStyle.alignment = self.textAlignment()
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
        }
    }
    
    
    func cleanLineSpacing() {
        if let attriText = self.attributedText() {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.lineBreakMode = self.lineBreakMode()
            paragraphStyle.alignment = self.textAlignment()
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var result:CGSize = size
        if let view = self.view {
            result = view.sizeThatFits(size)
        }else{
            let lable:UILabel = UILabel()
            if let text =  self.text(){
                if text.count > 0 {
                    lable.text = text
                }
            }
            if let attribut =  self.attributedText(){
                if attribut.length > 0 {
                    lable.attributedText = attribut
                }
            }

            if let font = self.font() {
                lable.font = font
            }
            
            lable.numberOfLines = self.numberOfLines()
            lable.lineBreakMode = self.lineBreakMode()
            result = lable.sizeThatFits(size)
        }
        
        return result
    }
}

public struct Text:View {
    private let pNode:ArgoKitTextNode
    public var node: ArgoKitNode?{
        pNode
    }

    public init() {
        pNode = ArgoKitTextNode(viewClass:UILabel.self)
        pNode.alignSelfFlexStart()
    }
    public init(_ text:String?) {
        self.init()
        addAttribute(#selector(setter:UILabel.text),text)
    }
}

extension Text{
    @discardableResult
    public func text(_ value:String?)->Self{
        addAttribute(#selector(setter:UILabel.text),value)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func font(_ value:UIFont!)->Self{
        addAttribute(#selector(setter:UILabel.font),value)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func font(name: String?, style:AKFontStyle,size:CGFloat)->Self{
        pNode.fontName = name
        pNode.fontSize = size
        pNode.fontStyle = style
        let font = UIFont.font(fontName: name, fontStyle: style, fontSize: size)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func font(name value:String?)->Self{
        pNode.fontName = value
        let font = UIFont.font(fontName: value, fontStyle: pNode.fontStyle, fontSize: pNode.fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public  func font(size value:CGFloat)->Self{
        pNode.fontSize = value
        let font = UIFont.font(fontName: pNode.fontName, fontStyle:  pNode.fontStyle, fontSize: value)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func font(style value:AKFontStyle)->Self{
        pNode.fontStyle = value
        let font = UIFont.font(fontName: pNode.fontName, fontStyle: value, fontSize: pNode.fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func textColor(_ value:UIColor!)->Self{
        addAttribute(#selector(setter:UILabel.textColor),value)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func textColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UILabel.textColor),value)
        return self;
    }
    
    @discardableResult
    public func textColor(hex:Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UILabel.textColor),value)
        return self;
    }
    
    @discardableResult
    public func textAlign(_ value:NSTextAlignment)->Self{
        addAttribute(#selector(setter:UILabel.textAlignment),value.rawValue)
        pNode.handleLineSpacing()
        return self
    }
    
    @discardableResult
    public func textShadowOffset(_ value:CGSize)->Self{
        addAttribute(#selector(setter:UILabel.shadowOffset),value)
        return self
    }
    
    @discardableResult
    public func textShadowColor(_ value:UIColor)->Self{
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self
    }
    
    @discardableResult
    public func textShadowColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        let value = UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self;
    }
    
    @discardableResult
    public func textShadowColor(hex :Int,alpha a:Float = 1)->Self{
        let value = ArgoKitUtils.color(withHex: hex,alpha:a)
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self;
    }
    
    @discardableResult
    public func breakMode(_ value:NSLineBreakMode)->Self{
        addAttribute(#selector(setter:UILabel.lineBreakMode),value.rawValue)
        
        return self
    }
    
    @discardableResult
    public func attributedText(_ value:NSAttributedString?)->Self{
        pNode.attributedText(attri: value)
        return self
    }
    
    @discardableResult
    public func highlightedTextColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UILabel.highlightedTextColor),value)
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isHighlighted),value)
        return self
    }
    
    
    @discardableResult
    public func userInteractionEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isUserInteractionEnabled),value)
        return self
    }
    public func isEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isEnabled),value)
        return self
    }
    
    @discardableResult
    public func lineLimit(_ value:Int)->Self{
        addAttribute(#selector(setter:UILabel.numberOfLines),value)
        return self
    }
    
    @discardableResult
    public func lineSpacing(_ value:CGFloat)->Self{
        pNode.lineSpacing(value)
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    // default is UIBaselineAdjustmentAlignBaselines
    @discardableResult
    public func baselineAdjustment(_ value:UIBaselineAdjustment)->Self{
        addAttribute(#selector(setter:UILabel.baselineAdjustment),value)
        return self
    }


    @available(iOS 6.0, *)
    @discardableResult
    public func minimumScaleFactor(_ value:CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.minimumScaleFactor),value)
        return self
    }

    
    // Tightens inter-character spacing in attempt to fit lines wider than the available space if the line break mode is one of the truncation modes before starting to truncate.
    // The maximum amount of tightening performed is determined by the system based on contexts such as font, line width, etc.
    @available(iOS 9.0, *)
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value)
        return self
    }

    
    // Specifies the line break strategies that may be used for laying out the text in this// label.
    // If this property is not set, the default value is NSLineBreakStrategyStandard.
    // If the label contains an attributed text with paragraph style(s) that specify a set of line break strategies, the set of strategies in the paragraph style(s) will be used instead of the set of strategies defined by this property.
    
    @discardableResult
    public func lineBreakStrategy(_ value:NSParagraphStyle.LineBreakStrategy)->Self{
        addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value)
        return self
    }

    // override points. can adjust rect before calling super.
    // label has default content mode of UIViewContentModeRedraw
    public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect{
        if let label = self.node?.view as? UILabel {
            return label.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines);
        }
        return CGRect.zero
    }
    
    @discardableResult
    public func drawText(in rect: CGRect)->Self{
        addAttribute(#selector(UILabel.drawText(in:)),[rect])
        return self
    }

    // Support for constraint-based layout (auto layout)
    // If nonzero, this is used when determining -intrinsicContentSize for multiline labels
    @available(iOS 6.0, *)
    @discardableResult
    public func preferredMaxLayoutWidth(in value: CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.preferredMaxLayoutWidth),value)
        return self
    }
    
}


extension Text{
    @available(*, deprecated, message: "Text does not support padding!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Text does not support padding!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self
    }
}
