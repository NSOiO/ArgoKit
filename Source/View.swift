//
//  NodeView.swift
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

import Foundation

public enum ArgoKitNodeType {
    case empty
    case multiple([ArgoKitNode])
    case single(ArgoKitNode)
    
    public func viewNode() -> ArgoKitNode? {
        switch self {
        case .empty:
            return nil
        case .single(let node):
            return node
        case .multiple(let nodes):
            let container = ArgoKitNode(view: UIView())
            for node in nodes {
                container.addChildNode(node)
            }
            return container
        }
    }
    
    public func viewNodes() -> [ArgoKitNode]? {
        switch self {
        case .empty:
            return nil
        case .multiple(let nodes):
            return nodes
        case .single(let node):
            return [node]
        }
    }
}

public protocol View {
    // 初始视图层次
    var type: ArgoKitNodeType{get}
    // 布局节点对象
    var node:ArgoKitNode?{get}
    
    @ArgoKitViewBuilder var body: View { get }
}

public extension View{
    var type: ArgoKitNodeType{.single(ArgoKitNode(view:UIView()))}
    var node:ArgoKitNode?{type.viewNode()}
}
extension View{
    func addSubNodes(@ArgoKitViewBuilder _ builder:()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}
extension View{
    func addSubNodes(@ArgoKitViewBuilder builder:()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}

extension View{
    public func clipsToBounds(_ value:Bool)->Self{
        if let node = self.node {
            node.view?.clipsToBounds = value;
        }
        return self;
    }
    public func backgroundColor(_ value:UIColor)->Self{
        if let node = self.node {
            node.view?.backgroundColor = value;
        }
        return self;
    }
    public func alpha(_ value:CGFloat)->Self{
        if let node = self.node {
            node.view?.alpha = value;
        }
        return self;
    }
    public func opaque(_ value:Bool)->Self{
        if let node = self.node {
            node.view?.isOpaque = value;
        }
        return self;
    }
    public func clearsContextBeforeDrawing(_ value:Bool)->Self{
        self.node?.view?.clearsContextBeforeDrawing = value;
        return self;
    }
    public func hidden(_ value:Bool)->Self{
        self.node?.view?.isHidden = value;
        return self;
    }
    public func contentMode(_ value:UIView.ContentMode)->Self{
        self.node?.view?.contentMode = value;
        return self;
    }
    public func tintColor(_ value:UIColor)->Self{
        self.node?.view?.tintColor = value;
        return self;
    }
    public func tintAdjustmentMode(_ value:UIView.TintAdjustmentMode)->Self{
        self.node?.view?.tintAdjustmentMode = value;
        
        return self;
    }
    public func cornerRadius(_ value:CGFloat)->Self{
        self.node?.view?.layer.cornerRadius = value
        return self;
    }
}

extension View{
}
// UITapGestureRecognizer
extension View{
    public func gesture(gesture:Gesture)->Self{
        gesture.gesture.isEnabled = true
        gesture.gesture.addTarget(self.node!, action: #selector(ArgoKitNode.nodeAction(_:)))
        self.node?.view?.addGestureRecognizer(gesture.gesture)
        self.node?.setNodeActionBlock(gesture.gesture){items in
            for item in items{
                if item is UIGestureRecognizer {
                    gesture.action(item as! UIGestureRecognizer)
                }
            }
        }
        return self
    }
    public func removeGesture(gesture:Gesture)->Self{
        self.node?.view?.removeGestureRecognizer(gesture.gesture)
        return self
    }
}

/*
 Layout direction specifies the direction in which children and text in a hierarchy should be laid out. Layout direction also effects what edge start and end refer to. By default Yoga lays out with LTR layout direction. In this mode start refers to left and end refers to right. When localizing your apps for markets with RTL languages you should customize this by either by passing a direction to the CalculateLayout call or by setting the direction on the root node.
 */
extension View {
    public func done(){
        self.node?.done();
    }
    public func dirInherit()->Self{
        self.node?.directionInherit();
        return self;
    }
    public func dirLTR()->Self{
        self.node?.directionLTR();
        return self;
    }
    public func dirRTL()->Self{
        self.node?.directionRTL();
        return self;
    }
}
/*
 Flex direction controls the direction in which children of a node are laid out. This is also referred to as the main axis. The main axis is the direction in which children are laid out. The cross axis the the axis perpendicular to the main axis, or the axis which wrapping lines are laid out in.
 */
extension View {
    public func column()->Self{
        self.node?.column();
        return self;
    }
    public func columnREV()->Self{
        self.node?.columnREV();
        return self;
    }
    public func row()->Self{
        self.node?.row();
        return self;
    }
    public func rowREV()->Self{
        self.node?.rowREV();
        return self;
    }
}

/*
 ustify content describes how to align children within the main axis of their container. For example, you can use this property to center a child horizontally within a container with flex direction set to row or vertically within a container with flex direction set to column.
 */
extension View{
    public func justifyContentStart()->Self{
        self.node?.justifyContentFlexStart();
        return self;
    }
    
