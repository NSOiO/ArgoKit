//
//  ArgoKitNode+Frame.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/6.
//

#import "ArgoKitNode+Frame.h"
#import "yoga/Yoga.h"
@class ArgoKitLayout;

@interface ArgoKitLayout: NSObject
@property (nonatomic, assign, readonly) YGNodeRef ygnode;
@end
@interface ArgoKitNode()
// 布局layout
@property (nonatomic, strong,readonly) ArgoKitLayout *layout;
@end
@implementation ArgoKitNode(Frame)
- (void)direction:(YGDirection)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetDirection(node, value);
     
}
- (void)directionInherit{
    return [self direction:YGDirectionInherit];
}
- (void)directionLTR{
    return [self direction:YGDirectionLTR];
}
- (void)directionRTL{
    return [self direction:YGDirectionRTL];
}

- (void)flexDirection:(YGFlexDirection)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexDirection(node, value);
     
}
- (void)column{
    return [self flexDirection:YGFlexDirectionColumn];
}
- (void)columnREV{
    return [self flexDirection:YGFlexDirectionColumnReverse];
}
- (void)row{
    return [self flexDirection:YGFlexDirectionRow];
}
- (void)rowREV{
    return [self flexDirection:YGFlexDirectionRowReverse];
}

- (void)justifyContent:(YGJustify)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetJustifyContent(node, value);
     
}

- (void)justifyContentFlexStart{
    return [self justifyContent:YGJustifyFlexStart];
}
- (void)justifyContentCenter{
    return [self justifyContent:YGJustifyCenter];
}
- (void)justifyContentFlexEnd{
    return [self justifyContent:YGJustifyFlexEnd];
}
- (void)justifyContentSpaceBetween{
    return [self justifyContent:YGJustifySpaceBetween];
}
- (void)justifyContentSpaceAround{
    return [self justifyContent:YGJustifySpaceAround];
}
- (void)justifyContentSpaceEvenly{
    return [self justifyContent:YGJustifySpaceEvenly];
}

- (void)alignContent:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignContent(node, value);
   
     
}
- (void)alignContentAuto{
    return [self alignContent:YGAlignAuto];
}
- (void)alignContentFlexStart{
    return [self alignContent:YGAlignFlexStart];
}
- (void)alignContentCenter{
    return [self alignContent:YGAlignCenter];
}
- (void)alignContentFlexEnd{
    return [self alignContent:YGAlignFlexEnd];
}
- (void)alignContentStretch{
    return [self alignContent:YGAlignStretch];
}
- (void)alignContentBaseline{
    return [self alignContent:YGAlignBaseline];
}
- (void)alignContentSpaceBetween{
    return [self alignContent:YGAlignSpaceBetween];
}
- (void)alignContentSpaceAround{
    return [self alignContent:YGAlignSpaceAround];
}


- (void)alignItems:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignItems(node, value);
     
}
- (void)alignItemsAuto{
    return [self alignItems:YGAlignAuto];
}
- (void)alignItemsFlexStart{
    return [self alignItems:YGAlignFlexStart];
}
- (void)alignItemsCenter{
    return [self alignItems:YGAlignCenter];
}
- (void)alignItemsFlexEnd{
    return [self alignItems:YGAlignFlexEnd];
}
- (void)alignItemsStretch{
    return [self alignItems:YGAlignStretch];
}
- (void)alignItemsBaseline{
    return [self alignItems:YGAlignBaseline];
}
- (void)alignItemsSpaceBetween{
    return [self alignItems:YGAlignSpaceBetween];
}
- (void)alignItemsSpaceAround{
    return [self alignItems:YGAlignSpaceAround];
}

- (void)alignSelf:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignSelf(node, value);
     
}
- (void)alignSelfAuto{
    return [self alignSelf:YGAlignAuto];
}
- (void)alignSelfFlexStart{
    return [self alignSelf:YGAlignFlexStart];
}
- (void)alignSelfCenter{
    return [self alignSelf:YGAlignCenter];
}
- (void)alignSelfFlexEnd{
    return [self alignSelf:YGAlignFlexEnd];
}
- (void)alignSelfStretch{
    return [self alignSelf:YGAlignStretch];
}
- (void)alignSelfBaseline{
    return [self alignSelf:YGAlignBaseline];
}
- (void)alignSelfSpaceBetween{
    return [self alignSelf:YGAlignSpaceBetween];
}
- (void)alignSelfSpaceAround{
    return [self alignSelf:YGAlignSpaceAround];
}

