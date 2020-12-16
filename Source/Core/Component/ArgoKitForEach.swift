//
//  ArgoKitForEach.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/22.
//

import Foundation

/*
public struct ForEach:View{
    private var innerNode:ArgoKitNode
    public var node: ArgoKitNode?{
        innerNode
    }
    
    public init<T>(_ data:Array<T>?,@ArgoKitViewBuilder _ builder:@escaping (T?)->View) {
        innerNode = ArgoKitNode(viewClass: UIView.self);
        if let datas = data {
            for item in datas {
                let container = builder(item)
                if let nodes = container.type.viewNodes() {
                    for node in nodes {
                        innerNode.addChildNode(node)
                    }
                }
            }
        }
    }
    
    public init(_ data:Range<Int>,@ArgoKitViewBuilder _ builder:@escaping (Int)->View) {
        innerNode = ArgoKitNode(viewClass: UIView.self);
        for item in data {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                for node in nodes {
                    innerNode.addChildNode(node)
                }
            }
        }
    }
}
*/



public struct ForEach<T>:View{
    var nodeContainer:[ArgoKitNode] = []
    private var nodeType:ArgoKitNodeType
    public var node: ArgoKitNode?{
        nil
    }
    public var type: ArgoKitNodeType{
        nodeType
    }
    
    public init(_ data:Array<T>?,@ArgoKitViewBuilder _ builder:@escaping (T?)->View) {
        if let datas = data {
            for item in datas {
                let container = builder(item)
                if let nodes = container.type.viewNodes() {
                    nodeContainer.append(contentsOf: nodes)
                }
            }
        }
        
        if nodeContainer.count == 0 {
            nodeType = .empty
        }else if nodeContainer.count == 1 {
            nodeType = .single(nodeContainer[0])
        }else {
            nodeType = .multiple(nodeContainer)
        }
    }
    
    public init(_ range:T,@ArgoKitViewBuilder _ builder:@escaping (Int)->View) where T == Range<Int>{
        for item in range {
            let container = builder(item)
            if let nodes = container.type.viewNodes() {
                nodeContainer.append(contentsOf: nodes)
            }
        }
        
        if nodeContainer.count == 0 {
            nodeType = .empty
        }else if nodeContainer.count == 1 {
            nodeType = .single(nodeContainer[0])
        }else {
            nodeType = .multiple(nodeContainer)
        }
    }
}





