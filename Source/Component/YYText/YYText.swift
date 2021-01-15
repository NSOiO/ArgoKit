
import UIKit
import ArgoKit
import YYText

class YYTextNode: ArgoKitNode {
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let label = YYLabel()
        label.frame = frame
        return label
    }
}

struct YYText: View {
    private let pNode: ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
}
