
import UIKit
import ArgoKit
import YYText


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
}
