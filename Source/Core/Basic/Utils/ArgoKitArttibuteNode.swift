//
//  ArgoKitArttibuteNode.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/11.
//

import Foundation
open class ArgoKitArttibuteNode: ArgoKitNode {
    public var lineSpacing:CGFloat = 0
    public var paragraphSpacing:CGFloat = 0
    public var fontSize:CGFloat = 17.0
    public var fontStyle:AKFontStyle = .default
    public var fontName:String?
    public var font:UIFont = UIFont.font(fontName: nil, fontStyle: .default, fontSize: 17.0)
    public var text:String? = nil
    public var attributedText:NSMutableAttributedString? = nil
    public var numberOfLines:Int = 1
    public var lineBreakMode:NSLineBreakMode = .byTruncatingTail
    public var textAlignment:NSTextAlignment = .left
    public lazy var shadow:NSShadow = NSShadow()
    
}
