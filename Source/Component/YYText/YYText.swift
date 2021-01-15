
import UIKit
import ArgoKit
import YYText

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
        return self.argo_sizeThatFits(size)
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
