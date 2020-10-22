//
//  Node.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class ArgoKitLayout;


@interface ArgoKitNode : NSObject
// 布局layout
@property (nonatomic, strong, readonly, nullable) ArgoKitLayout *layout;
@property (nonatomic, strong,nullable)  ArgoKitNode  *parentNode;
@property (nonatomic, strong, readonly,nullable)  NSMutableArray<ArgoKitNode *> *childs;
@property (nonatomic, strong, readonly, nullable) UIView *view;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
- (instancetype)initWithView:(UIView *)view;
- (void)addChildNode:(ArgoKitNode *)node;
- (void)done;
/*
 Layout direction specifies the direction in which children and text in a hierarchy should be laid out. Layout direction also effects what edge start and end refer to. By default Yoga lays out with LTR layout direction. In this mode start refers to left and end refers to right. When localizing your apps for markets with RTL languages you should customize this by either by passing a direction to the CalculateLayout call or by setting the direction on the root node.
 */
- (void)directionInherit;
/// Text and children and laid out from left to right. Margin and padding applied the start of an element are applied on the left side.
- (void)directionLTR;

/// Text and children and laid out from right to left. Margin and padding applied the start of an element are applied on the right side.
- (void)directionRTL;


/*
 Flex direction controls the direction in which children of a node are laid out. This is also referred to as the main axis. The main axis is the direction in which children are laid out. The cross axis the the axis perpendicular to the main axis, or the axis which wrapping lines are laid out in.
 */

/// Align children from top to bottom. If wrapping is enabled then the next line will start to the left first item on the top of the container.
- (void)column;

/// Align children from bottom to top. If wrapping is enabled then the next line will start to the left first item on the bottom of the container.
- (void)columnREV;

/// Align children from left to right. If wrapping is enabled then the next line will start under the first item on the left of the container.
- (void)row;

/// Align children from right to left. If wrapping is enabled then the next line will start under the first item on the right of the container.
- (void)rowREV;

/*
 ustify content describes how to align children within the main axis of their container. For example, you can use this property to center a child horizontally within a container with flex direction set to row or vertically within a container with flex direction set to column.
 */

/// Align children of a container to the start of the container's main axis.
- (void)justifyContentFlexStart;

/// Align children of a container in the center of the container's main axis.
- (void)justifyContentCenter;

/// Align children of a container to the end of the container's main axis.
- (void)justifyContentFlexEnd;

/// Evenly space of children across the container's main axis, distributing remaining space between the children.
- (void)justifyContentSpaceBetween;

/// Evenly space of children across the container's main axis, distributing remaining space around the children. Compared to space between using space around will result in space being distributed to the beginning of the first child and end of the last child.
- (void)justifyContentSpaceAround;

/// Evenly distributed within the alignment container along the main axis. The spacing between each pair of adjacent items, the main-start edge and the first item, and the main-end edge and the last item, are all exactly the same.
- (void)justifyContentSpaceEvenly;

/*
 Align content defines the distribution of lines along the cross-axis. This only has effect when items are wrapped to multiple lines using flex wrap.
 */
- (void)alignContentAuto;

/// Align wrapped lines to the start of the container's cross axis. default
- (void)alignContentFlexStart;

/// Align wrapped lines in the center of the container's cross axis.
- (void)alignContentCenter;

/// Align wrapped lines to the end of the container's cross axis.
- (void)alignContentFlexEnd;

/// Stretch wrapped lines to match the height of the container's cross axis.
- (void)alignContentStretch;

/// <#Description#>
- (void)alignContentBaseline;

/// Evenly space wrapped lines across the container's main axis, distributing remaining space between the lines.
- (void)alignContentSpaceBetween;

///  Evenly space wrapped lines across the container's main axis, distributing remaining space around the lines. Compared to space between using space around will result in space being distributed to the begining of the first lines and end of the last line.
- (void)alignContentSpaceAround;

/*
 Align items describes how to align children along the cross axis of their container. Align items is very similar to justify content but instead of applying to the main axis, align items applies to the cross axis.
 */
- (void)alignItemsAuto;

/// Description Align children of a container to the start of the container's cross axis.
- (void)alignItemsFlexStart;

/// Align children of a container in the center of the container's cross axis.
- (void)alignItemsCenter;

