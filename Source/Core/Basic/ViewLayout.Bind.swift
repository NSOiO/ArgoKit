//
//  ViewLayout.Bind.swift
//  ArgoKit
//
//  Created by xindong on 2020/12/31.
//

import Foundation

extension View {
    
    /// Sets the width of this view's border.
    /// - Parameters:
    ///   - top: The width of the top border of this view.
    ///   - right: The width of the right border of this view.
    ///   - bottom: The width of the bottom border of this view.
    ///   - left: The width of the left border of this view.
    /// - Returns: self
    @discardableResult
    private func  borderWidth(top:CGFloat,right:CGFloat,bottom:CGFloat,left:CGFloat)->Self{
        return self.borderWidth(edge: .top, value: top)
            .borderWidth(edge: .right, value: right)
            .borderWidth(edge: .bottom, value: bottom)
            .borderWidth(edge: .left, value: left)
    }
    
    /// Sets the width of this view's border.
    /// - Parameters:
    ///   - edge: The type of edge.
    ///   - value: The width of the border of this view.
    /// - Returns: self
    @discardableResult
    private func  borderWidth(edge: ArgoEdge, value: CGFloat) -> Self {
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
        return self
    }
}

extension View {
    
    /// Flex direction controls the direction in which children of a node are laid out. This is also referred to as the main axis. The main axis is the direction in which children are laid out. The cross axis the the axis perpendicular to the main axis, or the axis which wrapping lines are laid out in.
    /// - Parameter value: The type of flex direction.
    /// - Returns: self
    @discardableResult
    public func flexDirection(_ value: ArgoFlexDirection) -> Self {
        switch value {
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
    
    /// Ustify content describes how to align children within the main axis of their container. For example, you can use this property to center a child horizontally within a container with flex direction set to row or vertically within a container with flex direction set to column.
    /// - Parameter value: The type of justify content.
    /// - Returns: self
    @discardableResult
    public func justifyContent(_ value: ArgoJustify) -> Self {
        switch value {
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
    
    /// Align content defines the distribution of lines along the cross-axis. This only has effect when items are wrapped to multiple lines using flex wrap.
    /// - Parameter value: The type of align content.
    /// - Returns: self
    @discardableResult
    public func alignContent(_ value: ArgoAlign) -> Self {
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
    
    /// Align items describes how to align children along the cross axis of their container. Align items is very similar to justify content but instead of applying to the main axis, align items applies to the cross axis.
    /// - Parameter value: The type of align items.
    /// - Returns: self
    @discardableResult
    public func alignItems(_ value: ArgoAlign) -> Self {
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
    
    /// Align self has the same options and effect as align items but instead of affecting the children within a container, you can apply this property to a single child to change its alignment within its parent. align self overrides any option set by the parent with align items.
    /// - Parameter value: The type of align self.
    /// - Returns: self
    @discardableResult
    public func alignSelf(_ value: ArgoAlign) -> Self {
        switch value {
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

extension View {
    
    /// The flex wrap property is set on containers and controls what happens when children overflow the size of the container along the main axis. By default children are forced into a single line (which can shrink elements).
    /// If wrapping is allowed items are wrapped into multiple lines along the main axis if needed. wrap reverse behaves the same, but the order of the lines is reversed.
    /// - Parameter value: The type of flex wrap.
    /// - Returns: self
    @discardableResult
    public func wrap(_ value:ArgoWrapType) -> Self {
        switch value {
        case .noWrap:
            self.node?.flexWrapNoWrap()
            break
        case .wrap:
            self.node?.flexWrapWrap()
            break
        case .wrapReverse:
            self.node?.flexWrapWrapREV()
            break
        }
        return self
    }
    
    /// Sets how a flex item will grow or shrink to fit the space available in its flex container.
    /// - Parameter value: The value of flex.
    /// - Returns: self
    @discardableResult
    public func flex(_ value: CGFloat) -> Self {
        self.node?.flex(value)
        return self
    }
    
    /// Sets the flex grow factor of a flex item's main size.
    /// This property specifies how much of the remaining space in the flex container should be assigned to the item (the flex grow factor).
    /// - Parameter value: The value of grow.
    /// - Returns: self
    @discardableResult
    public func grow(_ value: CGFloat) -> Self {
        self.node?.flexGrow(value)
        return self
    }
    
    /// Sets the flex shrink factor of a flex item. If the size of all flex items is larger than the flex container, items shrink to fit according to flex-shrink.
    /// - Parameter value: The value of shrink.
    /// - Returns: self
    @discardableResult
    public func shrink(_ value: CGFloat) -> Self {
        self.node?.flexShrink(value)
        return self
    }
    
    /// Sets the initial main size of a flex item.
    /// - Parameter value: The type of basis.
    /// - Returns: self
    @discardableResult
    public func basis(_ value: ArgoValue) -> Self {
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
        return self
    }
    
}

extension View {
    
    /// The position type of this view defines how it is positioned within its parent.
    /// - Parameter value: The type of position.
    /// - Returns: self
    @discardableResult
    public func positionType(_ value: ArgoPositionType) -> Self {
        switch value {
        case .relative:
            self.node?.positionRelative()
            break
        case .absolute:
            self.node?.positionAbsolute()
            break
        }
        return self
    }
    
    /// Sets how this view is positioned in a view.
    /// - Parameters:
    ///   - top: The top style attribute defines the offset between the upper margin boundary of the positioned element and the upper boundary of its containing block.
    ///   - right: The right style attribute defines the offset between the right margin boundary of the positioned element and the right boundary of the containing block.
    ///   - bottom: The bottom style attribute defines the offset between the bottom margin boundary of the positioning element and the bottom boundary of its containing block.
    ///   - left: The left style attribute defines the offset between the left margin boundary of the positioned element and the left boundary of its containing block.
    /// - Returns: self
    @discardableResult
    public func position(top: ArgoValue, right: ArgoValue, bottom: ArgoValue, left: ArgoValue) -> Self {
        return position(edge: .top, value: top)
            .position(edge: .left, value: left)
            .position(edge: .bottom, value: bottom)
            .position(edge: .right, value:right)
    }
    
    /// Sets how this view is positioned in a view.
    /// - Parameters:
    ///   - edge: The type of Edge. left, top, right, bottom, start, end, all are valid.
    ///   - value: The value offset.
    /// - Returns: self
    @discardableResult
    public func position(edge: ArgoEdge, value: ArgoValue) -> Self {
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
        return self
    }
    
    /// Sets the margin area on all four sides of this view.
    /// - Parameters:
    ///   - top: The margin area on the top of this view
    ///   - right: The margin area on the right side of this view.
    ///   - bottom: The margin area on the bottom of this view.
    ///   - left: The margin area on the left side of this view.
    /// - Returns: self
    @discardableResult
    public func margin(top: ArgoValue, right: ArgoValue, bottom: ArgoValue, left: ArgoValue) -> Self {
        return margin(edge: .top, value: top)
            .margin(edge: .left, value: left)
            .margin(edge: .bottom, value: bottom)
            .margin(edge: .right, value:right)
    }
    
    /// Sets the margin area on specified side of this view.
    /// - Parameters:
    ///   - edge: The type of edge.
    ///   - value: The margin area on the edge of this view.
    /// - Returns: self
    @discardableResult
    public func margin(edge: ArgoEdge, value: ArgoValue) -> Self {
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
        return self
    }
    
    /// Sets the padding area on all four sides of this view at once.
    /// - Parameters:
    ///   - top: The height of the padding area on the top of this view.
    ///   - right: The width of the padding area on the right of this view.
    ///   - bottom: The height of the padding area on the bottom of this view.
    ///   - left: The width of the padding area to the left of this view.
    /// - Returns: self
    @discardableResult
    public func padding(top: ArgoValue, right: ArgoValue, bottom: ArgoValue, left: ArgoValue) -> Self {
        return padding(edge: .top, value: top)
            .padding(edge: .left, value: left)
            .padding(edge: .bottom, value: bottom)
            .padding(edge: .right, value:right)
    }
    
    /// Sets the padding area on specified side  of this view.
    /// - Parameters:
    ///   - edge: The type of edge.
    ///   - value: The padding area on the edge of this view.
    /// - Returns: self
    @discardableResult
    public func padding(edge: ArgoEdge, value: ArgoValue) -> Self {
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
        return self
    }
}

extension View {
    
    /// Sets the width of this view.
    /// - Parameter value: The width of this view.
    /// - Returns: self
    @discardableResult
    public func width(_ value: ArgoValue) -> Self {
        switch value {
        case .point(let value):
            self.node?.width(point: value)
            break
        case .percent(let value):
            self.node?.width(percent:value)
            break
        case .auto:
            self.node?.widthAuto()
            break
        default:
            break
        }
        return self
    }
    
    /// Sets the height of this view.
    /// - Parameter value: The height of this view.
    /// - Returns: self
    @discardableResult
    public func height(_ value: ArgoValue) -> Self {
        switch value {
        case .point(let value):
            self.node?.height(point: value)
            break
        case .percent(let value):
            self.node?.height(percent: value)
            break
        case .auto:
            self.node?.heightAuto()
            break
        default:
            break
        }
        return self
    }
    
    /// Sets the minimum width of this view.
    /// - Parameter value: The minimum width of this view.
    /// - Returns: self
    @discardableResult
    public func minWidth(_ value: ArgoValue) -> Self {
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
    
    /// Sets the minimum height of this view.
    /// - Parameter value: The minimum height of this view.
    /// - Returns: self
    @discardableResult
    public func minHeight(_ value: ArgoValue) -> Self {
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
    
    /// Sets the maximal width of this view.
    /// - Parameter value: The maximal width of this view.
    /// - Returns: self
    @discardableResult
    public func maxWidth(_ value: ArgoValue) -> Self {
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
    
    /// Sets the maximal height of this view.
    /// - Parameter value: The maximal height of this view.
    /// - Returns: self
    @discardableResult
    public func maxHeight(_ value: ArgoValue) -> Self {
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
    
    /// Sets the size of this view.
    /// - Parameters:
    ///   - width: The width of this view.
    ///   - height: The height of this view.
    /// - Returns: self
    @discardableResult
    public func size(width: ArgoValue, height: ArgoValue) -> Self {
        return self.width(width).height(height)
    }
}

extension View {
    
    /// Sets the aspect ratio of this view.
    /// - Parameter value: The aspect ratio of this view.
    /// - Returns: self
    @discardableResult
    public func aspect(ratio: CGFloat) -> Self {
        self.node?.aspect(ratio:ratio)
        return self
    }
}
