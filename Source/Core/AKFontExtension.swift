//
//  ArgoKitFontExtension.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation
public enum AKFontStyle{
    case `default`
    case bold
    case italic
    case bolditalic
}
extension UIFont{
    public class func font(fontName:String?,fontStyle:AKFontStyle,fontSize:CGFloat)->UIFont{
        var retFont:UIFont = UIFont.preferredFont(forTextStyle: TextStyle.body)
        var fontDescriptor:UIFontDescriptor = retFont.fontDescriptor
        if let name = fontName {
            if isFontRegistered(fontName: name) {
                fontDescriptor = UIFontDescriptor(name: name, size: fontSize)
            }
        }
        switch fontStyle {
        case .bold:
            var traits = fontDescriptor.symbolicTraits
            traits = UIFontDescriptor.SymbolicTraits(rawValue: traits.rawValue | UIFontDescriptor.SymbolicTraits.traitBold.rawValue)
            fontDescriptor = fontDescriptor.withSymbolicTraits(traits) ?? fontDescriptor
            break
        case .italic:
            let matrix:CGAffineTransform = CGAffineTransform(a: 1.0, b: 0, c: CGFloat(tanf(Float(5.0 * Double.pi/180.0))), d: 1.0, tx: 0, ty: 0)
            fontDescriptor = fontDescriptor.withMatrix(matrix)
            break
        case .bolditalic:
            var traits = fontDescriptor.symbolicTraits
            traits = UIFontDescriptor.SymbolicTraits(rawValue: traits.rawValue | UIFontDescriptor.SymbolicTraits.traitBold.rawValue)
            fontDescriptor = fontDescriptor.withSymbolicTraits(traits) ?? fontDescriptor
            let matrix:CGAffineTransform = CGAffineTransform(a: 1.0, b: 0, c: CGFloat(tanf(Float(5.0 * Double.pi/180.0))), d: 1.0, tx: 0, ty: 0)
            fontDescriptor = fontDescriptor.withMatrix(matrix)
            break
        default:
            break
        }
        retFont = UIFont(descriptor: fontDescriptor, size: fontSize)
        return retFont
    }
    
    private class func isFontRegistered(fontName:String)->Bool{
        var isRegistered:Bool = false
        if let aFont =  UIFont(name: fontName, size: 12.0){
            isRegistered = (aFont.fontName.compare(fontName) == .orderedSame) || (aFont.familyName.compare(fontName) == .orderedSame)
        }
        return isRegistered
    }
}
