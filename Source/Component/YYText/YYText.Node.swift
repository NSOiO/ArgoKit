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
    
    override func createNodeViewIfNeed(_ frame: CGRect) {
        if let attibuteText = self.attibuteText {
            ArgoKitNodeViewModifier.addAttribute(self,#selector(setter:YYLabel.attributedText),attibuteText)
        }
        super.createNodeViewIfNeed(frame)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable = YYTextCalculation.yycalculationLable
        lable.textLayout = nil
        let font = UIFont.font(fontName: self.fontName, fontStyle: self.fontStyle, fontSize: self.fontSize)
        lable.font = font
        lable.text = nil
        lable.attributedText = nil
        lable.numberOfLines = UInt(self.numberOfLines())
        lable.textAlignment = self.textAlignment()
        lable.lineBreakMode = self.lineBreakMode()
        lable.attributedText = attibuteText
        ArgoKitNodeViewModifier.performViewAttribute(lable, attributes: self.nodeAllAttributeValue())
        return lable.sizeThatFits(size)
    }
    func setText(_ value:String){
        attibuteText = NSMutableAttributedString(string: value)
    }
    func setAttributedText(_ value:NSAttributedString){
        attibuteText = NSMutableAttributedString(attributedString: value)
    }
    
    override var font: UIFont{
        didSet(newValue){
            attibuteText?.yy_font = newValue
        }
    }
    override var fontName: String?{
        didSet(newValue){
            self.font = UIFont.font(fontName: newValue, fontStyle: fontStyle, fontSize: fontSize)
        }
    }
    override var fontSize: CGFloat{
        didSet(newValue){
            self.font = UIFont.font(fontName: fontName, fontStyle: fontStyle, fontSize: newValue)
        }
    }
    
    override var fontStyle: AKFontStyle{
        didSet(newValue){
            self.font = UIFont.font(fontName: fontName, fontStyle: newValue, fontSize: fontSize)
        }
    }
    
    override func lineSpacing(_ value: CGFloat) {
        self.lineSpacing = value
    }
    
    override var lineSpacing: CGFloat{
        didSet(newValue){
            attibuteText?.yy_lineSpacing = newValue
        }
    }
    var textAlignment:NSTextAlignment = .left{
        didSet(newValue){
            attibuteText?.yy_alignment = newValue
        }
    }
    var lineBreakMode:NSLineBreakMode = .byWordWrapping{
        didSet(newValue){
            attibuteText?.yy_lineBreakMode = newValue
        }
    }
    
    func handleLineSpacing() {
        
    }
}

extension YYText{
    
    
}
