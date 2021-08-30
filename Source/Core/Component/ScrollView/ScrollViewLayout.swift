//
//  ScrollViewLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2021/5/24.
//

import Foundation

extension ScrollView {
    @available(*, deprecated, message: "ScrollView does not support cornerRadius(topLeft:topRight:bottomLeft:bottomRight), Please use cornerRadius(_ value)")
    public func cornerRadius(topLeft: @escaping @autoclosure () -> CGFloat, topRight: @escaping @autoclosure () -> CGFloat, bottomLeft: @escaping @autoclosure () -> CGFloat, bottomRight: @escaping @autoclosure () -> CGFloat) -> Self {
        return self
    }
}

extension ScrollView {
    
    /// Sets the width of this view's border.
    /// - Parameters:
    ///   - top: The width of the top border of this view.
    ///   - right: The width of the right border of this view.
    ///   - bottom: The width of the bottom border of this view.
    ///   - left: The width of the left border of this view.
    /// - Returns: self
    @discardableResult
    private func borderWidth(top:@escaping @autoclosure () -> CGFloat,right:@escaping @autoclosure () -> CGFloat,bottom:@escaping @autoclosure () -> CGFloat,left:@escaping @autoclosure () -> CGFloat)->Self{
        return self.bindCallback({ [self] in
            self.borderWidth(edge: .top, value: top())
                .borderWidth(edge: .right, value: right())
                .borderWidth(edge: .bottom, value: bottom())
                .borderWidth(edge: .left, value: left())
        }, forKey: #function)
    }
    
    /// Sets the width of this view's border.
    /// - Parameters:
    ///   - edge: The type of edge.
    ///   - value: The width of the border of this view.
    /// - Returns: self
    @discardableResult
    private func borderWidth(edge: @escaping @autoclosure () -> ArgoEdge, value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            switch edge(){
            case .left:
                self.pNode?.borderLeftWidth(value())
                self.pNode?.contentNode?.borderLeftWidth(value())
                break
            case .top:
                self.pNode?.borderTopWidth(value())
                self.pNode?.contentNode?.borderTopWidth(value())
                break
            case .right:
                self.pNode?.borderRightWidth(value())
                self.pNode?.contentNode?.borderRightWidth(value())
                break
            case .bottom:
                self.pNode?.borderBottomWidth(value())
                self.pNode?.contentNode?.borderBottomWidth(value())
                break
            case .start:
                self.pNode?.borderStartWidth(value())
                self.pNode?.contentNode?.borderStartWidth(value())
                break
            case .end:
                self.pNode?.borderEndWidth(value())
                self.pNode?.contentNode?.borderEndWidth(value())
                break
            case .all:
                self.pNode?.borderWidth(value())
                self.pNode?.contentNode?.borderWidth(value())
                break
            default:
                break
            }
        }, forKey: #function)
    }
}

extension ScrollView {
    /// Layout direction specifies the direction in which children and text in a hierarchy should be laid out. Layout direction also effects what edge start and end refer to. By default Yoga lays out with LTR layout direction. In this mode start refers to left and end refers to right. When localizing your apps for markets with RTL languages you should customize this by either by passing a direction to the CalculateLayout call or by setting the direction on the root node.
    /// - Parameter value: The type of flex direction.
    /// - Returns: self
    @discardableResult
    public func direction(_ value: ArgoDirection) -> Self {
        switch value {
        case .Inherit:
            self.pNode?.directionInherit()
            self.pNode?.contentNode?.directionInherit()
            break
        case .LTR:
            self.pNode?.directionLTR()
            self.pNode?.contentNode?.directionLTR()
            break
        case .RTL:
            self.pNode?.directionRTL()
            self.pNode?.contentNode?.directionRTL()
            break
        }
        return self
    }
    