- (void)position:(YGPositionType)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPositionType(node, value);
     
}
- (void)positionRelative{
    return [self position:YGPositionTypeRelative];
}
- (void)positionAbsolute{
    return [self position:YGPositionTypeAbsolute];
}

- (void)flexWrap:(YGWrap)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexWrap(node, value);
     
}
- (void)flexWrapNoWrap{
    return [self flexWrap:YGWrapNoWrap];
}
- (void)flexWrapWrap{
    return [self flexWrap:YGWrapWrap];
}
- (void)flexWrapWrapREV{
    return [self flexWrap:YGWrapWrapReverse];
}

- (void)overflow:(YGOverflow)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetOverflow(node, value);
     
}
- (void)overflowVisible{
    return [self overflow:YGOverflowVisible];
}
- (void)overflowHidden{
    return [self overflow:YGOverflowHidden];
}
- (void)overflowScroll{
    return [self overflow:YGOverflowScroll];
}

- (void)display:(YGDisplay)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetDisplay(node, value);
    
     
}
- (void)displayFlex{
    return [self display:YGDisplayFlex];
}
- (void)displayNone{
    return [self display:YGDisplayNone];
}

- (void)flex:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlex(node, value);
     
}
- (void)flexGrow:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexGrow(node, value);
     
}
- (void)flexShrink:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexShrink(node, value);
    
     
}

- (void)flexBasis:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitAuto:
            YGNodeStyleSetFlexBasisAuto(node);
            break;
        case YGUnitPercent:
            YGNodeStyleSetFlexBasisPercent(node, value.value);
            break;
        case YGUnitPoint:
            YGNodeStyleSetFlexBasis(node, value.value);
            break;
        default:
            break;
    }
     
}
- (void)flexBasisAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexBasisAuto(node);
     
}
- (void)flexBasisWithPercent:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    if(value > 100.0){
        value = 100.0;
    }
    YGNodeStyleSetFlexBasisPercent(node, (float)value);
     
}
- (void)flexBasisWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexBasis(node, (float)value);
     
}

- (void)left:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeLeft, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeLeft, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)positionWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPositionPercent(node, edge, (float)value);
     
}
- (void)positionWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPosition(node, edge, (float)value);
     
}
- (void)leftWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeLeft];
}
- (void)leftWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeLeft];
}

- (void)topWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeTop];
}
- (void)topWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeTop];
}

- (void)top:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeTop, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeTop, value.value);
            break;
        default:
            break;
    }
     
}

- (void)right:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeRight, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeRight, value.value);
            break;
        default:
            break;
    }
     
}
- (void)rightWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeRight];
}
- (void)rightWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeRight];
}
- (void)bottom:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeBottom, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeBottom, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)bottomWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeBottom];
}
- (void)bottomWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeBottom];
}
- (void)start:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeStart, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeStart, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)startWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeStart];
}
- (void)startWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeStart];
}
- (void)end:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeEnd, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeEnd, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)endWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeEnd];
}
- (void)endWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeEnd];
}


- (void)marginWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMarginPercent(node, edge, (float)value);
     
}
- (void)marginWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMargin(node, edge, (float)value);
     
}


- (void)marginLeft:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeLeft, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeLeft, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginLeftWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeLeft];
}
- (void)marginLeftWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeLeft];
}

- (void)marginTop:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeTop, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeTop, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginTopWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeTop];
}
- (void)marginTopWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeTop];
}
- (void)marginRight:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeRight, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeRight, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginRightWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeRight];
}
- (void)marginRightWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeRight];
}
- (void)marginBottom:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeBottom, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeBottom, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginBottomWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeBottom];
}
- (void)marginBottomWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeBottom];
}
- (void)marginStart:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeStart, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeStart, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginStartWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeStart];
}
- (void)marginStartWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeStart];
}