// MARK ===== 废弃方法 ====
extension ForEach {
    @available(*, deprecated, message: "Image does not support the method!")
    fileprivate func direction(_ value:ArgoDirection)->Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func flexDirection(_ value:ArgoFlexDirection)->Self{
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func justifyContent(_ value:ArgoJustify)->Self{
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func alignContent(_ value:ArgoAlign)->Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func alignItems(_ value:ArgoAlign)->Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func alignSelf(_ value:ArgoAlign)->Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func positionType(_ value:ArgoPositionType)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func wrap(_ value:ArgoWrapType)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func displayFlex()->Self{
        return self;
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func displayNone()->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func flex(_ value:CGFloat)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func grow(_ value:CGFloat)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shrink(_ value:CGFloat)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func basis(_ value:ArgoValue)->Self{
        return self;
    }

    
    @available(*, deprecated, message: "Image does not support the method!")
    public func position(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return position(edge: .top, value: top)
            .position(edge: .left, value: left)
            .position(edge: .bottom, value: bottom)
            .position(edge: .right, value:right)
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func position(edge:ArgoEdge,value:ArgoValue)->Self{
        return self;
    }

    
    @available(*, deprecated, message: "Image does not support the method!")
    public func margin(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return margin(edge: .top, value: top)
            .margin(edge: .left, value: left)
            .margin(edge: .bottom, value: bottom)
            .margin(edge: .right, value:right)
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func margin(edge:ArgoEdge,value:ArgoValue)->Self{
        return self;
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        return self;
    }
    
}

extension ForEach{
    @available(*, deprecated, message: "Image does not support the method!")
    private func  borderWidth(top:CGFloat,right:CGFloat,bottom:CGFloat,left:CGFloat)->Self{
        return self.borderWidth(edge: .top, value: top)
            .borderWidth(edge: .right, value: right)
            .borderWidth(edge: .bottom, value: bottom)
            .borderWidth(edge: .left, value: left)
    }
    @available(*, deprecated, message: "Image does not support the method!")
    private func  borderWidth(edge:ArgoEdge,value:CGFloat)->Self{
        return self;
    }
}

extension ForEach{
    @available(*, deprecated, message: "Image does not support the method!")
    public func size(width: ArgoValue, height: ArgoValue) -> Self {
        return self.width(width).height(height)
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func width(_ value:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func height(_ value:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func minWidth(_ value:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func minHeight(_ value:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func maxWidth(_ value:ArgoValue)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func maxHeight(_ value:ArgoValue)->Self{
        return self
    }
    
}
extension ForEach{
    @available(*, deprecated, message: "Image does not support the method!")
    public func width()->CGFloat{
        return self.node?.width() ?? 0
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func height()->CGFloat{
        return self.node?.height() ?? 0
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func minWidth()->CGFloat{
        return self.node?.minWidth() ?? 0
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func minHeight()->CGFloat{
        return self.node?.minHeight() ?? 0
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func maxWidth()->CGFloat{
        return self.node?.maxWidth() ?? 0
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func maxHeight()->CGFloat{
        return self.node?.maxHeight() ?? 0
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func aspect(ratio: CGFloat) -> Self {
        return self
    }
}



// modifier
extension ForEach {
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func isUserInteractionEnabled(_ value:Bool)->Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func tag(_ value:Int)->Self{
        return self
    }
    
    public func tag()->Int?{
        return self.node?.view?.tag
    }
    public func layer()-> CALayer? {
        return self.node?.view?.layer
    }

    @available(iOS 9.0, *)
    public func canBecomeFocused()-> Bool? {
        return self.node?.view?.canBecomeFocused
    }

    @available(iOS 9.0, *)
    public func isFocused()-> Bool? {
        return self.node?.view?.isFocused
    }

    /// The identifier of the focus group that this view belongs to. If this is nil, subviews inherit their superview's focus group.
    @available(iOS 14.0, *)
    @available(*, deprecated, message: "Image does not support the method!")
    public func focusGroupIdentifier(_ value:String?)->Self{
        return self
    }
    
    @available(iOS 14.0, *)
    @available(*, deprecated, message: "Image does not support the method!")
    public func focusGroupIdentifier()-> String? {
        return self.node?.view?.focusGroupIdentifier
    }

    @available(iOS 9.0, *)
    @available(*, deprecated, message: "Image does not support the method!")
    public func semanticContentAttribute(_ value:UISemanticContentAttribute)->Self{
        return self
    }
    public func semanticContentAttribute()->UISemanticContentAttribute?{
        return self.node?.view?.semanticContentAttribute
    }
    @available(iOS 10.0, *)
    public func effectiveUserInterfaceLayoutDirection()-> UIUserInterfaceLayoutDirection? {
        return self.node?.view?.effectiveUserInterfaceLayoutDirection
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func backgroundColor(_ value:UIColor)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func backgroundColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func backgroundColor(hex :Int,alpha a:Float = 1)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func alpha(_ value:CGFloat)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func opaque(_ value:Bool)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func clearsContextBeforeDrawing(_ value:Bool)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func hidden(_ value:Bool)->Self{

        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func display(_ value:Bool)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func contentMode(_ value:UIView.ContentMode)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func tintColor(_ value:UIColor)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func tintColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func tintColor(hex :Int,alpha a:Float = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func tintAdjustmentMode(_ value:UIView.TintAdjustmentMode)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func clipsToBounds(_ value:Bool)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func cornerRadius(_ value:CGFloat)->Self{
        return self.cornerRadius(topLeft: value, topRight: value, bottomLeft: value, bottomRight: value);
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func cornerRadius(topLeft:CGFloat,topRight:CGFloat,bottomLeft:CGFloat,bottomRight:CGFloat)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func borderWidth(_ value:CGFloat)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func borderColor(_ value:UIColor)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func borderColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func borderColor(hex :Int,alpha a:Float = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func circle()->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shadowColor(_ value: UIColor?) -> Self {
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shadowColor(red r:Int,green g :Int,blue b:Int,alpha a:CGFloat = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shadowColor(hex :Int,alpha a:Float = 1)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shadow(offset: CGSize, radius: CGFloat, opacity: Float) -> Self {
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func shadow(color:UIColor? = .gray, offset:CGSize,radius:CGFloat,opacity:Float,corners:UIRectCorner = .allCorners)->Self{
        return self;
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func gradientColor(startColor: UIColor?,endColor:UIColor?,direction:ArgoKitGradientType?) -> Self {
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func cleanGradientLayer() -> Self {
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func addBlurEffect(style:UIBlurEffect.Style,alpha:CGFloat? = nil,color:UIColor? = nil) -> Self{
        return self
    }
    
    @available(*, deprecated, message: "Image does not support the method!")
    public func removeBlurEffect() -> Self{
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func alias<T>(variable ptr:inout T?) -> Self where T: View{
        return self
    }

    public func addSubNodes(@ArgoKitViewBuilder builder:@escaping ()->View){
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func gesture(gesture:Gesture)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func removeGesture(gesture:Gesture)->Self{
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func onTapGesture(numberOfTaps: Int = 1, numberOfTouches: Int = 1,action:@escaping ()->Void)->Self{
        return self
    }
    @available(*, deprecated, message: "Image does not support the method!")
    public func onLongPressGesture(numberOfTaps:Int, numberOfTouches:Int,minimumPressDuration:TimeInterval = 0.5,allowableMovement:CGFloat = 10,action:@escaping ()->Void)->Self{
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func endEditing(_ force: Bool) -> Self {
        return self
    }

    @available(*, deprecated, message: "Image does not support the method!")
    public func addAnimation(_ animation: Animation) -> Self {
        return self
    }
}
