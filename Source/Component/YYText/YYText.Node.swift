//
//  YYText.swift
//  ArgoKitComponent
//
//  Created by Bruce on 2021/1/22.
//

import Foundation
import ArgoKit
import YYText
struct YYTextCalculation {
    static let yycalculationLable:YYLabel = YYLabel()
}
class YYTextNode: ArgoKitTextBaseNode{
    var textTapAction:YYTextAction?
    var textLongAction:YYTextAction?
    override func clearStrongRefrence() {
        textTapAction = nil
        textLongAction = nil
    }
    override func createNodeViewIfNeed(_ frame: CGRect) {
        super.createNodeViewIfNeed(frame)
        if let view = self.link?.view as? YYLabel {
            view.textTapAction = textTapAction
            view.textLongPressAction = textLongAction
        }else if let view = self.view as? YYLabel{
            view.textTapAction = textTapAction
            view.textLongPressAction = textLongAction
        }
    }
    override  func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable = YYTextCalculation.yycalculationLable
        lable.textLayout = nil
        lable.font = font
        lable.attributedText = self.attributedText
        lable.numberOfLines = UInt(self.numberOfLines)
        return lable.sizeThatFits(size)
    }
    override func setText(_ value:String?){
        if let text = value {
            setAttributedText(attri: NSAttributedString(string: text))
        }
    }
    override func setAttributedText(attri:NSAttributedString?){
        if let attributText = attri {
            attributedText = NSMutableAttributedString(attributedString: attributText)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
        }
    }
    
    override func font(_ value:UIFont, range: NSRange? = nil){
        self.font = value
        if let range = range {
            attributedText?.yy_setFont(value, range: range)
        }else{
            attributedText?.yy_font = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    override func lineSpacing(_ value: CGFloat) {
        self.lineSpacing = value
        attributedText?.yy_lineSpacing = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func kern(_ value:NSNumber?, range: NSRange? = nil) {
        if let range = range {
            attributedText?.yy_setKern(value, range: range)
        }else{
            attributedText?.yy_kern = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    override func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setAlignment(value, range: range)
        }else{
            attributedText?.yy_alignment = value
        }
        
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    override func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setLineBreakMode(value, range: range)
        }else{
            attributedText?.yy_lineBreakMode = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func textColor(_ value:UIColor?, range: NSRange? = nil) {
        if let range = range {
            attributedText?.yy_setColor(value, range: range)
        }else{
            attributedText?.yy_color = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func backgroundColor(_ value:UIColor?, range: NSRange? = nil)  {
        if let range = range {
            attributedText?.yy_setBackgroundColor(value, range: range)
        }else{
            attributedText?.yy_backgroundColor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func stroke(width:NSNumber?,color:UIColor?, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setStrokeWidth(width, range: range)
            attributedText?.yy_setStroke(color, range: range)
        }else{
            attributedText?.yy_strokeWidth = width
            attributedText?.yy_strokeColor = color
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    func strikethrough(style:YYTextLineStyle,
                       width:NSNumber?,
                       color:UIColor?,
                       range:NSRange?){
        let textDecoration = YYTextDecoration(style: style,width: width,color: color)
        if let range = range {
            attributedText?.yy_setTextStrikethrough(textDecoration, range:range)
        }else{
            attributedText?.yy_textStrikethrough = textDecoration
        }
        if let attibuteText = self.attributedText {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    
    func underline(style:YYTextLineStyle,
                   width:NSNumber?,
                   color:UIColor?,
                   range: NSRange? = nil){
        let textDecoration = YYTextDecoration(style: style,width: width,color: color)
        if let range = range {
            attributedText?.yy_setTextUnderline(textDecoration, range: range)
        }else{
            attributedText?.yy_textUnderline = textDecoration
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func textBorder(_ value:YYTextBorder,range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setTextBorder(value, range: range)
        }else{
            attributedText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func textBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil){
        let value = YYTextBorder(lineStyle: style, lineWidth: width, stroke: color)
        value.cornerRadius = cornerRadius
        if let range = range {
            attributedText?.yy_setTextBorder(value, range: range)
        }else{
            attributedText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    
    func textBackgroundBorder(_ value:YYTextBorder,range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setTextBackgroundBorder(value, range: range)
        }else{
            attributedText?.yy_textBackgroundBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func textBackgroundBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil){
        let value = YYTextBorder(lineStyle: style, lineWidth: width, stroke: color)
        value.cornerRadius = cornerRadius
        if let range = range {
            attributedText?.yy_setTextBorder(value, range: range)
        }else{
            attributedText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    
    override func shadow(_ value:NSShadow,range: NSRange? = nil){
        shadow = value
        if let range = range {
            attributedText?.yy_setShadow(shadow, range: range)
        }else{
            attributedText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    override func shadow(color:UIColor,offset:CGSize,blurRadius:CGFloat,range: NSRange? = nil){
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        if let range = range {
            attributedText?.yy_setShadow(shadow, range: range)
        }else{
            attributedText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    override func shadowColor(_ value:UIColor,range: NSRange? = nil){
        shadow.shadowColor = value
        if let range = range {
            attributedText?.yy_setShadow(shadow, range: range)
        }else{
            attributedText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    override func shadowOffset(_ value:CGSize,range: NSRange? = nil){
        shadow.shadowOffset = value
        if let range = range {
            attributedText?.yy_setShadow(shadow, range: range)
        }else{
            attributedText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    override func shadowBlurRadius(_ value:CGFloat,range: NSRange? = nil){
        shadow.shadowBlurRadius = value
        if let range = range {
            attributedText?.yy_setShadow(shadow, range: range)
        }else{
            attributedText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func textEffect(_ value:String?, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setTextEffect(value, range: range)
        }else{
            attributedText?.yy_textEffect = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)

    }
    func obliqueness(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setObliqueness(value, range: range)
        }else{
            attributedText?.yy_obliqueness = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)

    }
    
    func expansion(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setExpansion(value, range: range)
        }else{
            attributedText?.yy_expansion = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)

    }

    func baselineOffset(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setBaselineOffset(value, range: range)
        }else{
            attributedText?.yy_baselineOffset = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func setTextHighlightRange(_ range:NSRange?,color:UIColor?,backgroundColor:UIColor?,
                               userInfo:Dictionary<String, Any>?,
                               tapAction: ((NSAttributedString, NSRange)->())?,
                               longPressAction:((NSAttributedString, NSRange)->())?){
        var innerRange = NSRange(location: 0, length: attributedText?.length ?? 0)
        if let range =  range{
            innerRange = range
        }
        attributedText?.yy_setTextHighlight(innerRange, color: color, backgroundColor: backgroundColor, userInfo: userInfo, tapAction: { (view, attributedString, range, rect) in
            if let action = tapAction{
                action(attributedString,range)
            }
        }, longPressAction:{ (view, attributedString, range, rect) in
            if let action = longPressAction{
                action(attributedString,range)
            }
        })
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func baseWritingDirection(_ value:NSWritingDirection, range: NSRange? = nil) {
        if let range = range {
            attributedText?.yy_setBaseWritingDirection(value, range: range)
        }else{
            attributedText?.yy_baseWritingDirection = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }
    

    func paragraphSpacing(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setParagraphSpacing(value, range: range)
        }else{
            attributedText?.yy_paragraphSpacing = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    
    func paragraphSpacingBefore(_ value: CGFloat, range: NSRange? = nil){
        attributedText?.yy_paragraphSpacingBefore = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    
    func firstLineHeadIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setFirstLineHeadIndent(value, range: range)
        }else{
            attributedText?.yy_firstLineHeadIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }


    func headIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setHeadIndent(value, range: range)
        }else{
            attributedText?.yy_headIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    
    func tailIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setTailIndent(value, range: range)
        }else{
            attributedText?.yy_tailIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    
    func minimumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setMinimumLineHeight(value, range: range)
        }else{
            attributedText?.yy_minimumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    func maximumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setMaximumLineHeight(value, range: range)
        }else{
            attributedText?.yy_maximumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    
    func lineHeightMultiple(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setLineHeightMultiple(value, range: range)
        }else{
            attributedText?.yy_lineHeightMultiple = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }

    func hyphenationFactor(_ value: Float, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setHyphenationFactor(value, range: range)
        }else{
            attributedText?.yy_hyphenationFactor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }


    func defaultTabInterval(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attributedText?.yy_setDefaultTabInterval(value, range: range)
        }else{
            attributedText?.yy_defaultTabInterval = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }
    
    func setLink(_ link:Any?,range:NSRange? = nil){
        var innerRange = NSRange(location: 0, length: self.attributedText?.length ?? 0)
        if let range = range {
            innerRange = range
        }
        attributedText?.yy_setLink(link, range: innerRange)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }
    
    func setLink(range:NSRange?,
                 color:UIColor?,
                 backgroundColor:UIColor?,
                 userInfo:Dictionary<String, Any>?,
                tapAction:@escaping (String)->()){
        var innerRange = NSRange(location: 0, length: attributedText?.length ?? 0)
        if let range =  range{
            innerRange = range
        }
        attributedText?.yy_setTextHighlight(innerRange, color: color, backgroundColor: backgroundColor, userInfo: userInfo, tapAction: { (view, attributedString, rang, rect) in
            let substring = attributedString.attributedSubstring(from: rang).string
            tapAction(substring)
        }, longPressAction:nil)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attributedText)
    }
    
    func attachmentStringWithImage(_ image:UIImage?,
                                               fontSize:CGFloat,
                                               location:Int){
        if let image = image{
            let imageAttributeText = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: fontSize)
            if let lenght = self.attributedText?.length,let imageAttributeText = imageAttributeText {
                if location >= lenght {
                    self.attributedText?.append(imageAttributeText)
                }
                if location < lenght {
                    self.attributedText?.insert(imageAttributeText, at: location)
                }
            }
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
        }
    }
    
    func tabStops(_ tabs:[NSTextTab],range:NSRange? = nil){
        if let range = range {
            attributedText?.yy_setTabStops(tabs, range: range)
        }else{
            attributedText?.yy_tabStops = tabs
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attributedText)
    }
}
