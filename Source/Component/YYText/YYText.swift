
import UIKit
import ArgoKit
import YYText

/// The View Representing of text，is implemented based on YYLabel.
///
///```
///     YYText("Text单行文本粗体.单行文本粗体单行.单行文本粗体单行.单行文本粗体单行")
///         .font(size: 15)
///         .font(style: .bold)
///         .backgroundColor(.green)
///         .margin(edge: .top, value: 10)
///         .alignSelf(.stretch)
///         .lineLimit(1)
///         .textBorder(style: .single, width: 2, color: .yellow,cornerRadius: 5,range: NSRange(location: 5, length: 4))
///         .baselineOffset(2.0)
///         .underline(style:[.single],width: 1.0, color: .red)
///         .strikethrough(style:[.single],width: 1.0, color: .red)
///         .setLink(range: NSRange(location: 5, length: 5), color: .blue, backgroundColor: .yellow, tapAction: { link in
///             print("setLink:\(link)")
///         })
///         .firstLineHeadIndent(20)
///         .attachmentStringWithImage("icybay.jpg", fontSize: 15, location: 15)
///         .textHighlightRange(NSRange(location: 10, length: 5), color: .red,
///         backgroundColor: model.color, tapAction: {(attribute, range) in
///             print("textHighlightRange:\(attribute),range:\(attribute.attributedSubstring(from: range))")
///         }, longPressAction: nil)
///         .onTapGesture {
///             print("onTapGesture")
///         }
///         .truncationToken("----")
///         .tabStops({ () -> [NSTextTab] in
///             let tab1:NSTextTab = NSTextTab(textAlignment: .natural, location: 10)
///             let tab2:NSTextTab = NSTextTab(textAlignment: .right, location: 20)
///             return [tab1,tab2]
///         })
///         .defaultTabInterval(3)
///```
///
public struct YYText: TextProtocol {
    private let textNode: YYTextNode
    public var node: ArgoKitNode?{
        textNode
    }
    
    public init() {
        textNode = YYTextNode(viewClass: YYLabel.self)
    }
    public init(_ text:@escaping @autoclosure () -> String?) {
        self.init()
        self.text(text())
    }
    
    public init(_ attributText:@escaping @autoclosure () -> NSAttributedString?) {
        self.init()
        self.attributedText(attributText())
    }
}