/// Align children of a container to the end of the container's cross axis.
- (void)alignItemsFlexEnd;

/// Stretch children of a container to match the height of the container's cross axis.
- (void)alignItemsStretch;

/// Align children of a container along a common baseline. Individual children can be set to be the reference baseline for their parents.
- (void)alignItemsBaseline;
- (void)alignItemsSpaceBetween;
- (void)alignItemsSpaceAround;

/*
 Align self has the same options and effect as align items but instead of affecting the children within a container, you can apply this property to a single child to change its alignment within its parent. align self overrides any option set by the parent with align items.
 */
- (void)alignSelfAuto;
- (void)alignSelfFlexStart;
- (void)alignSelfCenter;
- (void)alignSelFlexEnd;
- (void)alignSelfStretch;
- (void)alignSelfBaseline;
- (void)alignSelfSpaceBetween;
- (void)alignSelfSpaceAround;

/*
 The position type of an element defines how it is positioned within its parent.
 */

/// RELATIVE (DEFAULT) By default an element is positioned relatively. This means an element is positioned according to the normal flow of the layout, and then offset relative to that position based on the values of top, right, bottom, and left. The offset does not affect the position of any sibling or parent elements.
- (void)positionRelative;

/// ABSOLUTE When positioned absolutely an element doesn't take part in the normal layout flow. It is instead laid out independent of its siblings. The position is determined based on the top, right, bottom, and left values.
- (void)positionAbsolute;

/*
 The flex wrap property is set on containers and controls what happens when children overflow the size of the container along the main axis. By default children are forced into a single line (which can shrink elements).
 
 If wrapping is allowed items are wrapped into multiple lines along the main axis if needed. wrap reverse behaves the same, but the order of the lines is reversed.
 */
- (void)flexWrapNoWrap;
- (void)flexWrapWrap;
- (void)flexWrapWrapREV;

- (void)overflowVisible;
- (void)overflowHidden;
- (void)overflowScroll;

//DisplayFlex, DisplayNone
- (void)displayFlex;
- (void)displayNone;


- (void)flex:(CGFloat)value;
- (void)flexGrow:(CGFloat)value;
- (void)flexShrink:(CGFloat)value;


- (void)flexBasisAuto;
/// Percentage of parent classes
/// @param value Value range is [0,100.0]
- (void)flexBasisWithPercent:(CGFloat)value NS_SWIFT_NAME(flexBasis(percent:));
- (void)flexBasisWithPoint:(CGFloat)value NS_SWIFT_NAME(flexBasis(point:));


- (void)leftWithPercent:(CGFloat)value NS_SWIFT_NAME(left(percent:));
- (void)leftWithPoint:(CGFloat)value NS_SWIFT_NAME(left(point:));

- (void)topWithPercent:(CGFloat)value NS_SWIFT_NAME(top(percent:));
- (void)topWithPoint:(CGFloat)value NS_SWIFT_NAME(top(point:));

- (void)rightWithPercent:(CGFloat)value NS_SWIFT_NAME(right(percent:));
- (void)rightWithPoint:(CGFloat)value NS_SWIFT_NAME(right(point:));

- (void)bottomWithPercent:(CGFloat)value NS_SWIFT_NAME(bottom(percent:));
- (void)bottomWithPoint:(CGFloat)value NS_SWIFT_NAME(bottom(point:));

- (void)startWithPercent:(CGFloat)value NS_SWIFT_NAME(start(percent:));
- (void)startWithPoint:(CGFloat)value NS_SWIFT_NAME(start(point:));

- (void)endWithPercent:(CGFloat)value NS_SWIFT_NAME(end(percent:));
- (void)endWithPoint:(CGFloat)value NS_SWIFT_NAME(end(point:));


- (void)marginLeftWithPercent:(CGFloat)value NS_SWIFT_NAME(marginLeft(percent:));
- (void)marginLeftWithPoint:(CGFloat)value NS_SWIFT_NAME(marginLeft(point:));

- (void)marginTopWithPercent:(CGFloat)value NS_SWIFT_NAME(marginTop(percent:));
- (void)marginTopWithPoint:(CGFloat)value NS_SWIFT_NAME(marginTop(point:));

- (void)marginRightWithPercent:(CGFloat)value NS_SWIFT_NAME(marginRight(percent:));
- (void)marginRightWithPoint:(CGFloat)value NS_SWIFT_NAME(marginRight(point:));

