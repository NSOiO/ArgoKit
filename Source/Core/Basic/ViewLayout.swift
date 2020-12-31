//
//  ViewLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/9.
//

import Foundation

// layout
extension View {
    
    /// Gets the parent node of this view.
    /// - Returns: The parent node of this view.
    public func parentNode() -> ArgoKitNode? {
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
    
    /// Perform a layout calculation and update the frames of the views in the hierarchy with the results. If the origin is not preserved, the root view's layout results will applied from {0,0}.
    /// - Returns: The size of the view based on provided constraints.
    @discardableResult
    public func applyLayout() -> CGSize {
        return self.node?.applyLayout() ?? CGSize.zero
    }
    
    /// Perform a layout calculation and update the frames of the views in the hierarchy with the results. Pass NaN for an unconstrained dimension.
    /// - Parameter size: The size for which the view should calculate its best-fitting size.
    /// - Returns: The size of the view based on provided constraints.
    @discardableResult
    public func applyLayout(size:CGSize) -> CGSize {
        return self.node?.applyLayout(size:size) ?? CGSize.zero
    }
    
    /// Perform a layout calculation but do not update the frames of the views in the hierarchy with the results. Pass NaN for an unconstrained dimension.
    /// - Parameter size: The size for which the view should calculate its best-fitting size.
    /// - Returns: The size of the view based on provided constraints.
    @discardableResult
    public func calculateLayout(size:CGSize) -> CGSize {
        return self.node?.calculateLayout(size:size) ?? CGSize.zero
    }
}


/// Layout direction specifies the direction in which children and text in a hierarchy should be laid out. Layout direction also effects what edge start and end refer to. By default Yoga lays out with LTR layout direction. In this mode start refers to left and end refers to right. When localizing your apps for markets with RTL languages you should customize this by either by passing a direction to the CalculateLayout call or by setting the direction on the root node.
public enum ArgoDirection {
    
    case Inherit
    
    /// Text and children and laid out from left to right. Margin and padding applied the start of a view are applied on the left side.
    case LTR
    
    /// Text and children and laid out from right to left. Margin and padding applied the start of a view are applied on the right side.
    case RTL
}

extension View {
    
    @discardableResult
    fileprivate func direction(_ value: ArgoDirection) -> Self {
        switch value {
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

public enum ArgoFlexDirection {
    
    /// Align children from top to bottom. If wrapping is enabled then the next line will start to the left first item on the top of the container.
    case column
    
    /// Align children from bottom to top. If wrapping is enabled then the next line will start to the left first item on the bottom of the container.
    case columnReverse
    
    /// Align children from left to right. If wrapping is enabled then the next line will start under the first item on the left of the container.
    case row
    
    /// Align children from right to left. If wrapping is enabled then the next line will start under the first item on the right of the container.
    case rowReverse
}

public enum ArgoJustify {
    
    /// Align children of a container to the start of the container's main axis.
    case start
    
    /// Align children of a container in the center of the container's main axis.
    case center
    
    /// Align children of a container to the end of the container's main axis.
    case end
    
    /// Evenly space of children across the container's main axis, distributing remaining space between the children.
    case between
    
    /// Evenly space of children across the container's main axis, distributing remaining space around the children. Compared to space between using space around will result in space being distributed to the beginning of the first child and end of the last child.
    case around
    
    /// Evenly distributed within the alignment container along the main axis. The spacing between each pair of adjacent items, the main-start edge and the first item, and the main-end edge and the last item, are all exactly the same.
    case evenly
}

public enum ArgoAlign {
    
    case auto
    
    /// Align wrapped lines to the start of the container's cross axis. default
    case start
    
    /// Align wrapped lines in the center of the container's cross axis.
    case center
    
    /// Align wrapped lines to the end of the container's cross axis.
    case end
    
    /// Stretch wrapped lines to match the height of the container's cross axis.
    case stretch
    
    /// Evenly space wrapped lines across the container's main axis, distributing remaining space along a common baseline.
    case baseline
    
    /// Evenly space wrapped lines across the container's main axis, distributing remaining space between the lines.
    case between
    
    ///  Evenly space wrapped lines across the container's main axis, distributing remaining space around the lines. Compared to space between using space around will result in space being distributed to the begining of the first lines and end of the last line.
    case around
}

public enum ArgoPositionType {
    
    /// By default a view is positioned relatively. This means a view is positioned according to the normal flow of the layout, and then offset relative to that position based on the values of top, right, bottom, and left. The offset does not affect the position of any sibling or parent elements.
    case relative
    
    /// When positioned absolutely a view doesn't take part in the normal layout flow. It is instead laid out independent of its siblings. The position is determined based on the top, right, bottom, and left values.
    case absolute
}

public enum ArgoWrapType {

    /// The flex items are laid out in a single line which may cause the flex container to overflow. The cross-start is either equivalent to start or before depending on the flex-direction value. This is the default value.
    case noWrap
    
    /// The flex items break into multiple lines. The cross-start is either equivalent to start or before depending flex-direction value and the cross-end is the opposite of the specified cross-start.
    case wrap
    
    /// Behaves the same as wrap but cross-start and cross-end are permuted.
    case wrapReverse
}

extension View {
    
    @discardableResult
    fileprivate func overflowVisible() -> Self {
        self.node?.overflowVisible()
        return self
    }
    fileprivate func overflowHidden() -> Self {
        self.node?.overflowHidden()
        return self
    }
    fileprivate func overflowScroll() -> Self {
        self.node?.overflowScroll()
        return self
    }
    
    public func displayFlex() -> Self {
        self.node?.displayFlex()
        return self
    }
    
    public func displayNone() -> Self {
        self.node?.displayNone()
        return self
    }
}

public enum ArgoEdge {
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

extension View {
    
    /// Gets the width of this view.
    /// - Returns: The width of this view.
    public func width() -> CGFloat {
        return self.node?.width() ?? 0
    }
    
    /// Gets the height of this view.
    /// - Returns: The height of this view.
    public func height() -> CGFloat {
        return self.node?.height() ?? 0
    }
    
    /// Gets the minimum width of this view.
    /// - Returns: The minimum width of this view.
    public func minWidth() -> CGFloat {
        return self.node?.minWidth() ?? 0
    }
    
    /// Gets the minimum height of this view.
    /// - Returns: The minimum height of this view.
    public func minHeight() -> CGFloat {
        return self.node?.minHeight() ?? 0
    }
    
    /// Gets the maximal width of this view.
    /// - Returns: The maximal width of this view.
    public func maxWidth() -> CGFloat {
        return self.node?.maxWidth() ?? 0
    }
    
    /// Gets the maximal height of this view.
    /// - Returns: The maximal height of this view.
    public func maxHeight() -> CGFloat {
        return self.node?.maxHeight() ?? 0
    }
}
