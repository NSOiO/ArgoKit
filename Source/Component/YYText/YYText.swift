
import UIKit
import ArgoKit
import YYText
struct YYTextCalculation {
    static let yycalculationLable:YYLabel = YYLabel()
}
class YYTextNode: ArgoKitNode, TextNodeProtocol {
    var lineSpacing: CGFloat = 0
    
    var fontSize: CGFloat = 17
    
    var fontStyle: AKFontStyle = .default
    
    var fontName: String?
    
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let label = YYLabel()
        label.frame = frame
        
        return label
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let lable = YYTextCalculation.yycalculationLable
        let font = UIFont.font(fontName: self.fontName, fontStyle: self.fontStyle, fontSize: self.fontSize)
        lable.font = font
        lable.text = nil
        lable.attributedText = nil
        lable.numberOfLines = 1
        ArgoKitNodeViewModifier.performViewAttribute(lable, attributes: self.nodeAllAttributeValue())
        return lable.sizeThatFits(size)
    }
}

public struct YYText: TextProtocol {
    private let pNode: YYTextNode
    public var node: ArgoKitNode?{
        pNode
    }
    public var textNode: TextNodeProtocol { pNode }
    
    public init() {
        pNode = YYTextNode(viewClass: YYLabel.self)
    }
    
    public init(_ text:@escaping @autoclosure () -> String?) {
        self.init()
        self.text(text())
    }
}