- (void)marginEnd:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeEnd, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeEnd, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginEndWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeEnd];
}
- (void)marginEndWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeEnd];
}

- (void)marginHorizontal:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeHorizontal, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeHorizontal, value.value);
            break;
        default:
            break;
    }
     
}
- (void)marginHWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeHorizontal];
}
- (void)marginHWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeHorizontal];
}

- (void)marginVertical:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeVertical, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeVertical, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginVWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeVertical];
}
- (void)marginVWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeVertical];
}

- (void)margin:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeAll, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeAll, value.value);
            break;
        default:
            break;
    }
     
}

- (void)marginAllWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeAll];
}
- (void)marginAllWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeAll];
}


- (void)paddingWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPaddingPercent(node, edge, (float)value);
     
}
- (void)paddingWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPadding(node, edge, (float)value);
     
}


- (void)paddingLeftWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeLeft];
}
- (void)paddingLeftWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeLeft];
}

- (void)paddingTopWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeTop];
}
- (void)paddingTopWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeTop];
}

- (void)paddingRightWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeRight];
}
- (void)paddingRightWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeRight];
}

- (void)paddingBottomWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeBottom];
}
- (void)paddingBottomWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeBottom];
}

- (void)paddingStartWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeStart];
}
- (void)paddingStartWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeStart];
}

- (void)paddingEndWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeEnd];
}
- (void)paddingEndWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeEnd];
}

- (void)paddingHWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeHorizontal];
}
- (void)paddingHWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeHorizontal];
}

- (void)paddingVWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeVertical];
}
- (void)paddingVWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeVertical];
}

- (void)paddingAllWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeAll];
}
- (void)paddingAllWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeAll];
}


- (void)borderLeftWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeLeft, value);
    
     
}
- (void)borderTopWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeTop, value);
    
     
}
- (void)borderRightWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeRight, value);
    
     
}
- (void)borderBottomWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeBottom, value);
    
     
}
- (void)borderStartWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeStart, value);
    
     
}
- (void)borderEndWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeEnd, value);

     
}
- (void)borderWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeAll, value);
    
     
}

- (void)widthAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidthAuto(node);
     
}
- (void)widthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidthPercent(node,(float)value);
     
}
- (void)widthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidth(node, (float)value);
}

- (CGFloat)width{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetWidth(node).value)) {
        return 0;
    }
    return YGNodeStyleGetWidth(node).value;
}

- (void)heightAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeightAuto(node);
     
}
- (void)heightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeightPercent(node,(float)value);
     
}
- (void)heightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeight(node, (float)value);
}
- (CGFloat)height{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetHeight(node).value)) {
        return 0;
    }
    return YGNodeStyleGetHeight(node).value;
}

- (void)minWidthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinWidthPercent(node,(float)value);
     
}
- (void)minWidthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinWidth(node, (float)value);
}
- (CGFloat)minWidth{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetMinWidth(node).value)) {
        return 0;
    }
    return YGNodeStyleGetMinWidth(node).value;
}

- (void)minHeightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinHeightPercent(node,(float)value);
}
- (void)minHeightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinHeight(node, (float)value);
}

- (CGFloat)minHeight{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetMinHeight(node).value)) {
        return 0;
    }
    return YGNodeStyleGetMinHeight(node).value;
}

- (void)maxWidthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxWidthPercent(node,(float)value);
     
}
- (void)maxWidthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxWidth(node, (float)value);
}

- (CGFloat)maxWidth{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetMaxWidth(node).value)) {
        return 0;
    }
    return YGNodeStyleGetMaxWidth(node).value;
}

- (void)maxHeightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxHeightPercent(node,(float)value);
     
}
- (void)maxHeightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxHeight(node, (float)value);
}
- (CGFloat)maxHeight{
    YGNodeRef node = self.layout.ygnode;
    if (isnan(YGNodeStyleGetMaxHeight(node).value)) {
        return 0;
    }
    return YGNodeStyleGetMaxHeight(node).value;
}
- (void)aspectRatio:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAspectRatio(node,value);
}
@end