    /// Flex direction controls the direction in which children of a node are laid out. This is also referred to as the main axis. The main axis is the direction in which children are laid out. The cross axis the the axis perpendicular to the main axis, or the axis which wrapping lines are laid out in.
    /// - Parameter value: The type of flex direction.
    /// - Returns: self
    @discardableResult
    public func flexDirection(_ value: @escaping @autoclosure () -> ArgoFlexDirection) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .column:
                self.pNode?.column()
                self.pNode?.contentNode?.column()
                break
            case .columnReverse:
                self.pNode?.columnREV()
                self.pNode?.contentNode?.columnREV()
                break
            case .row:
                self.pNode?.row()
                self.pNode?.contentNode?.row()
                break
            case .rowReverse:
                self.pNode?.rowREV()
                self.pNode?.contentNode?.rowREV()
                break
            }
        }, forKey: #function)
    }
    
    /// Ustify content describes how to align children within the main axis of their container. For example, you can use this property to center a child horizontally within a container with flex direction set to row or vertically within a container with flex direction set to column.
    /// - Parameter value: The type of justify content.
    /// - Returns: self
    @discardableResult
    public func justifyContent(_ value: @escaping @autoclosure () -> ArgoJustify) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .start:
                self.pNode?.justifyContentFlexStart()
                self.pNode?.contentNode?.justifyContentFlexStart()
                break
            case .center:
                self.pNode?.justifyContentCenter()
                self.pNode?.contentNode?.justifyContentCenter()
                break
            case .end:
                self.pNode?.justifyContentFlexEnd()
                self.pNode?.contentNode?.justifyContentFlexEnd()
                break
            case .between:
                self.pNode?.justifyContentSpaceBetween()
                self.pNode?.contentNode?.justifyContentSpaceBetween()
                break
            case .around:
                self.pNode?.justifyContentSpaceAround()
                self.pNode?.contentNode?.justifyContentSpaceAround()
                break
            case .evenly:
                self.pNode?.justifyContentSpaceEvenly()
                self.pNode?.contentNode?.justifyContentSpaceEvenly()
                break
            }
        }, forKey: #function)
    }
    
    /// Align content defines the distribution of lines along the cross-axis. This only has effect when items are wrapped to multiple lines using flex wrap.
    /// - Parameter value: The type of align content.
    /// - Returns: self
    @discardableResult
    public func alignContent(_ value: @escaping @autoclosure () -> ArgoAlign) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .auto:
                self.pNode?.alignContentAuto()
                self.pNode?.contentNode?.alignContentAuto()
                break
            case .start:
                self.pNode?.alignContentFlexStart()
                self.pNode?.contentNode?.alignContentFlexStart()
                break
            case .center:
                self.pNode?.alignContentCenter()
                self.pNode?.contentNode?.alignContentCenter()
                break
            case .end:
                self.pNode?.alignContentFlexEnd()
                self.pNode?.contentNode?.alignContentFlexEnd()
                break
            case .stretch:
                self.pNode?.alignContentStretch()
                self.pNode?.contentNode?.alignContentStretch()
                break
            case .baseline:
                self.pNode?.alignContentBaseline()
                self.pNode?.contentNode?.alignContentBaseline()
                break
            case .between:
                self.pNode?.alignContentSpaceBetween()
                self.pNode?.contentNode?.alignContentSpaceBetween()
                break
            case .around:
                self.pNode?.alignContentSpaceAround()
                self.pNode?.contentNode?.alignContentSpaceAround()
                break
            }
        }, forKey: #function)
    }
    
    /// Align items describes how to align children along the cross axis of their container. Align items is very similar to justify content but instead of applying to the main axis, align items applies to the cross axis.
    /// - Parameter value: The type of align items.
    /// - Returns: self
    @discardableResult
    public func alignItems(_ value: @escaping @autoclosure () -> ArgoAlign) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .auto:
                self.pNode?.alignContentAuto()
                self.pNode?.contentNode?.alignContentAuto()
                break
            case .start:
                self.pNode?.alignItemsFlexStart()
                self.pNode?.contentNode?.alignItemsFlexStart()
                break
            case .center:
                self.pNode?.alignItemsCenter()
                self.pNode?.contentNode?.alignItemsCenter()
                break
            case .end:
                self.pNode?.alignItemsFlexEnd()
                self.pNode?.contentNode?.alignItemsFlexEnd()
                break
            case .stretch:
                self.pNode?.alignItemsStretch()
                self.pNode?.contentNode?.alignItemsStretch()
                break
            case .baseline:
                self.pNode?.alignItemsBaseline()
                self.pNode?.contentNode?.alignItemsBaseline()
                break
            case .between:
                self.pNode?.alignItemsSpaceBetween()
                self.pNode?.contentNode?.alignItemsSpaceBetween()
                break
            case .around:
                self.pNode?.alignItemsSpaceAround()
                self.pNode?.contentNode?.alignItemsSpaceAround()
                break
            }
        }, forKey: #function)
    }
    
    /// Align self has the same options and effect as align items but instead of affecting the children within a container, you can apply this property to a single child to change its alignment within its parent. align self overrides any option set by the parent with align items.
    /// - Parameter value: The type of align self.
    /// - Returns: self
    @discardableResult
    public func alignSelf(_ value: @escaping @autoclosure () -> ArgoAlign) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .auto:
                self.pNode?.alignSelfAuto()
                self.pNode?.contentNode?.alignSelfAuto()
                break
            case .start:
                self.pNode?.alignSelfFlexStart()
                self.pNode?.contentNode?.alignSelfFlexStart()
                break
            case .center:
                self.pNode?.alignSelfCenter()
                self.pNode?.contentNode?.alignSelfCenter()
                break
            case .end:
                self.pNode?.alignSelfFlexEnd()
                self.pNode?.contentNode?.alignSelfFlexEnd()
                break
            case .stretch:
                self.pNode?.alignSelfStretch()
                self.pNode?.contentNode?.alignSelfStretch()
                break
            case .baseline:
                self.pNode?.alignSelfBaseline()
                self.pNode?.contentNode?.alignSelfBaseline()
                break
            case .between:
                self.pNode?.alignSelfSpaceBetween()
                self.pNode?.contentNode?.alignSelfSpaceBetween()
                break
            case .around:
                self.pNode?.alignSelfSpaceAround()
                self.pNode?.contentNode?.alignSelfSpaceAround()
                break
            }
        }, forKey: #function)
    }
}

