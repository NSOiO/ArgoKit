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
    var attibuteText:NSMutableAttributedString?
    var textTapAction:YYTextAction?
    var textLongAction:YYTextAction?
    
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
        lable.text = self.text()
        lable.attributedText = self.attibuteText
        lable.numberOfLines = UInt(self.numberOfLines())
        lable.lineBreakMode = self.lineBreakMode()
        lable.textAlignment = self.textAlignment()
        ArgoKitNodeViewModifier.performViewAttribute(lable, attributes: self.nodeAllAttributeValue())
        return lable.sizeThatFits(size)
    }
    func setText(_ value:String?){
        if let text = value {
            attibuteText = NSMutableAttributedString(string: text)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    func setAttributedText(_ value:NSAttributedString?){
        if let attributText = value {
            attibuteText = NSMutableAttributedString(attributedString: attributText)
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    
    func font(_ value:UIFont, range: NSRange? = nil){
        self.font = value
        if let range = range {
            attibuteText?.yy_setFont(value, range: range)
        }else{
            attibuteText?.yy_font = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    override func lineSpacing(_ value: CGFloat) {
        self.lineSpacing = value
        attibuteText?.yy_lineSpacing = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func kern(_ value:NSNumber?, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setKern(value, range: range)
        }else{
            attibuteText?.yy_kern = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textAlignment(_ value:NSTextAlignment, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setAlignment(value, range: range)
        }else{
            attibuteText?.yy_alignment = value
        }
        
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    func lineBreakMode(_ value:NSLineBreakMode, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setLineBreakMode(value, range: range)
        }else{
            attibuteText?.yy_lineBreakMode = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textColor(_ value:UIColor?, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setColor(value, range: range)
        }else{
            attibuteText?.yy_color = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func backgroundColor(_ value:UIColor?, range: NSRange? = nil)  {
        if let range = range {
            attibuteText?.yy_setBackgroundColor(value, range: range)
        }else{
            attibuteText?.yy_backgroundColor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func stroke(width:NSNumber?,color:UIColor?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setStrokeWidth(width, range: range)
            attibuteText?.yy_setStroke(color, range: range)
        }else{
            attibuteText?.yy_strokeWidth = width
            attibuteText?.yy_strokeColor = color
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    func strikethrough(style:YYTextLineStyle,
                       width:NSNumber?,
                       color:UIColor?,
                       range:NSRange?){
        let textDecoration = YYTextDecoration(style: style,width: width,color: color)
        if let range = range {
            attibuteText?.yy_setTextStrikethrough(textDecoration, range:range)
        }else{
            attibuteText?.yy_textStrikethrough = textDecoration
        }
        if let attibuteText = self.attibuteText {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
    }
    
    func underline(style:YYTextLineStyle,
                   width:NSNumber?,
                   color:UIColor?,
                   range: NSRange? = nil){
        let textDecoration = YYTextDecoration(style: style,width: width,color: color)
        if let range = range {
            attibuteText?.yy_setTextUnderline(textDecoration, range: range)
        }else{
            attibuteText?.yy_textUnderline = textDecoration
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
//    /**
//     The text border.
//
//     @discussion Default value is nil (no border).
//     @discussion Set this property applies to the entire text string.
//                 Get this property returns the first character's attribute.
//     @since YYText:6.0
//     */
//    @property (nullable, nonatomic, strong, readwrite) YYTextBorder *yy_textBorder;
//    - (void)yy_setTextBorder:(nullable YYTextBorder *)textBorder range:(NSRange)range;
//
//    /**
//     The text background border.
//
//     @discussion Default value is nil (no background border).
//     @discussion Set this property applies to the entire text string.
//                 Get this property returns the first character's attribute.
//     @since YYText:6.0
//     */
//    @property (nullable, nonatomic, strong, readwrite) YYTextBorder *yy_textBackgroundBorder;
//    - (void)yy_setTextBackgroundBorder:(nullable YYTextBorder *)textBackgroundBorder range:(NSRange)range;
    
//    + (instancetype)borderWithLineStyle:(YYTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(nullable UIColor *)color;
//    + (instancetype)borderWithFillColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;
    func textBorder(_ value:YYTextBorder,range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTextBorder(value, range: range)
        }else{
            attibuteText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil){
        let value = YYTextBorder(lineStyle: style, lineWidth: width, stroke: color)
        value.cornerRadius = cornerRadius
        if let range = range {
            attibuteText?.yy_setTextBorder(value, range: range)
        }else{
            attibuteText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    
    func textBackgroundBorder(_ value:YYTextBorder,range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTextBackgroundBorder(value, range: range)
        }else{
            attibuteText?.yy_textBackgroundBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textBackgroundBorder(style:YYTextLineStyle,width:CGFloat,color:UIColor?, cornerRadius:CGFloat = 0,range: NSRange? = nil){
        let value = YYTextBorder(lineStyle: style, lineWidth: width, stroke: color)
        value.cornerRadius = cornerRadius
        if let range = range {
            attibuteText?.yy_setTextBorder(value, range: range)
        }else{
            attibuteText?.yy_textBorder = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    
    var shadow:NSShadow = NSShadow()
    func shadow(_ value:NSShadow,range: NSRange? = nil){
        shadow = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    func shadow(color:UIColor,offset:CGSize,blurRadius:CGFloat,range: NSRange? = nil){
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func shadowColor(_ value:UIColor,range: NSRange? = nil){
        shadow.shadowColor = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func shadowOffset(_ value:CGSize,range: NSRange? = nil){
        shadow.shadowOffset = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func shadowBlurRadius(_ value:CGFloat,range: NSRange? = nil){
        shadow.shadowBlurRadius = value
        if let range = range {
            attibuteText?.yy_setShadow(shadow, range: range)
        }else{
            attibuteText?.yy_shadow = shadow
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func textEffect(_ value:String?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTextEffect(value, range: range)
        }else{
            attibuteText?.yy_textEffect = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }
    func obliqueness(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setObliqueness(value, range: range)
        }else{
            attibuteText?.yy_obliqueness = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }
    
    func expansion(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setExpansion(value, range: range)
        }else{
            attibuteText?.yy_expansion = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)

    }

    func baselineOffset(_ value:NSNumber?, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setBaselineOffset(value, range: range)
        }else{
            attibuteText?.yy_baselineOffset = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func setTextHighlightRange(_ range:NSRange?,color:UIColor?,backgroundColor:UIColor?,
                               userInfo:Dictionary<String, Any>?,
                               tapAction: ((NSAttributedString, NSRange)->())?,
                               longPressAction:((NSAttributedString, NSRange)->())?){
        var innerRange = NSRange(location: 0, length: attibuteText?.length ?? 0)
        if let range =  range{
            innerRange = range
        }
        attibuteText?.yy_setTextHighlight(innerRange, color: color, backgroundColor: backgroundColor, userInfo: userInfo, tapAction: { (view, attributedString, range, rect) in
            if let action = tapAction{
                action(attributedString,range)
            }
        }, longPressAction:{ (view, attributedString, range, rect) in
            if let action = longPressAction{
                action(attributedString,range)
            }
        })
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func baseWritingDirection(_ value:NSWritingDirection, range: NSRange? = nil) {
        if let range = range {
            attibuteText?.yy_setBaseWritingDirection(value, range: range)
        }else{
            attibuteText?.yy_baseWritingDirection = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    

    func paragraphSpacing(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setParagraphSpacing(value, range: range)
        }else{
            attibuteText?.yy_paragraphSpacing = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func paragraphSpacingBefore(_ value: CGFloat, range: NSRange? = nil){
        attibuteText?.yy_paragraphSpacingBefore = value
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func firstLineHeadIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setFirstLineHeadIndent(value, range: range)
        }else{
            attibuteText?.yy_firstLineHeadIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }


    func headIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setHeadIndent(value, range: range)
        }else{
            attibuteText?.yy_headIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func tailIndent(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTailIndent(value, range: range)
        }else{
            attibuteText?.yy_tailIndent = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func minimumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setMinimumLineHeight(value, range: range)
        }else{
            attibuteText?.yy_minimumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    func maximumLineHeight(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setMaximumLineHeight(value, range: range)
        }else{
            attibuteText?.yy_maximumLineHeight = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    
    func lineHeightMultiple(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setLineHeightMultiple(value, range: range)
        }else{
            attibuteText?.yy_lineHeightMultiple = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }

    func hyphenationFactor(_ value: Float, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setHyphenationFactor(value, range: range)
        }else{
            attibuteText?.yy_hyphenationFactor = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }


    func defaultTabInterval(_ value: CGFloat, range: NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setDefaultTabInterval(value, range: range)
        }else{
            attibuteText?.yy_defaultTabInterval = value
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    
    func setLink(_ link:Any?,range:NSRange? = nil){
        var innerRange = NSRange(location: 0, length: self.attibuteText?.length ?? 0)
        if let range = range {
            innerRange = range
        }
        attibuteText?.yy_setLink(link, range: innerRange)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    
    func setLink(range:NSRange?,
                 color:UIColor?,
                 backgroundColor:UIColor?,
                 userInfo:Dictionary<String, Any>?,
                tapAction:@escaping (String)->()){
        var innerRange = NSRange(location: 0, length: attibuteText?.length ?? 0)
        if let range =  range{
            innerRange = range
        }
        attibuteText?.yy_setTextHighlight(innerRange, color: color, backgroundColor: backgroundColor, userInfo: userInfo, tapAction: { (view, attributedString, rang, rect) in
            let substring = attributedString.attributedSubstring(from: rang).string
            tapAction(substring)
        }, longPressAction:nil)
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
    }
    
    func attachmentStringWithImage(_ image:UIImage?,
                                               fontSize:CGFloat,
                                               location:Int){
        if let image = image{
            let imageAttributeText = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: fontSize)
            if let lenght = self.attibuteText?.length,let imageAttributeText = imageAttributeText {
                if location >= lenght {
                    self.attibuteText?.append(imageAttributeText)
                }
                if location < lenght {
                    self.attibuteText?.insert(imageAttributeText, at: location)
                }
            }
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
        }
    }
    
    func tabStops(_ tabs:[NSTextTab],range:NSRange? = nil){
        if let range = range {
            attibuteText?.yy_setTabStops(tabs, range: range)
        }else{
            attibuteText?.yy_tabStops = tabs
        }
        ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),self.attibuteText)
    }
    override func handleLineSpacing() {
        
    }
}