    public func justifyContentCenter()->Self{
        self.node?.justifyContentCenter();
        return self;
    }
    
    public func justifyContentFlexEnd()->Self{
        self.node?.justifyContentFlexEnd();
        return self;
    }
    
    public func justifyContentSpaceBetween()->Self{
        self.node?.justifyContentSpaceBetween();
        return self;
    }
    
    public func justifyContentSpaceAround()->Self{
        self.node?.justifyContentSpaceAround();
        return self;
    }
    
    public func justifyContentSpaceEvenly()->Self{
        self.node?.justifyContentSpaceEvenly();
        return self;
    }
}

/*
 Align content defines the distribution of lines along the cross-axis. This only has effect when items are wrapped to multiple lines using flex wrap.
 */
extension View{
    public func alignContentAuto()->Self{
        self.node?.alignContentAuto();
        return self;
    }
    public func alignContentFlexStart()->Self{
        self.node?.alignContentFlexStart();
        return self;
    }
    public func alignContentCenter()->Self{
        self.node?.alignContentCenter();
        return self;
    }
    public func alignContentFlexEnd()->Self{
        self.node?.alignContentFlexEnd();
        return self;
    }
    public func alignContentStretch()->Self{
        self.node?.alignContentStretch();
        return self;
    }
    public func alignContentBaseline()->Self{
        self.node?.alignContentBaseline();
        return self;
    }
    public func alignContentSpaceBetween()->Self{
        self.node?.alignContentSpaceBetween();
        return self;
    }
    public func alignContentSpaceAround()->Self{
        self.node?.alignContentSpaceAround();
        return self;
    }
}
/*
 Align items describes how to align children along the cross axis of their container. Align items is very similar to justify content but instead of applying to the main axis, align items applies to the cross axis.
 */
extension View{
    public func alignItemsAuto()->Self{
        self.node?.alignContentAuto();
        return self;
    }
    public func alignItemsFlexStart()->Self{
        self.node?.alignItemsFlexStart();
        return self;
    }
    public func alignItemsCenter()->Self{
        self.node?.alignItemsCenter();
        return self;
    }
    public func alignItemsFlexEnd()->Self{
        self.node?.alignItemsFlexEnd();
        return self;
    }
    public func alignItemsStretch()->Self{
        self.node?.alignItemsStretch();
        return self;
    }
    public func alignItemsBaseline()->Self{
        self.node?.alignItemsBaseline();
        return self;
    }
    public func alignItemsSpaceBetween()->Self{
        self.node?.alignItemsBaseline();
        return self;
    }
    public func alignItemsSpaceAround()->Self{
        self.node?.alignItemsBaseline();
        return self;
    }
}

/*
 Align self has the same options and effect as align items but instead of affecting the children within a container, you can apply this property to a single child to change its alignment within its parent. align self overrides any option set by the parent with align items.
 */
extension View{
    public func alignSelfAuto()->Self{
        self.node?.alignSelfAuto();
        return self;
    }
    public func alignSelfFlexStart()->Self{
        self.node?.alignSelfFlexStart();
        return self;
    }
    public func alignSelfCenter()->Self{
        self.node?.alignSelfCenter();
        return self;
    }
    public func alignSelFlexEnd()->Self{
        self.node?.alignSelFlexEnd();
        return self;
    }
    public func alignSelfStretch()->Self{
        self.node?.alignSelfStretch();
        return self;
    }
    public func alignSelfBaseline()->Self{
        self.node?.alignSelfBaseline();
        return self;
    }
    public func alignSelfSpaceBetween()->Self{
        self.node?.alignSelfSpaceBetween();
        return self;
    }
    public func alignSelfSpaceAround()->Self{
        self.node?.alignSelfSpaceAround();
        return self;
    }
}

extension View{
    public func positionRelative()->Self{
        self.node?.positionRelative();
        return self;
    }
    public func positionAbsolute()->Self{
        self.node?.positionAbsolute();
        return self;
    }
    public func noWrap()->Self{
        self.node?.flexWrapNoWrap();
        return self;
    }
    public func wrap()->Self{
        self.node?.flexWrapWrap();
        return self;
    }
    public func wrapREV()->Self{
        self.node?.flexWrapWrapREV();
        return self;
    }
    public func overflowVisible()->Self{
        self.node?.overflowVisible();
        return self;
    }
    public func overflowHidden()->Self{
        self.node?.overflowHidden();
        return self;
    }
    public func overflowScroll()->Self{
        self.node?.overflowScroll();
        return self;
    }
    
