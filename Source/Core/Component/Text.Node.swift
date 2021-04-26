//
//  Text.Protocol.swift
//  ArgoKit
//
//  Created by Dai on 2021-01-15.
//

import Foundation
extension NSMutableAttributedString{
    public func setParagraphStyle(range: NSRange,paragraphStyle:@escaping (NSMutableParagraphStyle?)->()){
       
        self.enumerateAttribute(NSAttributedString.Key.paragraphStyle, in: NSRange(location: 0, length: self.length ), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { [weak self]  (value, subRange, stop) in
            var style:NSMutableParagraphStyle? = nil
            if let value_ = value as? NSMutableParagraphStyle{
                style = value_
            }else if let value_ = value as? NSParagraphStyle,let style_ = value_.mutableCopy() as? NSMutableParagraphStyle{
                style = style_
            }else{
                let style_:NSParagraphStyle = NSParagraphStyle.default
                if let value_ = style_.mutableCopy() as? NSMutableParagraphStyle{
                    style = value_
                }
            }
            paragraphStyle(style)
            self?.addAttribute(NSAttributedString.Key.paragraphStyle, value: style!, range: subRange)
        })
    }
}
open class ArgoKitTextBaseNode: ArgoKitArttibuteNode{
    var textColor:UIColor?
    var firstHeadIndent:CGFloat = 0;
    open override func prepareForUse(view: UIView?) {
        super.prepareForUse(view: view)
        if let lable = view as? UILabel {
            lable.text = nil
            lable.attributedText = nil
        }
    }
    
    open func setAttributedText(attri:NSAttributedString?){
        if let attriText = attri {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            attributedText = attributedString
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    
    open func setText(_ value:String?){
        if let text = value {
            if let attributedText_ = attributedText {
                attributedText_.mutableString.setString(text)
                attributedText = attributedText_
            }else{
                setAttributedText(attri: NSAttributedString(string: text))
            }
            self._font_(self.font)
            self._textColor_(self.textColor)
            self._textAlignment_(self.textAlignment)
            self._lineSpacing_(self.lineSpacing)
            self._lineBreakMode_(self.lineBreakMode)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    
    open func font(_ value:UIFont?, range: NSRange? = nil){
        if _font_(value,range: range) {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    @discardableResult
    open func _font_(_ value:UIFont?, range: NSRange? = nil) -> Bool{
        guard let value = value else {
            return false
        }
        self.font = value
        
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return false
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.addAttribute(NSAttributedString.Key.font, value: value, range: innerRange)
        return false

    }
    open func textColor(_ value:UIColor?, range: NSRange? = nil) {
        if _textColor_(value,range: range) {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    @discardableResult
    open func _textColor_(_ value:UIColor?, range: NSRange? = nil) -> Bool{
        guard let value = value else {
            return false
        }
        self.textColor = value
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return false
        }
        
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: value, range: innerRange)
        attributedText.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: value, range: innerRange)
        return true
    }
    open func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        if _textAlignment_(value,range: range) {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    @discardableResult
    open func _textAlignment_(_ value:NSTextAlignment, range: NSRange? = nil)->Bool{
        self.textAlignment = value
        
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return false
        }
        
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.alignment = value
        }
        return true
        
    }
    
    open func lineSpacing(_ value:CGFloat,range: NSRange? = nil){
        if _lineSpacing_(value,range: range) {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    
    @discardableResult
    open func _lineSpacing_(_ value:CGFloat,range: NSRange? = nil) -> Bool{
        self.lineSpacing = value
        
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return false
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.lineSpacing = value
        }
        return true
    }
    
    open func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        self.lineBreakMode = value
        if _lineBreakMode_(value,range: range){
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
        }
    }
    
    @discardableResult
    private func _lineBreakMode_(_ value:NSLineBreakMode, range: NSRange? = nil) -> Bool{
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return false
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.lineBreakMode = value
        }
        return true
    }
        
    open func numberOfLines(_ value:Int){
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.numberOfLines),value)
        self.numberOfLines = value
    }
    
    open func setShadow(_ value:NSShadow?,range: NSRange? = nil){
        guard let value = value else {
            return
        }
        shadow = value
        
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.addAttribute(NSAttributedString.Key.shadow, value: value, range: innerRange)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedText)
    }
    open func setShadow(color:UIColor,offset:CGSize,blurRadius:CGFloat,range: NSRange? = nil){
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        setShadow(shadow,range: range)
    }
    
    open func shadowColor(_ value:UIColor,range: NSRange? = nil){
        shadow.shadowColor = value
        setShadow(shadow,range: range)
    }
    open func shadowOffset(_ value:CGSize,range: NSRange? = nil){
        shadow.shadowOffset = value
        setShadow(shadow,range: range)
    }
    open func shadowBlurRadius(_ value:CGFloat,range: NSRange? = nil){
        shadow.shadowBlurRadius = value
        setShadow(shadow,range: range)
    }
    
    open func kern(_ value:NSNumber?, range: NSRange? = nil) {
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.addAttribute(NSAttributedString.Key.kern, value: value as Any, range: innerRange)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }
    open func paragraphSpacing(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.paragraphSpacing = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }

    
    open func paragraphSpacingBefore(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.paragraphSpacingBefore = value
        }
       
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }

    
    open func firstLineHeadIndent(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        firstHeadIndent = value;
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.firstLineHeadIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }


    open func headIndent(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.headIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }

    
    open func tailIndent(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.tailIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }

    
    open func minimumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.minimumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }

    open func maximumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        guard let attributedText = attributedText,
              attributedText.length > 0 else {
            return
        }
        var innerRange = NSRange(location: 0, length: attributedText.length)
        if let range = range{
            innerRange = range
        }
        attributedText.setParagraphStyle(range: innerRange){ paragraphStyle in
            paragraphStyle?.maximumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),self.attributedText)
    }
    
    @discardableResult
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var result = size
        var maxHeight = size.height
        if let attribut = self.attributedText{
            var totolLineHeight:CGFloat = 0
            let lineHeight:CGFloat = ceil(font.lineHeight + font.leading)
            if numberOfLines > 0 {
                totolLineHeight = lineSpacing * CGFloat((numberOfLines - 1)) + lineHeight * CGFloat(numberOfLines)
                maxHeight = CGFloat.minimum(size.height, totolLineHeight)
            }
            self._lineBreakMode_(.byCharWrapping)
            let result_size = attribut.boundingRect(with: CGSize(width: size.width, height: maxHeight), options: [.usesLineFragmentOrigin], context: nil).size
            self._lineBreakMode_(self.lineBreakMode)
            var width = ceil(result_size.width);
            let height = ceil(result_size.height);
            if(height <= lineHeight){
                width = width + firstHeadIndent;
            }
            result = CGSize(width:width, height:height)
            return result
        }
        return result
    }
}

struct TextCalculation {
    static let calculationLable:UILabel = UILabel()
}

class ArgoKitTextNode: ArgoKitTextBaseNode {
    override func prepareForUse(view: UIView?) {
        super.prepareForUse(view: view)
        if let lable = view as? UILabel{
            lable.text = nil
            lable.attributedText = nil
        }
    }
    
    func cleanLineSpacing() {
        if let attriText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: attriText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.lineBreakMode = self.lineBreakMode
            paragraphStyle.alignment = self.textAlignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attriText.length))
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:UILabel.attributedText),attributedString)
        }
    }
}
