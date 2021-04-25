//
//  Text.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation
/// The View Representing of text，is implemented based on UILabel.
///
///```
///             Text("content..")
///                 .font(size: 25)
///                 .textColor(.white)
///                 .lineLimit(0)
///                 .lineSpacing(10)
///                 .backgroundColor(.orange)
///```
///
public struct Text:TextProtocol {
    
    
    let pNode: ArgoKitTextNode
    /// the node behind of Text
    public var node: ArgoKitNode?{ pNode }
    
    /// initialize the Text with emptry
    public init() {
        pNode = ArgoKitTextNode(viewClass:UILabel.self, type: Self.self)
    }
    /// initialize the Text with a string
    /// - Parameter text: a string value
    public init(_ text:@escaping @autoclosure () -> String?) {
        self.init()
        self.text(text())
    }
    
    /// initialize the Text with a string
    /// - Parameter text: a string value
    public init(attributedText:@escaping @autoclosure () -> NSAttributedString?) {
        self.init()
        self.attributedText(attributedText())
    }
}

extension Text{
    
    /// Returns the drawing rectangle for the label’s text. call textRect of the back label object directly.
    /// - Parameters:
    ///   - bounds: The bounding rectangle of the label.
    ///   - numberOfLines: The maximum number of lines to use for the label. The value 0 indicates the label has no maximum number of lines and the rectangle should encompass all of the text.
    /// - Returns: self
    public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect{
        if let label = self.node?.view as? UILabel {
            return label.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines);
        }
        return CGRect.zero
    }
    
    /// Draws the label’s text, or its shadow, in the specified rectangle.
    /// - Parameter rect: The bounding rectangle of the label.
    /// - Returns: self
    @discardableResult
    public func drawText(in rect: CGRect)->Self{
        addAttribute(#selector(UILabel.drawText(in:)),[rect])
        return self
    }
}

