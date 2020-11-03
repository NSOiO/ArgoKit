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
    public func alias<T>(variable ptr:inout T?) -> Self where T: View{
        ptr = self as? T
        return self
    }
}

extension View{
    public func addSubNodes(@ArgoKitViewBuilder builder:@escaping ()->View){
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                self.node!.addChildNode(node)
            }
        }
    }
}

// modifier

extension View {


    public func isUserInteractionEnabled(_ value:Bool)->Self{
        self.node?.view?.isUserInteractionEnabled = value
        return self
    }

    public func tag(_ value:Int)->Self{
        self.node?.view?.tag = value
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
    public func focusGroupIdentifier(_ value:String?)->Self{
        self.node?.view?.focusGroupIdentifier = value
        return self
    }
    
    @available(iOS 14.0, *)
    public func focusGroupIdentifier()-> String? {
        return self.node?.view?.focusGroupIdentifier
    }

    @available(iOS 9.0, *)
    public func semanticContentAttribute(_ value:UISemanticContentAttribute)->Self{
        self.node?.view?.semanticContentAttribute = value
        return self
    }
    public func semanticContentAttribute()->UISemanticContentAttribute?{
        return self.node?.view?.semanticContentAttribute
    }
    @available(iOS 10.0, *)
    public func effectiveUserInterfaceLayoutDirection()-> UIUserInterfaceLayoutDirection? {
        return self.node?.view?.effectiveUserInterfaceLayoutDirection
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




// UIGestureRecognizer
extension View{
    public func gesture(gesture:Gesture)->Self{
        gesture.gesture.isEnabled = true
        self.node?.view?.addGestureRecognizer(gesture.gesture)
        self.node?.addTarget(gesture.gesture, for: UIControl.Event.valueChanged) { (obj, paramter) in
            if let gestureRecognizer = obj as? UIGestureRecognizer {
                gesture.action(gestureRecognizer)
            }
            return nil
        }
        return self
    }
    public func removeGesture(gesture:Gesture)->Self{
        self.node?.view?.removeGestureRecognizer(gesture.gesture)
        return self
    }
}

extension View{
    public func tapAction(numberOfTaps: Int = 1, numberOfTouches: Int = 1,action:@escaping ()->Void)->Self{
        let gesture = TapGesture(numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
    
    public func longPressAction(numberOfTaps:Int, numberOfTouches:Int,minimumPressDuration:TimeInterval = 0.5,allowableMovement:CGFloat = 10,action:@escaping ()->Void)->Self{
        let gesture = LongPressGesture(numberOfTaps:numberOfTaps,numberOfTouches:numberOfTouches,minimumPressDuration:minimumPressDuration,allowableMovement:allowableMovement) { gesture in
            action()
        }
        return self.gesture(gesture:gesture)
    }
}


// layout
extension View{
    
    // 标记Node需要重新布局
    public func markNeedsLayout(){
        self.node?.markDirty()
    }
    
    public func parentNode()->ArgoKitNode?{
        var pNode:ArgoKitNode? = self.node?.parent
        if (pNode == nil) {
            return self.node
        }else{
            while (pNode?.parent != nil){
                pNode = pNode?.parent
            }
        }
        return pNode
       
    }
    
    public func applyLayout(){
        self.node?.applyLayout()
        ArgoLayoutHelper.addLayoutNode(self.node)
    }
    
    public func applyLayout(preservingOrigin:Bool){
        self.node?.applyLayout(preservingOrigin: preservingOrigin)
    }
    
    public func calculateLayout(size:CGSize){
        self.node?.calculateLayout(size:size)
    }
    
}
/*
 Layout direction specifies the direction in which children and text in a hierarchy should be laid out. Layout direction also effects what edge start and end refer to. By default Yoga lays out with LTR layout direction. In this mode start refers to left and end refers to right. When localizing your apps for markets with RTL languages you should customize this by either by passing a direction to the CalculateLayout call or by setting the direction on the root node.
 */
public enum ArgoDirection{
    case Inherit
    case LTR
    case RTL
}
extension View {
    public func direction(_ value:ArgoDirection)->Self{
        switch value{
        case .Inherit:
            self.node?.directionInherit()
            break
        case .LTR:
            self.node?.directionLTR()
            break
        case .RTL:
            self.node?.directionRTL()
            break
        }
        return self
    }
}
/*
 Flex direction controls the direction in which children of a node are laid out. This is also referred to as the main axis. The main axis is the direction in which children are laid out. The cross axis the the axis perpendicular to the main axis, or the axis which wrapping lines are laid out in.
 */
public enum ArgoFlexDirection{
    case column
    case columnReverse
    case row
    case rowReverse
}
extension View {
    public func flexDirection(_ value:ArgoFlexDirection)->Self{
        switch value{
        case .column:
            self.node?.column()
            break
        case .columnReverse:
            self.node?.columnREV()
            break
        case .row:
            self.node?.row()
            break
        case .rowReverse:
            self.node?.rowREV()
            break
        }
        return self
    }
}

/*
 ustify content describes how to align children within the main axis of their container. For example, you can use this property to center a child horizontally within a container with flex direction set to row or vertically within a container with flex direction set to column.
 */
public enum ArgoJustify{
    case start
    case center
    case end
    case between
    case around
    case evenly
}
extension View{
    public func justifyContent(_ value:ArgoJustify)->Self{
        switch value{
        case .start:
            self.node?.justifyContentFlexStart()
            break
        case .center:
            self.node?.justifyContentCenter()
            break
        case .end:
            self.node?.justifyContentFlexEnd()
            break
        case .between:
            self.node?.justifyContentSpaceBetween()
            break
        case .around:
            self.node?.justifyContentSpaceAround()
            break
        case .evenly:
            self.node?.justifyContentSpaceEvenly()
            break
        }
        return self
    }
}


public enum ArgoAlign{
    case auto
    case start
    case center
    case end
    case stretch
    case baseline
    case between
    case around
}
/*
 Align content defines the distribution of lines along the cross-axis. This only has effect when items are wrapped to multiple lines using flex wrap.
 */
extension View{
    public func alignContent(_ value:ArgoAlign)->Self{
        switch value{
        case .auto:
            self.node?.alignContentAuto()
            break
        case .start:
            self.node?.alignContentFlexStart()
            break
        case .center:
            self.node?.alignContentCenter()
            break
        case .end:
            self.node?.alignContentFlexEnd()
            break
        case .stretch:
            self.node?.alignContentStretch()
            break
        case .baseline:
            self.node?.alignContentBaseline()
            break
        case .between:
            self.node?.alignContentSpaceBetween()
            break
        case .around:
            self.node?.alignContentSpaceAround()
            break
        }
        return self
    }
}
/*
 Align items describes how to align children along the cross axis of their container. Align items is very similar to justify content but instead of applying to the main axis, align items applies to the cross axis.
 */
extension View{
    public func alignItems(_ value:ArgoAlign)->Self{
        switch value{
        case .auto:
            self.node?.alignContentAuto()
            break
        case .start:
            self.node?.alignItemsFlexStart()
            break
        case .center:
            self.node?.alignItemsCenter()
            break
        case .end:
            self.node?.alignItemsFlexEnd()
            break
        case .stretch:
            self.node?.alignItemsStretch()
            break
        case .baseline:
            self.node?.alignItemsBaseline()
            break
        case .between:
            self.node?.alignItemsSpaceBetween()
            break
        case .around:
            self.node?.alignItemsSpaceAround()
            break
        }
        return self
    }
}

/*
 Align self has the same options and effect as align items but instead of affecting the children within a container, you can apply this property to a single child to change its alignment within its parent. align self overrides any option set by the parent with align items.
 */
extension View{
    public func alignSelf(_ value:ArgoAlign)->Self{
        switch value{
        case .auto:
            self.node?.alignSelfAuto()
            break
        case .start:
            self.node?.alignSelfFlexStart()
            break
        case .center:
            self.node?.alignSelfCenter()
            break
        case .end:
            self.node?.alignSelfFlexEnd()
            break
        case .stretch:
            self.node?.alignSelfStretch()
            break
        case .baseline:
            self.node?.alignSelfBaseline()
            break
        case .between:
            self.node?.alignSelfSpaceBetween()
            break
        case .around:
            self.node?.alignSelfSpaceAround()
            break
        }
        return self
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

public struct ArgoValue {
    enum ValueType {
        case undefined
        case point
        case percent
        case auto
    }
    var value:CGFloat
    var type:ValueType
    
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
    
    public func basis(_ value:ArgoValue)->Self{
        switch value.type {
        case .auto:
            self.node?.flexBasisAuto()
            break
        case .point:
            self.node?.flexBasis(point: value.value)
            break
        case .percent:
            self.node?.flexBasis(percent: value.value)
            break
        default:
            break
        }
        return self;
    }
}

public enum ArgoEdge{
    case left
    case top
    case right
    case bottom
    case start
    case end
    case horizontal
    case vertical
    case all
}
extension View{
    public func position(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value.type {
            case .point:
                self.node?.left(point: value.value)
                break
            case .percent:
                self.node?.left(percent: value.value)
                break
            default:
                break
            }
            break
        case .top:
            switch value.type {
            case .point:
                self.node?.top(point: value.value)
                break
            case .percent:
                self.node?.top(percent: value.value)
                break
            default:
                break
            }
            break
        case .right:
            switch value.type {
            case .point:
                self.node?.right(point: value.value)
                break
            case .percent:
                self.node?.right(percent: value.value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value.type {
            case .point:
                self.node?.bottom(point: value.value)
                break
            case .percent:
                self.node?.bottom(percent: value.value)
                break
            default:
                break
            }
            break
        case .start:
            switch value.type {
            case .point:
                self.node?.start(point: value.value)
                break
            case .percent:
                self.node?.start(percent: value.value)
                break
            default:
                break
            }
            break
        case .end:
            switch value.type {
            case .point:
                self.node?.end(point: value.value)
                break
            case .percent:
                self.node?.end(percent: value.value)
                break
            default:
                break
            }
            break
        default:
            break
            
        }
        return self;
    }
}

extension View{
    public func margin(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value.type {
            case .point:
                self.node?.marginLeft(point: value.value)
                break
            case .percent:
                self.node?.marginLeft(percent: value.value)
                break
            default:
                break
            }
            break
        case .top:
            switch value.type {
            case .point:
                self.node?.marginTop(point: value.value)
                break
            case .percent:
                self.node?.marginTop(percent: value.value)
                break
            default:
                break
            }
            break
        case .right:
            switch value.type {
            case .point:
                self.node?.marginRight(point: value.value)
                break
            case .percent:
                self.node?.marginRight(percent: value.value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value.type {
            case .point:
                self.node?.marginBottom(point: value.value)
                break
            case .percent:
                self.node?.marginBottom(percent: value.value)
                break
            default:
                break
            }
            break
        case .start:
            switch value.type {
            case .point:
                self.node?.marginStart(point: value.value)
                break
            case .percent:
                self.node?.marginStart(percent: value.value)
                break
            default:
                break
            }
            break
        case .end:
            switch value.type {
            case .point:
                self.node?.marginEnd(point: value.value)
                break
            case .percent:
                self.node?.marginEnd(percent: value.value)
                break
            default:
                break
            }
            break
        case .horizontal:
            switch value.type {
            case .point:
                self.node?.marginH(point: value.value)
                break
            case .percent:
                self.node?.marginH(percent: value.value)
                break
            default:
                break
            }
            break
        case .vertical:
            switch value.type {
            case .point:
                self.node?.marginV(point: value.value)
                break
            case .percent:
                self.node?.marginV(percent: value.value)
                break
            default:
                break
            }
            break
        case .all:
            switch value.type {
            case .point:
                self.node?.marginAll(point: value.value)
                break
            case .percent:
                self.node?.marginAll(percent: value.value)
                break
            default:
                break
            }
            break

        }
        return self;
    }
}


extension View{
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value.type {
            case .point:
                self.node?.paddingLeft(point: value.value)
                break
            case .percent:
                self.node?.paddingLeft(percent: value.value)
                break
            default:
                break
            }
            break
        case .top:
            switch value.type {
            case .point:
                self.node?.paddingTop(point: value.value)
                break
            case .percent:
                self.node?.paddingTop(percent: value.value)
                break
            default:
                break
            }
            break
        case .right:
            switch value.type {
            case .point:
                self.node?.paddingRight(point: value.value)
                break
            case .percent:
                self.node?.paddingRight(percent: value.value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value.type {
            case .point:
                self.node?.paddingBottom(point: value.value)
                break
            case .percent:
                self.node?.paddingBottom(percent: value.value)
                break
            default:
                break
            }
            break
        case .start:
            switch value.type {
            case .point:
                self.node?.paddingStart(point: value.value)
                break
            case .percent:
                self.node?.paddingStart(percent: value.value)
                break
            default:
                break
            }
            break
        case .end:
            switch value.type {
            case .point:
                self.node?.paddingEnd(point: value.value)
                break
            case .percent:
                self.node?.paddingEnd(percent: value.value)
                break
            default:
                break
            }
            break
        case .horizontal:
            switch value.type {
            case .point:
                self.node?.paddingH(point: value.value)
                break
            case .percent:
                self.node?.paddingH(percent: value.value)
                break
            default:
                break
            }
            break
        case .vertical:
            switch value.type {
            case .point:
                self.node?.paddingV(point: value.value)
                break
            case .percent:
                self.node?.paddingV(percent: value.value)
                break
            default:
                break
            }
            break
        case .all:
            switch value.type {
            case .point:
                self.node?.paddingAll(point: value.value)
                break
            case .percent:
                self.node?.paddingAll(percent: value.value)
                break
            default:
                break
            }
            break

        }
        return self;
    }
    
}

extension View{
    public func  borderWidth(edge:ArgoEdge,value:CGFloat)->Self{
        switch edge {
        case .left:
            self.node?.borderLeftWidth(value)
            break
        case .top:
            self.node?.borderTopWidth(value)
            break
        case .right:
            self.node?.borderRightWidth(value)
            break
        case .bottom:
            self.node?.borderBottomWidth(value)
            break
        case .start:
            self.node?.borderStartWidth(value)
            break
        case .end:
            self.node?.borderEndWidth(value)
            break
        case .all:
            self.node?.borderWidth(value)
            break
        default:
            break
        }
        return self;
    }
}

extension View{
    public func width(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.width(point: value.value)
            break
        case .percent:
            self.node?.width(percent: value.value)
            break
        default:
            break
        }
        return self
    }
    public func height(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.height(point: value.value)
            break
        case .percent:
            self.node?.height(percent: value.value)
            break
        default:
            break
        }
        return self
    }
    
    public func minWidth(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.minWidth(point: value.value)
            break
        case .percent:
            self.node?.minWidth(percent: value.value)
            break
        default:
            break
        }
        return self
    }

    public func minHeight(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.minHeight(point: value.value)
            break
        case .percent:
            self.node?.minHeight(percent: value.value)
            break
        default:
            break
        }
        return self
    }

    public func maxWidth(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.maxWidth(point: value.value)
            break
        case .percent:
            self.node?.maxWidth(percent: value.value)
            break
        default:
            break
        }
        return self
    }
    
    public func maxHeight(_ value:ArgoValue)->Self{
        switch value.type {
        case .point:
            self.node?.maxHeight(point: value.value)
            break
        case .percent:
            self.node?.maxHeight(percent: value.value)
            break
        default:
            break
        }
        return self
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