    public func displayFlex()->Self{
        self.node?.displayFlex();
        return self;
    }
    public func displayNone()->Self{
        self.node?.displayNone();
        return self;
    }
}
extension View{
    public func flex(_ value:CGFloat)->Self{
        self.node?.flex(value);
        return self;
    }
    public func grow(_ value:CGFloat)->Self{
        self.node?.flexGrow(value);
        return self;
    }
    
    public func shrink(_ value:CGFloat)->Self{
        self.node?.flexShrink(value);
        return self;
    }
    
    public func basisAuto()->Self{
        self.node?.flexBasisAuto();
        return self;
    }
    
    public func basis(percent value:CGFloat)->Self{
        self.node?.flexBasis(percent: value);
        return self;
    }
    
    public func basis(point value:CGFloat)->Self{
        self.node?.flexBasis(point:value);
        return self;
    }
    
}

extension View{
    public func left(percent value:CGFloat)->Self{
        self.node?.left(percent: value);
        return self;
    }
    public func left(point value:CGFloat)->Self{
        self.node?.left(point:value);
        return self;
    }
    
    public func top(percent value:CGFloat)->Self{
        self.node?.top(percent: value);
        return self;
    }
    public func top(point value:CGFloat)->Self{
        self.node?.top(point:value);
        return self;
    }
    
    public func right(percent value:CGFloat)->Self{
        self.node?.right(percent: value);
        return self;
    }
    public func right(point value:CGFloat)->Self{
        self.node?.right(point:value);
        return self;
    }
    
    public func bottom(percent value:CGFloat)->Self{
        self.node?.bottom(percent: value);
        return self;
    }
    public func bottom(point value:CGFloat)->Self{
        self.node?.bottom(point:value);
        return self;
    }
    
    public func start(percent value:CGFloat)->Self{
        self.node?.start(percent: value);
        return self;
    }
    public func start(point value:CGFloat)->Self{
        self.node?.start(point:value);
        return self;
    }
    
    public func end(percent value:CGFloat)->Self{
        self.node?.start(percent: value);
        return self;
    }
    public func end(point value:CGFloat)->Self{
        self.node?.start(point:value);
        return self;
    }
    
}

extension View{
    public func marginLeft(percent value:CGFloat)->Self{
        self.node?.marginLeft(percent: value);
        return self;
    }
    public func marginLeft(point value:CGFloat)->Self{
        self.node?.marginLeft(point:value);
        return self;
    }
    
    public func marginTop(percent value:CGFloat)->Self{
        self.node?.marginTop(percent: value);
        return self;
    }
    public func marginTop(point value:CGFloat)->Self{
        self.node?.marginTop(point:value);
        return self;
    }
    
    public func marginRight(percent value:CGFloat)->Self{
        self.node?.marginRight(percent: value);
        return self;
    }
    public func marginRight(point value:CGFloat)->Self{
        self.node?.marginRight(point:value);
        return self;
    }
    
    public func marginBottom(percent value:CGFloat)->Self{
        self.node?.marginBottom(percent: value);
        return self;
    }
    public func marginBottom(point value:CGFloat)->Self{
        self.node?.marginBottom(point:value);
        return self;
    }
    
    public func marginStart(percent value:CGFloat)->Self{
        self.node?.marginStart(percent: value);
        return self;
    }
    public func marginStart(point value:CGFloat)->Self{
        self.node?.marginStart(point:value);
        return self;
    }
    
    public func marginEnd(percent value:CGFloat)->Self{
        self.node?.start(percent: value);
        return self;
    }
    public func marginEnd(point value:CGFloat)->Self{
        self.node?.start(point:value);
        return self;
    }
    
    public func marginH(percent value:CGFloat)->Self{
        self.node?.marginH(percent: value);
        return self;
    }
    public func marginH(point value:CGFloat)->Self{
        self.node?.marginH(point:value);
        return self;
    }
    
    public func marginV(percent value:CGFloat)->Self{
        self.node?.marginV(percent: value);
        return self;
    }
    public func marginV(point value:CGFloat)->Self{
        self.node?.marginV(point:value);
        return self;
    }
    
    public func marginAll(percent value:CGFloat)->Self{
        self.node?.marginAll(percent: value);
        return self;
    }
    public func marginAll(point value:CGFloat)->Self{
        self.node?.marginAll(point:value);
        return self;
    }
}


extension View{
    public func paddingLeft(percent value:CGFloat)->Self{
        self.node?.paddingLeft(percent: value);
        return self;
    }
    public func paddingLeft(point value:CGFloat)->Self{
        self.node?.paddingLeft(point:value);
        return self;
    }
    
    public func paddingTop(percent value:CGFloat)->Self{
        self.node?.paddingTop(percent: value);
        return self;
    }
    public func paddingTop(point value:CGFloat)->Self{
        self.node?.paddingTop(point:value);
        return self;
    }
    
