//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
public struct Text:View {
    public var body: View{
        self
    }
    private let label:UILabel
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var type: ArgoKitNodeType{
        .single(pNode)
    }

    public init() {
        label = UILabel()
        pNode = ArgoKitNode(view: label)
    }
    public init(_ text:String?) {
        self.init()
        label.text = text;
    }

}

extension Text{
    public func text(_ value:String?)->Self{
        label.text = value
        self.markNeedsLayout()
        return self
    }
    public func font(_ value:UIFont!)->Self{
        label.font = value
        self.markNeedsLayout()
        return self
    }
    public func textColor(_ value:UIColor!)->Self{
        label.textColor = value
        return self
    }
    public func shadowColor(_ value:UIColor?)->Self{
        label.shadowColor = value
        return self
    }
    public func shadowOffset(_ value:CGSize)->Self{
        label.shadowOffset = value
        return self
    }
    public func textAlignment(_ value:NSTextAlignment)->Self{
        label.textAlignment = value
        return self
    }
    public func lineBreakMode(_ value:NSLineBreakMode)->Self{
        label.lineBreakMode = value
        return self
    }
    
    public func attributedText(_ value:NSAttributedString?)->Self{
        label.attributedText = value
        self.markNeedsLayout()
        return self
    }
    
    public func highlightedTextColor(_ value:UIColor?)->Self{
        label.highlightedTextColor = value
        return self
    }
    
    public func isHighlighted(_ value:Bool)->Self{
        label.isHighlighted = value
        return self
    }
    
    
    public func userInteractionEnabled(_ value:Bool)->Self{
        label.isUserInteractionEnabled = value
        return self
    }
    public func isEnabled(_ value:Bool)->Self{
        label.isEnabled = value;
        return self
    }
    
    public func numberOfLines(_ value:Int)->Self{
        label.numberOfLines = value;
        self.markNeedsLayout()
        return self
    }

    // these next 3 properties allow the label to be autosized to fit a certain width by scaling the font size(s) by a scaling factor >= the minimum scaling factor
    // and to specify how the text baseline moves when it needs to shrink the font.
    // default is NO
    public func adjustsFontSizeToFitWidth(_ value:Bool)->Self{
        label.adjustsFontSizeToFitWidth = value;
        return self
    }
    
    // default is UIBaselineAdjustmentAlignBaselines
    public func baselineAdjustment(_ value:UIBaselineAdjustment)->Self{
        label.baselineAdjustment = value;
        return self
    }


    @available(iOS 6.0, *)
    public func minimumScaleFactor(_ value:CGFloat)->Self{
        label.minimumScaleFactor = value;
        return self
    }

    
    // Tightens inter-character spacing in attempt to fit lines wider than the available space if the line break mode is one of the truncation modes before starting to truncate.
    // The maximum amount of tightening performed is determined by the system based on contexts such as font, line width, etc.
    @available(iOS 9.0, *)
    public func allowsDefaultTighteningForTruncation(_ value:Bool)->Self{
        label.allowsDefaultTighteningForTruncation = value;
        return self
    }

    
    // Specifies the line break strategies that may be used for laying out the text in this label.
    // If this property is not set, the default value is NSLineBreakStrategyStandard.
    // If the label contains an attributed text with paragraph style(s) that specify a set of line break strategies, the set of strategies in the paragraph style(s) will be used instead of the set of strategies defined by this property.
    public func lineBreakStrategy(_ value:NSParagraphStyle.LineBreakStrategy)->Self{
        label.lineBreakStrategy = value;
        return self
    }

    // override points. can adjust rect before calling super.
    // label has default content mode of UIViewContentModeRedraw
    public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect{
        return label.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines);
    }

    public func drawText(in rect: CGRect)->Self{
        label.drawText(in: rect);
        return self
    }

    // Support for constraint-based layout (auto layout)
    // If nonzero, this is used when determining -intrinsicContentSize for multiline labels
    @available(iOS 6.0, *)
    public func preferredMaxLayoutWidth(in value: CGFloat)->Self{
        label.preferredMaxLayoutWidth = value
        return self
    }
    
}