- (void)marginBottomWithPercent:(CGFloat)value NS_SWIFT_NAME(marginBottom(percent:));
- (void)marginBottomWithPoint:(CGFloat)value NS_SWIFT_NAME(marginBottom(point:));

- (void)marginStartWithPercent:(CGFloat)value NS_SWIFT_NAME(marginStart(percent:));
- (void)marginStartWithPoint:(CGFloat)value NS_SWIFT_NAME(marginStart(point:));

- (void)marginEndWithPercent:(CGFloat)value NS_SWIFT_NAME(marginEnd(percent:));
- (void)marginEndWithPoint:(CGFloat)value NS_SWIFT_NAME(marginEnd(point:));

- (void)marginHWithPercent:(CGFloat)value NS_SWIFT_NAME(marginH(percent:));
- (void)marginHWithPoint:(CGFloat)value NS_SWIFT_NAME(marginH(point:));

- (void)marginVWithPercent:(CGFloat)value NS_SWIFT_NAME(marginV(percent:));
- (void)marginVWithPoint:(CGFloat)value NS_SWIFT_NAME(marginV(point:));

- (void)marginAllWithPercent:(CGFloat)value NS_SWIFT_NAME(marginAll(percent:));
- (void)marginAllWithPoint:(CGFloat)value NS_SWIFT_NAME(marginAll(point:));


- (void)paddingLeftWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingLeft(percent:));
- (void)paddingLeftWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingLeft(point:));


- (void)paddingTopWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingTop(percent:));
- (void)paddingTopWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingTop(point:));

- (void)paddingRightWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingRight(percent:));
- (void)paddingRightWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingRight(point:));

- (void)paddingBottomWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingBottom(percent:));
- (void)paddingBottomWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingBottom(point:));

- (void)paddingStartWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingStart(percent:));
- (void)paddingStartWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingStart(point:));

- (void)paddingEndWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingEnd(percent:));
- (void)paddingEndWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingEnd(point:));

- (void)paddingHWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingH(percent:));
- (void)paddingHWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingH(point:));

- (void)paddingVWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingV(percent:));
- (void)paddingVWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingV(point:));

- (void)paddingAllWithPercent:(CGFloat)value NS_SWIFT_NAME(paddingAll(percent:));
- (void)paddingAllWithPoint:(CGFloat)value NS_SWIFT_NAME(paddingAll(point:));


- (void)borderLeftWidth:(CGFloat)value;
- (void)borderTopWidth:(CGFloat)value;
- (void)borderRightWidth:(CGFloat)value;
- (void)borderBottomWidth:(CGFloat)value;
- (void)borderStartWidth:(CGFloat)value;
- (void)borderEndWidth:(CGFloat)value;
- (void)borderWidth:(CGFloat)value;

- (void)widthWithAuto;
- (void)widthWithPercent:(CGFloat)value NS_SWIFT_NAME(width(percent:));
- (void)widthWithPoint:(CGFloat)value NS_SWIFT_NAME(width(point:));

- (void)heightAuto;
- (void)heightWithPercent:(CGFloat)value NS_SWIFT_NAME(height(percent:));
- (void)heightWithPoint:(CGFloat)value NS_SWIFT_NAME(height(point:));

- (void)minWidthWithPercent:(CGFloat)value NS_SWIFT_NAME(minWidth(percent:));
- (void)minWidthWithPoint:(CGFloat)value NS_SWIFT_NAME(minWidth(point:));

- (void)minHeightWithPercent:(CGFloat)value NS_SWIFT_NAME(minHeight(percent:));
- (void)minHeightWithPoint:(CGFloat)value NS_SWIFT_NAME(minHeight(point:));


- (void)maxWidthWithPercent:(CGFloat)value NS_SWIFT_NAME(maxWidth(percent:));
- (void)maxWidthWithPoint:(CGFloat)value NS_SWIFT_NAME(maxWidth(point:));

- (void)maxHeightWithPercent:(CGFloat)value NS_SWIFT_NAME(maxHeight(percent:));
- (void)maxHeightWithPoint:(CGFloat)value NS_SWIFT_NAME(maxHeight(point:));
@end
NS_ASSUME_NONNULL_END