extension ScrollView {
    
    /// The flex wrap property is set on containers and controls what happens when children overflow the size of the container along the main axis. By default children are forced into a single line (which can shrink elements).
    /// If wrapping is allowed items are wrapped into multiple lines along the main axis if needed. wrap reverse behaves the same, but the order of the lines is reversed.
    /// - Parameter value: The type of flex wrap.
    /// - Returns: self
    @discardableResult
    public func wrap(_ value:@escaping @autoclosure () -> ArgoWrapType) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .noWrap:
                self.pNode?.flexWrapNoWrap()
                self.pNode?.contentNode?.flexWrapNoWrap()
                break
            case .wrap:
                self.pNode?.flexWrapWrap()
                self.pNode?.contentNode?.flexWrapWrap()
                break
            case .wrapReverse:
                self.pNode?.flexWrapWrapREV()
                self.pNode?.contentNode?.flexWrapWrapREV()
                break
            }
        }, forKey: #function)
    }
    
    /// Sets how a flex item will grow or shrink to fit the space available in its flex container.
    /// - Parameter value: The value of flex.
    /// - Returns: self
    @discardableResult
    public func flex(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            self.pNode?.flex(value())
            self.pNode?.contentNode?.flex(value())
        }, forKey: #function)
    }
    
    /// Sets the flex grow factor of a flex item's main size.
    /// This property specifies how much of the remaining space in the flex container should be assigned to the item (the flex grow factor).
    /// - Parameter value: The value of grow.
    /// - Returns: self
    @discardableResult
    public func grow(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            self.pNode?.flexGrow(value())
            self.pNode?.contentNode?.flexGrow(value())
        }, forKey: #function)
    }
    
    /// Sets the flex shrink factor of a flex item. If the size of all flex items is larger than the flex container, items shrink to fit according to flex-shrink.
    /// - Parameter value: The value of shrink.
    /// - Returns: self
    @discardableResult
    public func shrink(_ value: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            self.pNode?.flexShrink(value())
            self.pNode?.contentNode?.flexShrink(value())
        }, forKey: #function)
    }
    
    /// Sets the initial main size of a flex item.
    /// - Parameter value: The type of basis.
    /// - Returns: self
    @discardableResult
    public func basis(_ value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .auto:
                self.pNode?.flexBasisAuto()
                self.pNode?.contentNode?.flexBasisAuto()
                break
            case .point(let value):
                self.pNode?.flexBasis(point: value)
                self.pNode?.contentNode?.flexBasis(point: value)
                break
            case .percent(let value):
                self.pNode?.flexBasis(percent: value)
                self.pNode?.contentNode?.flexBasis(percent: value)
                break
            default:
                break
            }
        }, forKey: #function)
    }
    
}

