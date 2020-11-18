//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
class ArgoKitTextNode: ArgoKitNode {
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

            lable.numberOfLines = self.numberOfLines()
            lable.font = self.font()
            lable.numberOfLines = self.numberOfLines()
            lable.lineBreakMode = self.lineBreakMode()
            result = lable.sizeThatFits(size)
        }
        let lineHeight:Float = Float(self.font()?.lineHeight ?? 0)
        if lineSpacing > 0 && floor(result.height) <= CGFloat(ceilf(lineHeight)) + lineSpacing {
            let oldLineSpacing = lineSpacing;
            lineSpacing = 0
            cleanLineSpacing()
            lineSpacing = oldLineSpacing;
            result.height -= lineSpacing;
        }
        result.width = ceil(result.width)
        result.height = ceil(result.height)
        return result
    }
}
public class Text:View {
    private var fontSize:CGFloat
    private var fontStyle:AKFontStyle
    private var font:UIFont
    private var fontName:String?
    private let pNode:ArgoKitTextNode
    public var node: ArgoKitNode?{
        pNode
    }

    public init() {
        fontStyle = .default
        fontSize = UIFont.systemFontSize
        font = UIFont.systemFont(ofSize:fontSize)
        pNode = ArgoKitTextNode(viewClass:UILabel.self)
        
    }
    public convenience init(_ text:String?) {
        self.init()
        addAttribute(#selector(setter:UILabel.text),text)
    }
}

extension Text{
    public func text(_ value:String?)->Self{
        addAttribute(#selector(setter:UILabel.text),value)
        pNode.handleLineSpacing()
        return self
    }
    public func font(_ value:UIFont!)->Self{
        addAttribute(#selector(setter:UILabel.font),value)
        pNode.handleLineSpacing()
        return self
    }
    
    public func font(fontName: String? = nil, fontStyle:AKFontStyle = .default,fontSize:CGFloat = UIFont.systemFontSize)->Self{
        let font = UIFont.font(fontName: fontName, fontStyle: fontStyle, fontSize: fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    public func fontName(_ value:String?)->Self{
        fontName = value
        let font = UIFont.font(fontName: value, fontStyle: fontStyle, fontSize: fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    public func fontSize(_ value:CGFloat)->Self{
        fontSize = value
        let font = UIFont.font(fontName: nil, fontStyle: fontStyle, fontSize: value)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    public func fontStyle(_ value:AKFontStyle)->Self{
        let font = UIFont.font(fontName: nil, fontStyle: value, fontSize: fontSize)
        addAttribute(#selector(setter:UILabel.font),font)
        pNode.handleLineSpacing()
        return self
    }
    
    public func textColor(_ value:UIColor!)->Self{
        addAttribute(#selector(setter:UILabel.textColor),value)
        pNode.handleLineSpacing()
        return self
    }
    public func shadowColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UILabel.shadowColor),value)
        return self
    }
    public func shadowOffset(_ value:CGSize)->Self{
        addAttribute(#selector(setter:UILabel.shadowOffset),value)
        return self
    }
    public func textAlign(_ value:NSTextAlignment)->Self{
        addAttribute(#selector(setter:UILabel.textAlignment),value.rawValue)
        pNode.handleLineSpacing()
        return self
    }
    public func breakMode(_ value:NSLineBreakMode)->Self{
        addAttribute(#selector(setter:UILabel.lineBreakMode),value.rawValue)
        
        return self
    }
    
    public func attributedText(_ value:NSAttributedString?)->Self{
        pNode.attributedText(attri: value)
        return self
    }
    
    public func highlightedTextColor(_ value:UIColor?)->Self{
        addAttribute(#selector(setter:UILabel.highlightedTextColor),value)
        return self
    }
    
    public func isHighlighted(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isHighlighted),value)
        return self
    }
    
    
    public func userInteractionEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isUserInteractionEnabled),value)
        return self
    }
    public func isEnabled(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.isEnabled),value)
        return self
    }
    
    public func lineLimit(_ value:Int)->Self{
        addAttribute(#selector(setter:UILabel.numberOfLines),value)
        return self
    }
    public func LineSpacing(_ value:CGFloat)->Self{
        pNode.lineSpacing(value)
        return self
    }

    public func adjustsFontSizeToFitWidth(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.adjustsFontSizeToFitWidth),value)
        return self
    }
    
    // default is UIBaselineAdjustmentAlignBaselines
    public func baselineAdjustment(_ value:UIBaselineAdjustment)->Self{
        addAttribute(#selector(setter:UILabel.baselineAdjustment),value)
        return self
    }


    @available(iOS 6.0, *)
    public func minimumScaleFactor(_ value:CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.minimumScaleFactor),value)
        return self
    }

    
    // Tightens inter-character spacing in attempt to fit lines wider than the available space if the line break mode is one of the truncation modes before starting to truncate.
    // The maximum amount of tightening performed is determined by the system based on contexts such as font, line width, etc.
    @available(iOS 9.0, *)
    public func allowsDefaultTighteningForTruncation(_ value:Bool)->Self{
        addAttribute(#selector(setter:UILabel.allowsDefaultTighteningForTruncation),value)
        return self
    }

    
    // Specifies the line break strategies that may be used for laying out the text in this// label.
    // If this property is not set, the default value is NSLineBreakStrategyStandard.
    // If the label contains an attributed text with paragraph style(s) that specify a set of line break strategies, the set of strategies in the paragraph style(s) will be used instead of the set of strategies defined by this property.
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

    public func drawText(in rect: CGRect)->Self{
        addAttribute(#selector(UILabel.drawText(in:)),[rect])
        return self
    }

    // Support for constraint-based layout (auto layout)
    // If nonzero, this is used when determining -intrinsicContentSize for multiline labels
    @available(iOS 6.0, *)
    public func preferredMaxLayoutWidth(in value: CGFloat)->Self{
        addAttribute(#selector(setter:UILabel.preferredMaxLayoutWidth),value)
        return self
    }
    
    public func shadow(shadowColor:UIColor, shadowOffset:CGSize,shadowRadius:CGFloat = 0,shadowOpacity:CGFloat = 0)->Self{
        addAttribute(#selector(setter:UILabel.shadowColor),shadowColor)
        addAttribute(#selector(setter:UILabel.shadowOffset),shadowOffset)
        return self;
    }
    
}