    public func paddingRight(percent value:CGFloat)->Self{
        self.node?.paddingRight(percent: value);
        return self;
    }
    public func paddingRight(point value:CGFloat)->Self{
        self.node?.paddingRight(point:value);
        return self;
    }
    
    public func paddingBottom(percent value:CGFloat)->Self{
        self.node?.paddingBottom(percent: value);
        return self;
    }
    public func paddingBottom(point value:CGFloat)->Self{
        self.node?.paddingBottom(point:value);
        return self;
    }
    
    public func paddingStart(percent value:CGFloat)->Self{
        self.node?.paddingStart(percent: value);
        return self;
    }
    public func paddingStart(point value:CGFloat)->Self{
        self.node?.paddingStart(point:value);
        return self;
    }
    
    public func paddingEnd(percent value:CGFloat)->Self{
        self.node?.paddingEnd(percent: value);
        return self;
    }
    public func paddingEnd(point value:CGFloat)->Self{
        self.node?.paddingEnd(point:value);
        return self;
    }
    
    public func paddingH(percent value:CGFloat)->Self{
        self.node?.paddingH(percent: value);
        return self;
    }
    public func paddingH(point value:CGFloat)->Self{
        self.node?.paddingH(point:value);
        return self;
    }
    
    public func paddingV(percent value:CGFloat)->Self{
        self.node?.paddingV(percent: value);
        return self;
    }
    public func paddingV(point value:CGFloat)->Self{
        self.node?.paddingV(point:value);
        return self;
    }
    public func paddingAll(percent value:CGFloat)->Self{
        self.node?.marginAll(percent: value);
        return self;
    }
    public func paddingAll(point value:CGFloat)->Self{
        self.node?.marginAll(point:value);
        return self;
    }
}

extension View{
    public func borderLeftWidth(_ value:CGFloat)->Self{
        self.node?.borderLeftWidth(value);
        return self;
    }
    public func borderTopWidth(_ value:CGFloat)->Self{
        self.node?.borderTopWidth(value);
        return self;
    }
    public func borderRightWidth(_ value:CGFloat)->Self{
        self.node?.borderRightWidth(value);
        return self;
    }
    public func borderBottomWidth(_ value:CGFloat)->Self{
        self.node?.borderBottomWidth(value);
        return self;
    }
    public func borderStartWidth(_ value:CGFloat)->Self{
        self.node?.borderStartWidth(value);
        return self;
    }
    public func borderEndWidth(_ value:CGFloat)->Self{
        self.node?.borderEndWidth(value);
        return self;
    }
    public func borderWidth(_ value:CGFloat)->Self{
        self.node?.borderWidth(value);
        return self;
    }
}

extension View{
    public func width(percent value:CGFloat)->Self{
        self.node?.width(percent: value);
        return self;
    }
    public func width(point value:CGFloat)->Self{
        self.node?.width(point:value);
        return self;
    }
    
    public func height(percent value:CGFloat)->Self{
        self.node?.height(percent: value);
        return self;
    }
    public func height(point value:CGFloat)->Self{
        self.node?.height(point:value);
        return self;
    }
    
    public func minWidth(percent value:CGFloat)->Self{
        self.node?.minWidth(percent: value);
        return self;
    }
    public func minWidth(point value:CGFloat)->Self{
        self.node?.minWidth(point:value);
        return self;
    }
    public func minHeight(percent value:CGFloat)->Self{
        self.node?.minHeight(percent: value);
        return self;
    }
    public func minHeight(point value:CGFloat)->Self{
        self.node?.minHeight(point:value);
        return self;
    }
    
    public func maxWidth(percent value:CGFloat)->Self{
        self.node?.maxWidth(percent: value);
        return self;
    }
    public func maxWidth(point value:CGFloat)->Self{
        self.node?.maxWidth(point:value);
        return self;
    }
    public func maxHeight(percent value:CGFloat)->Self{
        self.node?.maxHeight(percent: value);
        return self;
    }
    public func maxHeight(point value:CGFloat)->Self{
        self.node?.maxHeight(point:value);
        return self;
    }
}
extension View{
    public func width()->CGFloat{
        return self.node?.width() ?? 0
    }
    public func height()->CGFloat{
        return self.node?.height() ?? 0
    }
    
    public func minWidth()->CGFloat{
        return self.node?.minWidth() ?? 0
    }
    public func minHeight()->CGFloat{
        return self.node?.minHeight() ?? 0
    }
    
    public func maxWidth()->CGFloat{
        return self.node?.maxWidth() ?? 0
    }
    public func maxHeight()->CGFloat{
        return self.node?.maxHeight() ?? 0
    }
}

extension View {
    
    public func endEditing(_ force: Bool) -> Self {
        self.node?.view?.endEditing(force)
        return self
    }
}