extension ScrollView {
    
    /// The position type of this view defines how it is positioned within its parent.
    /// - Parameter value: The type of position.
    /// - Returns: self
    @discardableResult
    public func positionType(_ value: @escaping @autoclosure () -> ArgoPositionType) -> Self {
        return self.bindCallback({ [self] in
            switch value(){
            case .relative:
                self.pNode?.positionRelative()
                self.pNode?.contentNode?.positionRelative()
                break
            case .absolute:
                self.pNode?.positionAbsolute()
                self.pNode?.contentNode?.positionAbsolute()
                break
            }
        }, forKey: #function)
    }
    
    /// Sets how this view is positioned in a view.
    /// - Parameters:
    ///   - top: The top style attribute defines the offset between the upper margin boundary of the positioned element and the upper boundary of its containing block.
    ///   - right: The right style attribute defines the offset between the right margin boundary of the positioned element and the right boundary of the containing block.
    ///   - bottom: The bottom style attribute defines the offset between the bottom margin boundary of the positioning element and the bottom boundary of its containing block.
    ///   - left: The left style attribute defines the offset between the left margin boundary of the positioned element and the left boundary of its containing block.
    /// - Returns: self
    @discardableResult
    public func position(top: @escaping @autoclosure () -> ArgoValue, right: @escaping @autoclosure () -> ArgoValue, bottom: @escaping @autoclosure () -> ArgoValue, left: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            _position_(edge: .top, value: top())
                ._position_(edge: .left, value: left())
                ._position_(edge: .bottom, value: bottom())
                ._position_(edge: .right, value:right())
        }, forKey: #function)
    }
    
