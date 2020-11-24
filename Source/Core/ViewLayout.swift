//
//  ViewLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/9.
//

import Foundation
// layout
extension View{
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
    
    public func applyLayout()->CGSize{
        return self.node?.applyLayout() ?? CGSize.zero
    }
    
    public func applyLayout(size:CGSize){
        self.node?.applyLayout(size:size)
      
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
    fileprivate func direction(_ value:ArgoDirection)->Self{
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
    fileprivate func flexDirection(_ value:ArgoFlexDirection)->Self{
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
public enum ArgoPositionType{
    case relative
    case absolute
}
extension View{
    public func positionType(_ value:ArgoPositionType)->Self{
        switch value {
        case .relative:
            self.node?.positionRelative();
            break
        case .absolute:
            self.node?.positionAbsolute();
            break
        }
        return self;
    }
}

public enum ArgoWrapType{
    case noWrap
    case wrap
    case wrapReverse
}

extension View{
    public func wrap(_ value:ArgoWrapType)->Self{
        switch value {
        case .noWrap:
            self.node?.flexWrapNoWrap();
            break
        case .wrap:
            self.node?.flexWrapWrap();
            break
        case .wrapReverse:
            self.node?.flexWrapWrapREV();
            break
        }
        return self;
    }
}

extension View{
    fileprivate func overflowVisible()->Self{
        self.node?.overflowVisible();
        return self;
    }
    fileprivate func overflowHidden()->Self{
        self.node?.overflowHidden();
        return self;
    }
    fileprivate func overflowScroll()->Self{
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
    fileprivate func flex(_ value:CGFloat)->Self{
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
        switch value {
        case .auto:
            self.node?.flexBasisAuto()
            break
        case .point(let value):
            self.node?.flexBasis(point: value)
            break
        case .percent(let value):
            self.node?.flexBasis(percent: value)
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
    public func position(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return position(edge: .top, value: top)
            .position(edge: .left, value: left)
            .position(edge: .bottom, value: bottom)
            .position(edge: .right, value:right)
    }
    public func position(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value {
            case .point(let value):
                self.node?.left(point: value)
                break
            case .percent(let value):
                self.node?.left(percent: value)
                break
            default:
                break
            }
            break
        case .top:
            switch value {
            case .point(let value):
                self.node?.top(point: value)
                break
            case .percent(let value):
                self.node?.top(percent: value)
                break
            default:
                break
            }
            break
        case .right:
            switch value{
            case .point(let value):
                self.node?.right(point: value)
                break
            case .percent(let value):
                self.node?.right(percent: value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value {
            case .point(let value):
                self.node?.bottom(point: value)
                break
            case .percent(let value):
                self.node?.bottom(percent: value)
                break
            default:
                break
            }
            break
        case .start:
            switch value {
            case .point(let value):
                self.node?.start(point: value)
                break
            case .percent(let value):
                self.node?.start(percent: value)
                break
            default:
                break
            }
            break
        case .end:
            switch value {
            case .point(let value):
                self.node?.end(point: value)
                break
            case .percent(let value):
                self.node?.end(percent: value)
                break
            default:
                break
            }
            break
        case .all:
            switch value {
            case .point(let value):
                self.node?.top(point: value)
                self.node?.left(point: value)
                self.node?.bottom(point: value)
                self.node?.right(point: value)
                break
            case .percent(let value):
                self.node?.top(percent: value)
                self.node?.left(percent: value)
                self.node?.bottom(percent: value)
                self.node?.right(percent: value)
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
    public func margin(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return margin(edge: .top, value: top)
            .margin(edge: .left, value: left)
            .margin(edge: .bottom, value: bottom)
            .margin(edge: .right, value:right)
    } 
    public func margin(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value {
            case .point(let value):
                self.node?.marginLeft(point: value)
                break
            case .percent(let value):
                self.node?.marginLeft(percent: value)
                break
            default:
                break
            }
            break
        case .top:
            switch value {
            case .point(let value):
                self.node?.marginTop(point: value)
                break
            case .percent(let value):
                self.node?.marginTop(percent: value)
                break
            default:
                break
            }
            break
        case .right:
            switch value {
            case .point(let value):
                self.node?.marginRight(point: value)
                break
            case .percent(let value):
                self.node?.marginRight(percent: value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value {
            case .point(let value):
                self.node?.marginBottom(point: value)
                break
            case .percent(let value):
                self.node?.marginBottom(percent: value)
                break
            default:
                break
            }
            break
        case .start:
            switch value {
            case .point(let value):
                self.node?.marginStart(point: value)
                break
            case .percent(let value):
                self.node?.marginStart(percent: value)
                break
            default:
                break
            }
            break
        case .end:
            switch value {
            case .point(let value):
                self.node?.marginEnd(point: value)
                break
            case .percent(let value):
                self.node?.marginEnd(percent: value)
                break
            default:
                break
            }
            break
        case .horizontal:
            switch value {
            case .point (let value):
                self.node?.marginH(point: value)
                break
            case .percent(let value):
                self.node?.marginH(percent: value)
                break
            default:
                break
            }
            break
        case .vertical:
            switch value {
            case .point(let value):
                self.node?.marginV(point: value)
                break
            case .percent(let value):
                self.node?.marginV(percent: value)
                break
            default:
                break
            }
            break
        case .all:
            switch value {
            case .point(let value):
                self.node?.marginAll(point: value)
                break
            case .percent(let value):
                self.node?.marginAll(percent: value)
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
    public func padding(top:ArgoValue,right:ArgoValue,bottom:ArgoValue,left:ArgoValue)->Self{
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    
    public func padding(edge:ArgoEdge,value:ArgoValue)->Self{
        switch edge {
        case .left:
            switch value {
            case .point(let value):
                self.node?.paddingLeft(point: value)
                break
            case .percent(let value):
                self.node?.paddingLeft(percent: value)
                break
            default:
                break
            }
            break
        case .top:
            switch value {
            case .point(let value):
                self.node?.paddingTop(point: value)
                break
            case .percent(let value):
                self.node?.paddingTop(percent: value)
                break
            default:
                break
            }
            break
        case .right:
            switch value {
            case .point(let value):
                self.node?.paddingRight(point: value)
                break
            case .percent(let value):
                self.node?.paddingRight(percent: value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value {
            case .point(let value):
                self.node?.paddingBottom(point: value)
                break
            case .percent(let value):
                self.node?.paddingBottom(percent: value)
                break
            default:
                break
            }
            break
        case .start:
            switch value {
            case .point(let value):
                self.node?.paddingStart(point: value)
                break
            case .percent(let value):
                self.node?.paddingStart(percent: value)
                break
            default:
                break
            }
            break
        case .end:
            switch value {
            case .point(let value):
                self.node?.paddingEnd(point: value)
                break
            case .percent(let value):
                self.node?.paddingEnd(percent: value)
                break
            default:
                break
            }
            break
        case .horizontal:
            switch value {
            case .point(let value):
                self.node?.paddingH(point: value)
                break
            case .percent(let value):
                self.node?.paddingH(percent: value)
                break
            default:
                break
            }
            break
        case .vertical:
            switch value {
            case .point(let value):
                self.node?.paddingV(point: value)
                break
            case .percent(let value):
                self.node?.paddingV(percent: value)
                break
            default:
                break
            }
            break
        case .all:
            switch value {
            case .point(let value):
                self.node?.paddingAll(point: value)
                break
            case .percent(let value):
                self.node?.paddingAll(percent: value)
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
    public func  borderWidth(top:CGFloat,right:CGFloat,bottom:CGFloat,left:CGFloat)->Self{
        return self.borderWidth(edge: .top, value: top)
            .borderWidth(edge: .right, value: right)
            .borderWidth(edge: .bottom, value: bottom)
            .borderWidth(edge: .left, value: left)
    }
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
    
    public func size(width: ArgoValue, height: ArgoValue) -> Self {
        return self.width(width).height(height)
    }
    
    public func width(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.width(point: value)
            break
        case .percent(let value):
            self.node?.width(percent:value)
            break
        default:
            break
        }
        return self
    }
    public func height(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.height(point: value)
            break
        case .percent(let value):
            self.node?.height(percent: value)
            break
        default:
            break
        }
        return self
    }
    
    public func minWidth(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.minWidth(point: value)
            break
        case .percent(let value):
            self.node?.minWidth(percent: value)
            break
        default:
            break
        }
        return self
    }

    public func minHeight(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.minHeight(point: value)
            break
        case .percent(let value):
            self.node?.minHeight(percent: value)
            break
        default:
            break
        }
        return self
    }

    public func maxWidth(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.maxWidth(point: value)
            break
        case .percent(let value):
            self.node?.maxWidth(percent: value)
            break
        default:
            break
        }
        return self
    }
    
    public func maxHeight(_ value:ArgoValue)->Self{
        switch value {
        case .point(let value):
            self.node?.maxHeight(point:value)
            break
        case .percent(let value):
            self.node?.maxHeight(percent: value)
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
    
    public func aspect(ratio: CGFloat) -> Self {
        self.node?.aspect(ratio:ratio)
        return self
    }
}
