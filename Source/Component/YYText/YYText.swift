
import UIKit
import ArgoKit
import YYText


public struct YYText: View {
    private let pNode: YYTextNode
    public var node: ArgoKitNode?{
        pNode
    }
    
    public init() {
        pNode = YYTextNode(viewClass: YYLabel.self)
    }
    public init(_ text:@escaping @autoclosure () -> String?) {
        self.init()
//        self.text(text())
    }
}