    /// Sets how this view is positioned in a view.
    /// - Parameters:
    ///   - edge: The type of Edge. left, top, right, bottom, start, end, all are valid.
    ///   - value: The value offset.
    /// - Returns: self
    @discardableResult
    public func position(edge: @escaping @autoclosure () -> ArgoEdge, value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            _position_(edge: edge(), value: value())
        }, forKey: #function)
    }
    
    @discardableResult
    private func _position_(edge:ArgoEdge, value:ArgoValue) -> Self {
        switch edge{
        case .left:
            switch value{
            case .point(let value):
                self.pNode?.left(point: value)
                self.pNode?.contentNode?.left(point: value)
                break
            case .percent(let value):
                self.pNode?.left(percent: value)
                self.pNode?.contentNode?.left(percent: value)
                break
            default:
                break
            }
            break
        case .top:
            switch value{
            case .point(let value):
                self.pNode?.top(point: value)
                self.pNode?.contentNode?.top(point: value)
                break
            case .percent(let value):
                self.pNode?.top(percent: value)
                self.pNode?.contentNode?.top(percent: value)
                break
            default:
                break
            }
            break
        case .right:
            switch value{
            case .point(let value):
                self.pNode?.right(point: value)
                self.pNode?.contentNode?.right(point: value)
                break
            case .percent(let value):
                self.pNode?.right(percent: value)
                self.pNode?.contentNode?.right(percent: value)
                break
            default:
                break
            }
            break
        case .bottom:
            switch value{
            case .point(let value):
                self.pNode?.bottom(point: value)
                self.pNode?.contentNode?.bottom(point: value)
                break
            case .percent(let value):
                self.pNode?.bottom(percent: value)
                self.pNode?.contentNode?.bottom(percent: value)
                break
            default:
                break
            }
            break
        case .start:
            switch value{
            case .point(let value):
                self.pNode?.start(point: value)
                self.pNode?.contentNode?.start(point: value)
                break
            case .percent(let value):
                self.pNode?.start(percent: value)
                self.pNode?.contentNode?.start(percent: value)
                break
            default:
                break
            }
            break
        case .end:
            switch value{
            case .point(let value):
                self.pNode?.end(point: value)
                self.pNode?.contentNode?.end(point: value)
                break
            case .percent(let value):
                self.pNode?.end(percent: value)
                self.pNode?.contentNode?.end(percent: value)
                break
            default:
                break
            }
            break
        case .all:
            switch value{
            case .point(let value):
                self.pNode?.top(point: value)
                self.pNode?.left(point: value)
                self.pNode?.bottom(point: value)
                self.pNode?.right(point: value)
                
                self.pNode?.contentNode?.top(point: value)
                self.pNode?.contentNode?.left(point: value)
                self.pNode?.contentNode?.bottom(point: value)
                self.pNode?.contentNode?.right(point: value)
                break
            case .percent(let value):
                self.pNode?.top(percent: value)
                self.pNode?.left(percent: value)
                self.pNode?.bottom(percent: value)
                self.pNode?.right(percent: value)
                
                self.pNode?.contentNode?.top(percent: value)
                self.pNode?.contentNode?.left(percent: value)
                self.pNode?.contentNode?.bottom(percent: value)
                self.pNode?.contentNode?.right(percent: value)
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
    public func margin(top: @escaping @autoclosure () -> ArgoValue, right: @escaping @autoclosure () -> ArgoValue, bottom: @escaping @autoclosure () -> ArgoValue, left: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            _margin_(edge: .top, value: top())
                ._margin_(edge: .left, value: left())
                ._margin_(edge: .bottom, value: bottom())
                ._margin_(edge: .right, value:right())
        }, forKey: #function)
    }
    
    /// Sets the margin area on specified side of this view.
    /// - Parameters:
    ///   - edge: The type of edge.
    ///   - value: The margin area on the edge of this view.
    /// - Returns: self
    @discardableResult
    public func margin(edge: @escaping @autoclosure () -> ArgoEdge, value: @escaping @autoclosure () -> ArgoValue) -> Self {
        return self.bindCallback({ [self] in
            self._margin_(edge: edge(), value: value())
        }, forKey: #function)
    }
    
    @discardableResult
    private func _margin_(edge:ArgoEdge, value:ArgoValue) -> Self {
        switch edge{
        case .left:
            switch value{
            case .point(let value):
                self.pNode?.marginLeft(point: value)
                self.pNode?.contentNode?.marginLeft(point: value)
                break
            case .percent(let value):
                self.pNode?.marginLeft(percent: value)
                self.pNode?.contentNode?.marginLeft(percent: value)
                break
            case .auto:
                self.pNode?.marginLeftWithAuto()
                self.pNode?.contentNode?.marginLeftWithAuto()
                break
            default:
                break
            }
            break
        case .top:
            switch value{
            case .point(let value):
                self.pNode?.marginTop(point: value)
                self.pNode?.contentNode?.marginTop(point: value)
                break
            case .percent(let value):
                self.pNode?.marginTop(percent: value)
                self.pNode?.contentNode?.marginTop(percent: value)
                break
            case .auto:
                self.pNode?.marginTopWithAuto()
                self.pNode?.contentNode?.marginTopWithAuto()
                break
            default:
                break
            }
            break
        case .right:
            switch value{
            case .point(let value):
                self.pNode?.marginRight(point: value)
                self.pNode?.contentNode?.marginRight(point: value)
                break
            case .percent(let value):
                self.pNode?.marginRight(percent: value)
                self.pNode?.contentNode?.marginRight(percent: value)
                break
            case .auto:
                self.pNode?.marginRightWithAuto()
                self.pNode?.contentNode?.marginRightWithAuto()
                break
            default:
                break
            }
            break
        case .bottom:
            switch value{
            case .point(let value):
                self.pNode?.marginBottom(point: value)
                self.pNode?.contentNode?.marginBottom(point: value)
                break
            case .percent(let value):
                self.pNode?.marginBottom(percent: value)
                self.pNode?.contentNode?.marginBottom(percent: value)
                break
            case .auto:
                self.pNode?.marginBottomWithAuto()
                self.pNode?.contentNode?.marginBottomWithAuto()
                break
            default:
                break
            }
            break
        case .start:
            switch value{
            case .point(let value):
                self.pNode?.marginStart(point: value)
                self.pNode?.contentNode?.marginStart(point: value)
                break
            case .percent(let value):
                self.pNode?.marginStart(percent: value)
                self.pNode?.contentNode?.marginStart(percent: value)
                break
            case .auto:
                self.pNode?.marginStartWithAuto()
                self.pNode?.contentNode?.marginStartWithAuto()
                break
            default:
                break
            }
            break
        case .end:
            switch value{
            case .point(let value):
                self.pNode?.marginEnd(point: value)
                self.pNode?.contentNode?.marginEnd(point: value)
                break
            case .percent(let value):
                self.pNode?.marginEnd(percent: value)
                self.pNode?.contentNode?.marginEnd(percent: value)
                break
            case .auto:
                self.pNode?.marginEndWithAuto()
                self.pNode?.contentNode?.marginEndWithAuto()
                break
            default:
                break
            }
            break
        case .horizontal:
            switch value{
            case .point (let value):
                self.pNode?.marginH(point: value)
                self.pNode?.contentNode?.marginH(point: value)
                break
            case .percent(let value):
                self.pNode?.marginH(percent: value)
                self.pNode?.contentNode?.marginH(percent: value)
                break
            case .auto:
                self.pNode?.marginHWithAuto()
                self.pNode?.contentNode?.marginHWithAuto()
                break
            default:
                break
            }
            break
        case .vertical:
            switch value{
            case .point(let value):
                self.pNode?.marginV(point: value)
                self.pNode?.contentNode?.marginV(point: value)
                break
            case .percent(let value):
                self.pNode?.marginV(percent: value)
                self.pNode?.contentNode?.marginV(percent: value)
                break
            case .auto:
                self.pNode?.marginVWithAuto()
                self.pNode?.contentNode?.marginVWithAuto()
                break
            default:
                break
            }
            break
        case .all:
            switch value{
            case .point(let value):
                self.pNode?.marginAll(point: value)
                self.pNode?.contentNode?.marginAll(point: value)
                break
            case .percent(let value):
                self.pNode?.marginAll(percent: value)
                self.pNode?.contentNode?.marginAll(percent: value)
                break
            case .auto:
                self.pNode?.marginAllWithAuto()
                self.pNode?.contentNode?.marginAllWithAuto()
                break
            default:
                break
            }
            break
        }
        return self
    }
}
extension ScrollView {
    
    /// Sets the aspect ratio of this view.
    /// - Parameter value: The aspect ratio of this view.
    /// - Returns: self
    @discardableResult
    public func aspect(ratio: @escaping @autoclosure () -> CGFloat) -> Self {
        return self.bindCallback({ [self] in
            self.pNode?.aspect(ratio:ratio())
            self.pNode?.contentNode?.aspect(ratio:ratio())
        }, forKey: #function)
    }
}
