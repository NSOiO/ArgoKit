//
//  LikeImage.swift
//  ArgoKitComponent
//
//  Created by Bruce on 2021/2/5.
//

import Foundation
import ArgoKit
import MDLikeView
class LikeImageNode: ArgoKitNode {
    var likeSvga:String?{
        didSet{
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDLikeControl.likeSvga), likeSvga)
        }
    }
    var disLikeSvga:String?{
        didSet{
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDLikeControl.disLikeSvga), disLikeSvga)
        }
    }
    var guideSvga:String?{
        didSet{
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDLikeControl.guideSvga), guideSvga)
        }
    }
    var normalUrl:String?{
        didSet{
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDLikeControl.normalUrl), normalUrl)
        }
    }
    var highlightUrl:String?{
        didSet{
            ArgoKitNodeViewModifier.addAttribute(self, #selector(setter:MDLikeControl.highlightUrl), highlightUrl)
        }
    }
    var willClicked:((Bool)->Bool)?
    var onClicked:((Bool,Bool)->())?
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let view = MDLikeControl(frame: frame,
                                 likeSvga: likeSvga ?? "",
                                 normalUrl: normalUrl ?? "",
                                 highlightUrl: highlightUrl ?? "",
                                 willClicked: willClicked ?? {_ in return true},
                                 onClicked: onClicked ?? {_,_ in})
        view?.didAnimatedToFrame = { frame in
            print("frame:\(frame)")
        }
        return view ?? MDLikeControl()
    }
    
    override func clearStrongRefrence() {
        super.clearStrongRefrence()
        willClicked = nil
        onClicked = nil
    }
}
public struct LikeView:View{
    private var pNode:LikeImageNode
    public var node: ArgoKitNode?{
        pNode
    }
    init() {
        pNode = LikeImageNode(viewClass: MDLikeControl.self)
    }
    public init(likeSvga:String? = "",
         normalUrl:String? = "",
         highlightUrl:String? = "",
         willClicked:((Bool)->Bool)? = nil,
         onClicked:((Bool,Bool)->())? = nil) {
         self.init()
        pNode.likeSvga = likeSvga
        pNode.normalUrl = normalUrl
        pNode.highlightUrl = highlightUrl
        pNode.willClicked = willClicked
        pNode.onClicked = onClicked
    }
    
}
extension LikeView{
    @discardableResult
    public func likeSvga(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            pNode.likeSvga = value()
        }, forKey: #function)
    }
    @discardableResult
    public func disLikeSvga(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            pNode.disLikeSvga = value()
        }, forKey: #function)
    }
    @discardableResult
    public func guideSvga(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            pNode.guideSvga = value()
        }, forKey: #function)
    }
    @discardableResult
    public func normalUrl(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            pNode.normalUrl = value()
        }, forKey: #function)
    }
    @discardableResult
    public func highlightUrl(_ value:@escaping @autoclosure () -> String?) -> Self{
        self.bindCallback({ [self] in
            pNode.highlightUrl = value()
        }, forKey: #function)
    }
    @discardableResult
    public func refreshHighlighted(_ value:@escaping @autoclosure () -> Bool?) -> Self{
        self.bindCallback({ [self] in
            addAttribute(#selector(MDLikeControl.refreshHighlighted(_:)), value())
        }, forKey: #function)
    }
    @discardableResult
    public func likeControlAnimation() -> Self{
        addAttribute(#selector(MDLikeControl.likeControlAnimation))
        return self
    }
    @discardableResult
    public func guideAnimation() -> Self{
        addAttribute(#selector(MDLikeControl.guideAnimation))
        return self
    }
}
