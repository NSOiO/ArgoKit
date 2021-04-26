//
//  LikeText.swift
//  ArgoKitComponent
//
//  Created by Bruce on 2021/2/5.
//

import Foundation
import ArgoKit
import MDLikeView
class LikeTextNode: ArgoKitArttibuteNode {
    var textHeight:CGFloat = 19
    var textColor:UIColor = UIColor.clear
    var highlightedColor:UIColor = UIColor.clear
    var duration:TimeInterval = 0
    var countString:String = ""
    var unitString:String = ""
    override func createNodeView(withFrame frame: CGRect) -> UIView {
        let likeLabel:MDLikeLabel = MDLikeLabel(origin: CGPoint.zero, height: textHeight, textFont: self.font, color: textColor, highlightedColor: highlightedColor, animationDuration: duration, likeCount: countString, unitString: unitString)
        likeLabel.frame = frame
        return likeLabel;
    }
//    override func reusedAttributes(from node: ArgoKitNode) {
//        if let pnode = node as? LikeTextNode {
//
//        }
//    }
    func setCountString(_ value:String,highlighted:Bool){
        countString = value
        if let _view = self.nodeView() as? MDLikeLabel{
            _view.setLikeCount(value, highlighted: highlighted) { frame in
                
            }
        }
        self.markDirty()
    }
    
    func setCountString(_ value:String,highlighted:Bool,flipDown:Bool){
        countString = value
        if let _view = self.nodeView() as? MDLikeLabel{
            _view.setLikeCount(value, highlighted: highlighted, flipDown: flipDown) { frame in
                
            }
        }
        self.markDirty()
    }
    
    func refreshLikeCountString(_ value: String,
                                   highlighted: Bool){
        countString = value
        if let _view = self.nodeView() as? MDLikeLabel{
            _view.refreshLikeCount(value, highlighted: highlighted)
        }
        self.markDirty()
    }
    
    public func transitionToCountString(_ value:String,
                                        animation:Bool){
        countString = value
        if let _view = self.nodeView() as? MDLikeLabel{
            _view.transition(toCount: value, animation: animation) { frame in
                
            }
        }
        self.markDirty()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let _view = self.nodeView() as? MDLikeLabel {
            return _view.frame.size;
        }
        let likeLabel:MDLikeLabel = MDLikeLabel(origin: CGPoint.zero, height: textHeight, textFont: self.font, color: textColor, highlightedColor: highlightedColor, animationDuration: duration, likeCount: countString, unitString: unitString)
        return likeLabel.frame.size;
    }
    
}
public struct LikeText:View {
    var pNode:LikeTextNode
    public var node: ArgoKitNode?{
        return pNode
    }
    init() {
        pNode = LikeTextNode(viewClass: MDLikeLabel.self)
    }
    public init(textHeight:CGFloat,
                textFont:UIFont,
                textColor:UIColor,
                highlightedColor:UIColor,
                duration:TimeInterval,
                countString:String,
                unitString:String) {
        self.init()
        pNode.textHeight = textHeight
        pNode.font = textFont
        pNode.textColor = textColor
        pNode.highlightedColor = highlightedColor
        pNode.duration = duration
        pNode.countString = countString
        pNode.unitString = unitString
    }
    
}
extension LikeText{
    public func setLikeCountString(countString:@escaping @autoclosure () -> String,
                                   highlighted:@escaping @autoclosure () -> Bool)->Self{
        self.bindCallback({ [self] in
            pNode.setCountString(countString(), highlighted: highlighted())
        }, forKey: #function)
    }
    
    public func setLikeCountString(countString:@escaping @autoclosure () -> String,
                                   highlighted:@escaping @autoclosure () -> Bool,
                                   flipDown:@escaping @autoclosure () -> Bool)->Self{
        self.bindCallback({ [self] in
            pNode.setCountString(countString(), highlighted: highlighted(), flipDown: flipDown())
        }, forKey: #function)
    }
    
    public func refreshLikeCountString(countString:@escaping @autoclosure () -> String,
                                   highlighted:@escaping @autoclosure () -> Bool)->Self{
        self.bindCallback({ [self] in
            pNode.refreshLikeCountString(countString(), highlighted: highlighted())
        }, forKey: #function)
    }
    
    public func transitionToCountString(countString:@escaping @autoclosure () -> String,
                                        animation:@escaping @autoclosure () -> Bool)->Self{
        self.bindCallback({ [self] in
            pNode.transitionToCountString(countString(), animation: animation())
        }, forKey: #function)
    }
}
