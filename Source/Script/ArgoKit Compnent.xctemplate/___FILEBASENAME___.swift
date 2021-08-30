
//___FILEHEADER___

import ArgoKit

// view Node.
class ___FILEBASENAMEASIDENTIFIER___Node: ArgoKitNode {
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        return ___VARIABLE_LinkView___(frame: frame)
    }
    override func prepareForUse(view: UIView?) {
        super.prepareForUse(view: view)
    }
    override func reuseNodeToView(node: ArgoKitNode, view: UIView?) {
        super.reuseNodeToView(node: node, view: view)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return super.sizeThatFits(size)
    }
}

// view
struct ___FILEBASENAMEASIDENTIFIER___: ArgoKit.View {
    private var pNode: ___FILEBASENAME___Node
    public var node: ArgoKitNode? {
        pNode
    }
    public init() {
        pNode = ___FILEBASENAMEASIDENTIFIER___Node(viewClass: ___VARIABLE_LinkView___.self)
    }
    
    //    设置UIKit的视图属性
    //    public func setProperty(_ value:Bool)->Self{
    //        return  self.bindCallback({
    //            addAttribute(#selector(setter:___VARIABLE_LinkView___.property),value())
    //        }, forKey: #function)
    //    }
}

